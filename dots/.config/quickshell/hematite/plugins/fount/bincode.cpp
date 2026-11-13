#include "bincode.hpp"

#include <qendian.h>

#include <cstring>

namespace hematite::fount {

namespace {

class BincodeWriter {
public:
    void writeU8(quint8 value) {
        m_buffer.append(static_cast<char>(value));
    }

    void writeBool(bool value) {
        writeU8(value ? 1 : 0);
    }

    void writeU32(quint32 value) {
        const quint32 le = qToLittleEndian(value);
        m_buffer.append(reinterpret_cast<const char*>(&le), sizeof(le));
    }

    void writeU64(quint64 value) {
        const quint64 le = qToLittleEndian(value);
        m_buffer.append(reinterpret_cast<const char*>(&le), sizeof(le));
    }

    void writeString(const QString& str) {
        const QByteArray utf8 = str.toUtf8();
        writeU64(static_cast<quint64>(utf8.size()));
        m_buffer.append(utf8);
    }

    [[nodiscard]] const QByteArray& bytes() const {
        return m_buffer;
    }

private:
    QByteArray m_buffer;
};

class BincodeReader {
public:
    explicit BincodeReader(QByteArrayView view)
        : m_data(reinterpret_cast<const uchar*>(view.data()))
        , m_size(view.size()) {}

    [[nodiscard]] bool readU8(quint8& out) {
        if (m_offset + 1 > m_size) {
            return false;
        }
        out = m_data[m_offset];
        m_offset += 1;
        return true;
    }

    [[nodiscard]] bool readBool(bool& out) {
        quint8 raw = 0;
        if (!readU8(raw) || raw > 1) {
            return false;
        }
        out = (raw == 1);
        return true;
    }

    [[nodiscard]] bool readU32(quint32& out) {
        if (m_offset + static_cast<qsizetype>(sizeof(quint32)) > m_size) {
            return false;
        }
        out = qFromLittleEndian<quint32>(m_data + m_offset);
        m_offset += sizeof(quint32);
        return true;
    }

    [[nodiscard]] bool readU64(quint64& out) {
        if (m_offset + static_cast<qsizetype>(sizeof(quint64)) > m_size) {
            return false;
        }
        out = qFromLittleEndian<quint64>(m_data + m_offset);
        m_offset += sizeof(quint64);
        return true;
    }

    [[nodiscard]] bool readString(QString& out) {
        quint64 len = 0;
        if (!readU64(len)) {
            return false;
        }
        if (len > static_cast<quint64>(m_size - m_offset)) {
            return false;
        }
        out = QString::fromUtf8(reinterpret_cast<const char*>(m_data + m_offset), static_cast<qsizetype>(len));
        m_offset += static_cast<qsizetype>(len);
        return true;
    }

    [[nodiscard]] bool readOptionalString(QString& out) {
        quint8 tag = 0;
        if (!readU8(tag)) {
            return false;
        }
        if (tag == 0) {
            out.clear();
            return true;
        }
        if (tag == 1) {
            return readString(out);
        }
        return false;
    }

