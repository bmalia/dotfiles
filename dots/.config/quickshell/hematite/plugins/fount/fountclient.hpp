#pragma once

#include "fountresultmodel.hpp"

#include <qlocalsocket.h>
#include <qobject.h>
#include <qqmlengine.h>
#include <qqmlparserstatus.h>
#include <qtimer.h>

namespace hematite::fount {

class FountClient : public QObject, public QQmlParserStatus {
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    QML_ELEMENT

    Q_PROPERTY(QString socketPath READ socketPath WRITE setSocketPath NOTIFY socketPathChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(int limit READ limit WRITE setLimit NOTIFY limitChanged)
    Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)
    Q_PROPERTY(bool autoReconnect READ autoReconnect WRITE setAutoReconnect NOTIFY autoReconnectChanged)
    Q_PROPERTY(bool autoStartDaemon READ autoStartDaemon WRITE setAutoStartDaemon NOTIFY autoStartDaemonChanged)
    Q_PROPERTY(QString daemonProgram READ daemonProgram WRITE setDaemonProgram NOTIFY daemonProgramChanged)
    Q_PROPERTY(bool autoSearchOnConnect READ autoSearchOnConnect WRITE setAutoSearchOnConnect NOTIFY autoSearchOnConnectChanged)
    Q_PROPERTY(hematite::fount::FountResultModel* results READ results CONSTANT)

public:
    explicit FountClient(QObject* parent = nullptr);
    ~FountClient() override;

    void classBegin() override;
    void componentComplete() override;

    [[nodiscard]] QString socketPath() const;
    void setSocketPath(const QString& path);

    [[nodiscard]] QString query() const;
    void setQuery(const QString& query);

    [[nodiscard]] int limit() const;
    void setLimit(int limit);

    [[nodiscard]] bool isConnected() const;

    [[nodiscard]] bool autoReconnect() const;
    void setAutoReconnect(bool enabled);

    [[nodiscard]] bool autoStartDaemon() const;
    void setAutoStartDaemon(bool enabled);

    [[nodiscard]] QString daemonProgram() const;
    void setDaemonProgram(const QString& program);

    [[nodiscard]] bool autoSearchOnConnect() const;
    void setAutoSearchOnConnect(bool enabled);

    [[nodiscard]] FountResultModel* results() const;

    Q_INVOKABLE void search(const QString& query);
    Q_INVOKABLE void refresh();
    Q_INVOKABLE void launch(const QString& id, bool execute = true);
    Q_INVOKABLE void launchIndex(int index, bool execute = true);
    Q_INVOKABLE void reload();
    Q_INVOKABLE void ping();
    Q_INVOKABLE void connectToDaemon();
    Q_INVOKABLE void disconnectFromDaemon();

signals:
    void socketPathChanged();
    void queryChanged();
    void limitChanged();
    void connectedChanged();
    void autoReconnectChanged();
    void autoStartDaemonChanged();
    void daemonProgramChanged();
    void autoSearchOnConnectChanged();

    void resultsReceived(const QString& query, int count);
    void launched(const QString& id, bool success, const QString& error);
    void reloaded(int count);
    void pongReceived();
    void daemonError(const QString& message);

private slots:
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketReadyRead();
    void onSocketError(QLocalSocket::LocalSocketError socketError);
    void onReconnectTimer();

private:
    static QString resolveDefaultSocketPath();
    void sendFrame(const QByteArray& frame);
    void sendSearchRequest();
    void handleDaemonMessage(const DaemonResponse& msg);
    void scheduleReconnect();
    void trySpawnDaemon();

    QLocalSocket m_socket;
    QTimer m_reconnectTimer;
    FountResultModel* m_results = nullptr;

    QString m_socketPath;
    QString m_query;
    int m_limit = 20;
    bool m_autoReconnect = true;
    bool m_autoStartDaemon = true;
    QString m_daemonProgram = QStringLiteral("fount-daemon");
    bool m_autoSearchOnConnect = true;

    bool m_componentCompleted = false;
    bool m_manualDisconnect = false;
    bool m_spawnAttempted = false;
    int m_reconnectDelayMs = 250;
    QByteArray m_readBuffer;
};

} // namespace hematite::fount
