#pragma once

#include <qbytearray.h>
#include <qbytearrayview.h>
#include <qlist.h>
#include <qstring.h>
#include <qtypes.h>

#include <optional>
#include <variant>

namespace hematite::fount {

inline constexpr qsizetype kMaxFrameSize = 16 * 1024 * 1024; // 16 MiB

struct SearchResultItem {
    QString id;
    QString name;
    QString description;
    QString icon;
    QString exec;
    bool isCustomAction = false;
    quint32 score = 0;
    QList<int> matchedIndices;

    bool operator==(const SearchResultItem& other) const = default;
};

struct ResultsPayload {
    QString query;
    QList<SearchResultItem> items;
};

struct LaunchedPayload {
    QString id;
    bool success = false;
    QString error;
};

struct ReloadedPayload {
    quint32 count = 0;
};

struct PongPayload {};

struct ErrorPayload {
    QString message;
};

using DaemonResponse = std::variant<
    ResultsPayload,
    LaunchedPayload,
    ReloadedPayload,
    PongPayload,
    ErrorPayload
>;

// Prepends the 4-byte big-endian length header to a serialized payload.
[[nodiscard]] QByteArray framePayload(QByteArrayView payload);

// Encodes ClientMessage variants into bincode frames (including the 4-byte BE length header).
[[nodiscard]] QByteArray encodeSearchFrame(const QString& query, quint32 limit);
[[nodiscard]] QByteArray encodeExecFrame(const QString& id, bool execute);
[[nodiscard]] QByteArray encodeReloadFrame();
[[nodiscard]] QByteArray encodePingFrame();

// Decodes a single unframed bincode payload into a DaemonResponse.
[[nodiscard]] std::optional<DaemonResponse> decodeDaemonMessage(QByteArrayView payload, QString* errorOut = nullptr);

} // namespace hematite::fount