    [[nodiscard]] bool readSearchResultItem(SearchResultItem& item) {
        if (!readString(item.id)) return false;
        if (!readString(item.name)) return false;
        if (!readOptionalString(item.description)) return false;
        if (!readOptionalString(item.icon)) return false;
        if (!readString(item.exec)) return false;
        if (!readBool(item.isCustomAction)) return false;
        if (!readU32(item.score)) return false;

        quint64 indicesCount = 0;
        if (!readU64(indicesCount)) return false;
        if (indicesCount > static_cast<quint64>((m_size - m_offset) / sizeof(quint32))) {
            return false;
        }

        item.matchedIndices.clear();
        item.matchedIndices.reserve(static_cast<qsizetype>(indicesCount));
        for (quint64 i = 0; i < indicesCount; ++i) {
            quint32 idx = 0;
            if (!readU32(idx)) return false;
            item.matchedIndices.append(static_cast<int>(idx));
        }
        return true;
    }

private:
    const uchar* m_data = nullptr;
    qsizetype m_size = 0;
    qsizetype m_offset = 0;
};

} // namespace

QByteArray framePayload(QByteArrayView payload) {
    const quint32 beLen = qToBigEndian(static_cast<quint32>(payload.size()));
    QByteArray framed;
    framed.reserve(static_cast<qsizetype>(sizeof(beLen)) + payload.size());
    framed.append(reinterpret_cast<const char*>(&beLen), sizeof(beLen));
    framed.append(payload.data(), payload.size());
    return framed;
}

QByteArray encodeSearchFrame(const QString& query, quint32 limit) {
    BincodeWriter writer;
    writer.writeU32(0); // ClientMessage::Search
    writer.writeString(query);
    writer.writeU32(limit);
    return framePayload(writer.bytes());
}

QByteArray encodeExecFrame(const QString& id, bool execute) {
    BincodeWriter writer;
    writer.writeU32(1); // ClientMessage::Exec
    writer.writeString(id);
    writer.writeBool(execute);
    return framePayload(writer.bytes());
}

QByteArray encodeReloadFrame() {
    BincodeWriter writer;
    writer.writeU32(2); // ClientMessage::Reload
    return framePayload(writer.bytes());
}

QByteArray encodePingFrame() {
    BincodeWriter writer;
    writer.writeU32(3); // ClientMessage::Ping
    return framePayload(writer.bytes());
}

std::optional<DaemonResponse> decodeDaemonMessage(QByteArrayView payload, QString* errorOut) {
    BincodeReader reader(payload);
    quint32 variant = 0;
    if (!reader.readU32(variant)) {
        if (errorOut) *errorOut = QStringLiteral("Truncated DaemonMessage discriminant");
        return std::nullopt;
    }

    switch (variant) {
    case 0: { // DaemonMessage::Results { query, items }
        ResultsPayload res;
        if (!reader.readString(res.query)) {
            if (errorOut) *errorOut = QStringLiteral("Failed to decode Results.query");
            return std::nullopt;
        }
        quint64 itemCount = 0;
        if (!reader.readU64(itemCount) || itemCount > 100000) {
            if (errorOut) *errorOut = QStringLiteral("Invalid Results.items count");
            return std::nullopt;
        }
        res.items.reserve(static_cast<qsizetype>(itemCount));
        for (quint64 i = 0; i < itemCount; ++i) {
            SearchResultItem item;
            if (!reader.readSearchResultItem(item)) {
                if (errorOut) *errorOut = QStringLiteral("Failed to decode SearchResultWire item");
                return std::nullopt;
            }
            res.items.append(std::move(item));
        }
        return res;
    }
    case 1: { // DaemonMessage::Launched { id, success, error }
        LaunchedPayload launched;
        if (!reader.readString(launched.id) ||
            !reader.readBool(launched.success) ||
            !reader.readOptionalString(launched.error)) {
            if (errorOut) *errorOut = QStringLiteral("Failed to decode Launched message");
            return std::nullopt;
        }
        return launched;
    }
    case 2: { // DaemonMessage::Reloaded { count }
        ReloadedPayload reloaded;
        if (!reader.readU32(reloaded.count)) {
            if (errorOut) *errorOut = QStringLiteral("Failed to decode Reloaded message");
            return std::nullopt;
        }
        return reloaded;
    }
    case 3: // DaemonMessage::Pong
        return PongPayload{};
    case 4: { // DaemonMessage::Error { message }
        ErrorPayload err;
        if (!reader.readString(err.message)) {
            if (errorOut) *errorOut = QStringLiteral("Failed to decode Error message");
            return std::nullopt;
        }
        return err;
    }
    default:
        if (errorOut) {
            *errorOut = QStringLiteral("Unknown DaemonMessage variant: %1").arg(variant);
        }
        return std::nullopt;
    }
}

} // namespace hematite::fount
