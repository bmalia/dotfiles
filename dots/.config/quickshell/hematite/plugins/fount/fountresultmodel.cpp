#include "fountresultmodel.hpp"

#include <qset.h>

namespace hematite::fount {

namespace {

QVariantList toVariantList(const QList<int>& list) {
    QVariantList out;
    out.reserve(list.size());
    for (int v : list) {
        out.append(v);
    }
    return out;
}

QString escapeHtmlChar(QChar c) {
    switch (c.unicode()) {
    case '&': return QStringLiteral("&amp;");
    case '<': return QStringLiteral("&lt;");
    case '>': return QStringLiteral("&gt;");
    case '"': return QStringLiteral("&quot;");
    default: return QString(c);
    }
}

} // namespace

FountResultModel::FountResultModel(QObject* parent)
    : QAbstractListModel(parent) {}

int FountResultModel::rowCount(const QModelIndex& parent) const {
    if (parent.isValid()) {
        return 0;
    }
    return static_cast<int>(m_items.size());
}

QVariant FountResultModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size()) {
        return {};
    }

    const SearchResultItem& item = m_items.at(index.row());
    switch (role) {
    case Qt::DisplayRole:
    case NameRole:
        return item.name;
    case EntryIdRole:
        return item.id;
    case DescriptionRole:
        return item.description;
    case IconRole:
        return item.icon;
    case ExecRole:
        return item.exec;
    case IsCustomActionRole:
        return item.isCustomAction;
    case ScoreRole:
        return item.score;
    case MatchedIndicesRole:
        return toVariantList(item.matchedIndices);
    default:
        return {};
    }
}

QHash<int, QByteArray> FountResultModel::roleNames() const {
    return {
        { EntryIdRole, "entryId" },
        { NameRole, "name" },
        { DescriptionRole, "description" },
        { IconRole, "icon" },
        { ExecRole, "exec" },
        { IsCustomActionRole, "isCustomAction" },
        { ScoreRole, "score" },
        { MatchedIndicesRole, "matchedIndices" },
    };
}

void FountResultModel::setItems(QList<SearchResultItem> items) {
    if (m_items == items) {
        return;
    }

    const int oldCount = static_cast<int>(m_items.size());
    const int newCount = static_cast<int>(items.size());

    beginResetModel();
    m_items = std::move(items);
    endResetModel();

    if (oldCount != newCount) {
        emit countChanged();
    }
}

void FountResultModel::clear() {
    if (m_items.isEmpty()) {
        return;
    }
    beginResetModel();
    m_items.clear();
    endResetModel();
    emit countChanged();
}

const QList<SearchResultItem>& FountResultModel::items() const {
    return m_items;
}

QVariantMap FountResultModel::get(int index) const {
    if (index < 0 || index >= m_items.size()) {
        return {};
    }
    const SearchResultItem& item = m_items.at(index);
    return {
        { QStringLiteral("entryId"), item.id },
        { QStringLiteral("name"), item.name },
        { QStringLiteral("description"), item.description },
        { QStringLiteral("icon"), item.icon },
        { QStringLiteral("exec"), item.exec },
        { QStringLiteral("isCustomAction"), item.isCustomAction },
        { QStringLiteral("score"), item.score },
        { QStringLiteral("matchedIndices"), toVariantList(item.matchedIndices) },
    };
}

QString FountResultModel::idAt(int index) const {
    if (index < 0 || index >= m_items.size()) {
        return {};
    }
    return m_items.at(index).id;
}

QString FountResultModel::highlightName(int index, const QString& openTag, const QString& closeTag) const {
    if (index < 0 || index >= m_items.size()) {
        return {};
    }
    const SearchResultItem& item = m_items.at(index);
    if (item.matchedIndices.isEmpty()) {
        return item.name.toHtmlEscaped();
    }

    QSet<int> matchedSet(item.matchedIndices.begin(), item.matchedIndices.end());
    QString result;
    result.reserve(item.name.size() + matchedSet.size() * (openTag.size() + closeTag.size()));

    bool inHighlight = false;
    int codePointIdx = 0;
    for (int i = 0; i < item.name.size(); ++i, ++codePointIdx) {
        const bool isMatch = matchedSet.contains(codePointIdx);
        if (isMatch && !inHighlight) {
            result.append(openTag);
            inHighlight = true;
        } else if (!isMatch && inHighlight) {
            result.append(closeTag);
            inHighlight = false;
        }

        const QChar ch = item.name.at(i);
        if (ch.isHighSurrogate() && i + 1 < item.name.size() && item.name.at(i + 1).isLowSurrogate()) {
            result.append(ch);
            result.append(item.name.at(++i));
        } else {
            result.append(escapeHtmlChar(ch));
        }
    }
    if (inHighlight) {
        result.append(closeTag);
    }
    return result;
}

} // namespace hematite::fount
