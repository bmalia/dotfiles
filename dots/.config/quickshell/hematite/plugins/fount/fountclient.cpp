#include "fountclient.hpp"
#include "bincode.hpp"

#include <qdir.h>
#include <qendian.h>
#include <qfileinfo.h>
#include <qloggingcategory.h>
#include <qprocess.h>
#include <qstandardpaths.h>

#include <algorithm>

namespace hematite::fount {

FountClient::FountClient(QObject* parent)
    : QObject(parent)
    , m_results(new FountResultModel(this))
    , m_socketPath(resolveDefaultSocketPath()) {
    m_reconnectTimer.setSingleShot(true);

    connect(&m_socket, &QLocalSocket::connected, this, &FountClient::onSocketConnected);
    connect(&m_socket, &QLocalSocket::disconnected, this, &FountClient::onSocketDisconnected);
    connect(&m_socket, &QLocalSocket::readyRead, this, &FountClient::onSocketReadyRead);
    connect(&m_socket, &QLocalSocket::errorOccurred, this, &FountClient::onSocketError);
    connect(&m_reconnectTimer, &QTimer::timeout, this, &FountClient::onReconnectTimer);

    // If instantiated from C++ outside QML parser lifecycle, connect on next event loop tick
    QTimer::singleShot(0, this, [this]() {
        if (!m_componentCompleted) {
            m_componentCompleted = true;
            connectToDaemon();
        }
    });
}

FountClient::~FountClient() {
    m_manualDisconnect = true;
    m_reconnectTimer.stop();
    m_socket.disconnect(this);
    if (m_socket.state() != QLocalSocket::UnconnectedState) {
        m_socket.abort();
    }
}

void FountClient::classBegin() {}

void FountClient::componentComplete() {
    if (!m_componentCompleted) {
        m_componentCompleted = true;
        connectToDaemon();
    }
}

QString FountClient::resolveDefaultSocketPath() {
    const QByteArray runtimeDir = qgetenv("XDG_RUNTIME_DIR");
    if (!runtimeDir.isEmpty()) {
        return QDir(QString::fromLocal8Bit(runtimeDir)).filePath(QStringLiteral("fount.sock"));
    }
    return QStringLiteral("/tmp/fount.sock");
}

QString FountClient::socketPath() const {
    return m_socketPath;
}

void FountClient::setSocketPath(const QString& path) {
    const QString resolved = path.isEmpty() ? resolveDefaultSocketPath() : path;
    if (m_socketPath == resolved) {
        return;
    }
    m_socketPath = resolved;
    emit socketPathChanged();

    if (m_componentCompleted && !m_manualDisconnect) {
        m_socket.abort();
        connectToDaemon();
    }
}

QString FountClient::query() const {
    return m_query;
}

void FountClient::setQuery(const QString& query) {
    if (m_query == query) {
        return;
    }
    m_query = query;
    emit queryChanged();

    if (isConnected()) {
        sendSearchRequest();
    }
}

int FountClient::limit() const {
    return m_limit;
}

void FountClient::setLimit(int limit) {
    const int clamped = std::max(1, limit);
    if (m_limit == clamped) {
        return;
    }
    m_limit = clamped;
    emit limitChanged();

    if (isConnected()) {
        sendSearchRequest();
    }
}

bool FountClient::isConnected() const {
    return m_socket.state() == QLocalSocket::ConnectedState;
}

bool FountClient::autoReconnect() const {
    return m_autoReconnect;
}

void FountClient::setAutoReconnect(bool enabled) {
    if (m_autoReconnect == enabled) {
        return;
    }
    m_autoReconnect = enabled;
    emit autoReconnectChanged();

    if (!m_autoReconnect) {
        m_reconnectTimer.stop();
    } else if (!isConnected() && !m_manualDisconnect && m_componentCompleted) {
        scheduleReconnect();
    }
}

bool FountClient::autoStartDaemon() const {
    return m_autoStartDaemon;
}

void FountClient::setAutoStartDaemon(bool enabled) {
    if (m_autoStartDaemon == enabled) {
        return;
    }
    m_autoStartDaemon = enabled;
    emit autoStartDaemonChanged();
}

QString FountClient::daemonProgram() const {
    return m_daemonProgram;
}

void FountClient::setDaemonProgram(const QString& program) {
    if (m_daemonProgram == program) {
        return;
    }
    m_daemonProgram = program;
    emit daemonProgramChanged();
}

bool FountClient::autoSearchOnConnect() const {
    return m_autoSearchOnConnect;
}

void FountClient::setAutoSearchOnConnect(bool enabled) {
    if (m_autoSearchOnConnect == enabled) {
        return;
    }
    m_autoSearchOnConnect = enabled;
    emit autoSearchOnConnectChanged();
}

FountResultModel* FountClient::results() const {
    return m_results;
}

void FountClient::search(const QString& query) {
    if (m_query != query) {
        m_query = query;
        emit queryChanged();
    }
    if (isConnected()) {
        sendSearchRequest();
    } else if (!m_manualDisconnect) {
        connectToDaemon();
    }
}

void FountClient::refresh() {
    if (isConnected()) {
        sendSearchRequest();
    } else if (!m_manualDisconnect) {
        connectToDaemon();
    }
}

void FountClient::launch(const QString& id, bool execute) {
    if (id.isEmpty()) {
        return;
    }
    if (!isConnected()) {
        emit daemonError(QStringLiteral("Cannot launch '%1': not connected to fount-daemon").arg(id));
        return;
    }
    sendFrame(encodeExecFrame(id, execute));
}

void FountClient::launchIndex(int index, bool execute) {
    const QString id = m_results->idAt(index);
    if (!id.isEmpty()) {
        launch(id, execute);
    }
}

void FountClient::reload() {
    if (!isConnected()) {
        return;
    }
    sendFrame(encodeReloadFrame());
}

void FountClient::ping() {
    if (!isConnected()) {
        return;
    }
    sendFrame(encodePingFrame());
}

void FountClient::connectToDaemon() {
    m_manualDisconnect = false;
    m_reconnectTimer.stop();

    if (m_socket.state() == QLocalSocket::ConnectedState ||
        m_socket.state() == QLocalSocket::ConnectingState) {
        return;
    }

    m_readBuffer.clear();
    m_socket.connectToServer(m_socketPath, QIODevice::ReadWrite);
}

void FountClient::disconnectFromDaemon() {
    m_manualDisconnect = true;
    m_reconnectTimer.stop();
    m_readBuffer.clear();
    if (m_socket.state() != QLocalSocket::UnconnectedState) {
        m_socket.disconnectFromServer();
    }
}

void FountClient::onSocketConnected() {
    m_reconnectTimer.stop();
    m_reconnectDelayMs = 250;
    m_spawnAttempted = false;
    m_readBuffer.clear();

    emit connectedChanged();

    if (m_autoSearchOnConnect) {
        sendSearchRequest();
    }
}

void FountClient::onSocketDisconnected() {
    m_readBuffer.clear();
    emit connectedChanged();

    if (m_autoReconnect && !m_manualDisconnect) {
        scheduleReconnect();
    }
}

void FountClient::onSocketError(QLocalSocket::LocalSocketError socketError) {
    if (m_autoStartDaemon && !m_spawnAttempted &&
        (socketError == QLocalSocket::ServerNotFoundError ||
         socketError == QLocalSocket::ConnectionRefusedError)) {
        trySpawnDaemon();
    }

    if (m_autoReconnect && !m_manualDisconnect && m_socket.state() == QLocalSocket::UnconnectedState) {
        scheduleReconnect();
    }
}

void FountClient::onReconnectTimer() {
    if (!m_manualDisconnect && m_socket.state() == QLocalSocket::UnconnectedState) {
        connectToDaemon();
    }
}

void FountClient::scheduleReconnect() {
    if (m_reconnectTimer.isActive()) {
        return;
    }
    m_reconnectTimer.start(m_reconnectDelayMs);
    m_reconnectDelayMs = std::min(m_reconnectDelayMs * 2, 3000);
}

void FountClient::trySpawnDaemon() {
    m_spawnAttempted = true;

    QString executable = m_daemonProgram;
    if (!QFileInfo(executable).isAbsolute()) {
        const QString found = QStandardPaths::findExecutable(executable);
        if (!found.isEmpty()) {
            executable = found;
        } else {
            // Local workspace fallback for fount_launcher development builds
            const QStringList devFallbacks = {
                QDir::homePath() + QStringLiteral("/.cargo/bin/fount-daemon"),
                QDir::homePath() + QStringLiteral("/Projects/Rust/fount_launcher/target/release/fount-daemon"),
                QDir::homePath() + QStringLiteral("/Projects/Rust/fount_launcher/target/debug/fount-daemon"),
            };
            for (const QString& candidate : devFallbacks) {
                if (QFileInfo::exists(candidate) && QFileInfo(candidate).isExecutable()) {
                    executable = candidate;
                    break;
                }
            }
        }
    }

    if (QProcess::startDetached(executable, {})) {
        m_reconnectDelayMs = 200;
    }
}

void FountClient::sendFrame(const QByteArray& frame) {
    if (!isConnected()) {
        return;
    }
    m_socket.write(frame);
    m_socket.flush();
}

void FountClient::sendSearchRequest() {
    sendFrame(encodeSearchFrame(m_query, static_cast<quint32>(m_limit)));
}

void FountClient::onSocketReadyRead() {
    m_readBuffer.append(m_socket.readAll());

    while (m_readBuffer.size() >= static_cast<qsizetype>(sizeof(quint32))) {
        const quint32 frameLen = qFromBigEndian<quint32>(
            reinterpret_cast<const uchar*>(m_readBuffer.constData())
        );

        if (static_cast<qsizetype>(frameLen) > kMaxFrameSize) {
            emit daemonError(QStringLiteral("Frame size %1 exceeds maximum allowed (%2)")
                                 .arg(frameLen)
                                 .arg(kMaxFrameSize));
            m_readBuffer.clear();
            m_socket.abort();
            return;
        }

        const qsizetype totalFrameBytes = static_cast<qsizetype>(sizeof(quint32)) + static_cast<qsizetype>(frameLen);
        if (m_readBuffer.size() < totalFrameBytes) {
            // Wait for remaining payload bytes
            break;
        }

        const QByteArrayView payloadView(
            m_readBuffer.constData() + sizeof(quint32),
            static_cast<qsizetype>(frameLen)
        );

        QString decodeErr;
        const std::optional<DaemonResponse> decoded = decodeDaemonMessage(payloadView, &decodeErr);
        m_readBuffer.remove(0, totalFrameBytes);

        if (!decoded.has_value()) {
            emit daemonError(QStringLiteral("Bincode decode error: %1").arg(decodeErr));
            continue;
        }

        handleDaemonMessage(*decoded);
    }
}

void FountClient::handleDaemonMessage(const DaemonResponse& msg) {
    std::visit([this](const auto& payload) {
        using T = std::decay_t<decltype(payload)>;
        if constexpr (std::is_same_v<T, ResultsPayload>) {
            // Only apply if it matches current query (or if current query trimmed matches)
            const int count = static_cast<int>(payload.items.size());
            m_results->setItems(payload.items);
            emit resultsReceived(payload.query, count);
        } else if constexpr (std::is_same_v<T, LaunchedPayload>) {
            emit launched(payload.id, payload.success, payload.error);
            if (!payload.success && !payload.error.isEmpty()) {
                emit daemonError(payload.error);
            }
        } else if constexpr (std::is_same_v<T, ReloadedPayload>) {
            emit reloaded(static_cast<int>(payload.count));
            sendSearchRequest();
        } else if constexpr (std::is_same_v<T, PongPayload>) {
            emit pongReceived();
        } else if constexpr (std::is_same_v<T, ErrorPayload>) {
            emit daemonError(payload.message);
        }
    }, msg);
}

} // namespace hematite::fount
