#pragma once

#include "bincode.hpp"

#include <qabstractitemmodel.h>
#include <qqmlengine.h>
#include <qvariant.h>

namespace hematite::fount {

class FountResultModel : public QAbstractListModel {
    Q_OBJECT
    QML_ANONYMOUS
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        EntryIdRole = Qt::UserRole + 1,
        NameRole,
        DescriptionRole,
        IconRole,
        ExecRole,
        IsCustomActionRole,
        ScoreRole,
        MatchedIndicesRole,
    };
    Q_ENUM(Roles)

    explicit FountResultModel(QObject* parent = nullptr);
    ~FountResultModel() override = default;

    [[nodiscard]] int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    [[nodiscard]] QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    [[nodiscard]] QHash<int, QByteArray> roleNames() const override;

    void setItems(QList<SearchResultItem> items);
    void clear();

    [[nodiscard]] const QList<SearchResultItem>& items() const;

    Q_INVOKABLE [[nodiscard]] QVariantMap get(int index) const;
    Q_INVOKABLE [[nodiscard]] QString idAt(int index) const;
    Q_INVOKABLE [[nodiscard]] QString highlightName(
        int index,
        const QString& openTag = QStringLiteral("<b>"),
        const QString& closeTag = QStringLiteral("</b>")
    ) const;

signals:
    void countChanged();

private:
    QList<SearchResultItem> m_items;
};

} // namespace hematite::fount
