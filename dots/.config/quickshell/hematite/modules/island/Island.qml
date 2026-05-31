pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.widgets
import "pages" as IslandPages

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: root
            required property var modelData

            property bool expanded: false
            property string activePageId: centerPage ? centerPage.pageId : ""

            readonly property var sortedPages: {
                const pages = pageRegistry.pages.slice();
                pages.sort((a, b) => a.priority - b.priority);
                return pages;
            }

            readonly property var collapsedPages: {
                const pages = [];

                for (const page of root.sortedPages) {
                    if (page.hasCollapsedContent && page.isActive) {
                        pages.push(page);
                    }
                }

                if (pages.length === 0) {
                    const clock = root.sortedPages.find(page => page.pageId === "clock");
                    if (clock) {
                        pages.push(clock);
                    }
                }

                return pages;
            }

            readonly property var centerPage: root.collapsedPages.length > 0 ? root.collapsedPages[0] : null
            readonly property var sidePages: root.collapsedPages.slice(1)

            readonly property int activeIndex: pageIndexForId(activePageId)

            function pageIndexForId(pageId) {
                const index = root.sortedPages.findIndex(page => page.pageId === pageId);
                return index >= 0 ? index : 0;
            }

            onCollapsedPagesChanged: {
                if (!root.centerPage) {
                    root.activePageId = "";
                    return;
                }

                const hasActive = root.sortedPages.some(page => page.pageId === root.activePageId);
                if (!hasActive || !root.expanded) {
                    root.activePageId = root.centerPage.pageId;
                }
            }

            onExpandedChanged: {
                if (!root.expanded && root.centerPage) {
                    root.activePageId = root.centerPage.pageId;
                }
            }

            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
                left: true
                right: true
            }
            screen: modelData
            exclusionMode: ExclusionMode.Ignore
            implicitHeight: 700
            color: "transparent"

            IslandPages.IslandPageRegistry {
                id: pageRegistry
            }

            mask: Region {
                item: island

                Region {
                    item: leftRound
                }

                Region {
                    item: rightRound
                }

                Region {
                    item: sidePillLayer
                }
            }

            Rectangle {
                id: island
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                property real popWidth: 0

                implicitWidth: root.expanded ? 680 + popWidth : (root.centerPage?.collapsedWidth || 0) + popWidth
                implicitHeight: root.expanded ? 280 + popWidth : 48 + popWidth
                color: Appearance.colors.background
                bottomLeftRadius: 45
                bottomRightRadius: 45

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: root.expanded = !root.expanded
                    onEntered: island.popWidth = 10
                    onExited: island.popWidth = 0
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 450
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.easings.expressiveFastSpatial
                    }
                }

                Loader {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    active: !root.expanded
                    sourceComponent: root.centerPage ? root.centerPage.collapsedComponent : null
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    visible: root.expanded

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: root.sortedPages

                            delegate: Rectangle {
                                id: tabButton
                                required property var modelData

                                radius: 99
                                implicitHeight: 28
                                implicitWidth: tabLabel.implicitWidth + 16
                                color: root.activePageId === tabButton.modelData.pageId ? Qt.alpha(Appearance.colors.on_surface, 0.14) : "transparent"

                                Text {
                                    id: tabLabel
                                    anchors.centerIn: parent
                                    text: tabButton.modelData.title
                                    color: Appearance.colors.on_surface
                                    font.family: Config.options.fontFamily
                                    font.pixelSize: 12
                                    font.bold: root.activePageId === tabButton.modelData.pageId
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.activePageId = tabButton.modelData.pageId
                                }
                            }
                        }
                    }

                    StackLayout {
                        id: expandedStack
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: root.activeIndex

                        Repeater {
                            model: root.sortedPages

                            delegate: Item {
                                id: expandedPage
                                required property var modelData

                                Loader {
                                    anchors.fill: parent
                                    sourceComponent: expandedPage.modelData.expandedComponent
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: sidePillLayer
                anchors.horizontalCenter: island.horizontalCenter
                anchors.verticalCenter: island.verticalCenter
                width: (!root.expanded && root.sidePages.length > 0)
                    ? island.implicitWidth + root.sidePages.reduce((total, page) => total + page.sidePillWidth + 10, 40)
                    : 0
                height: (!root.expanded && root.sidePages.length > 0) ? Math.max(50, island.implicitHeight) : 0

                Repeater {
                    model: root.sidePages

                    delegate: Rectangle {
                        id: sidePill

                        required property int index
                        required property var modelData

                        readonly property bool leftSide: index % 2 === 0
                        readonly property int lane: Math.floor(index / 2) + 1

                        property real emerge: 0
                        property real startDistance: Math.max(8, island.implicitWidth * 0.5 - width * 0.5 - 8)
                        property real endDistance: island.implicitWidth * 0.5 + lane * (width)
                        property real distance: startDistance + (endDistance - startDistance) * emerge

                        y: (parent.height - height) / 2
                        x: parent.width / 2 - width / 2 + (leftSide ? -distance : distance)

                        implicitWidth: sidePill.modelData.sidePillWidth
                        implicitHeight: 40
                        radius: 22
                        color: Appearance.colors.background
                        opacity: emerge
                        scale: 0.9 + 0.1 * emerge

                        states: [
                            State {
                                name: "shown"
                                when: !root.expanded
                                PropertyChanges {
                                    target: sidePill
                                    emerge: 1
                                }
                            },
                            State {
                                name: "hidden"
                                when: root.expanded
                                PropertyChanges {
                                    target: sidePill
                                    emerge: 0
                                }
                            }
                        ]

                        Behavior on emerge {
                            NumberAnimation {
                                duration: 220 + sidePill.index * 45
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
                            }
                        }

                        Loader {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            sourceComponent: sidePill.modelData.sidePillComponent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.activePageId = sidePill.modelData.pageId;
                                root.expanded = true;
                            }
                        }
                    }
                }
            }

            RoundCorner {
                id: leftRound
                anchors {
                    top: parent.top
                    right: island.left
                }
                corner: RoundCorner.CornerEnum.TopRight
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }

            RoundCorner {
                id: rightRound
                anchors {
                    top: parent.top
                    left: island.right
                }
                corner: RoundCorner.CornerEnum.TopLeft
                implicitSize: Math.min(island.implicitHeight * 0.5, 40)
                color: Appearance.colors.background
            }
        }
    }
}
