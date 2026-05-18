import QtQuick
import QtQuick.Layouts
import qs.modules.common

Item {
    id: wrapper
    required property bool shouldShow
    required property Component sourceComponent
    property bool mounted: shouldShow
    property real animatedWidth: shouldShow ? contentLoader.implicitWidth : 0

    Layout.fillHeight: true
    Layout.minimumWidth: 0
    Layout.preferredWidth: animatedWidth

    visible: mounted || animatedWidth > 0.5
    clip: true
    opacity: shouldShow ? 1 : 0

    onShouldShowChanged: {
        if (shouldShow)
            mounted = true;
    }

    onAnimatedWidthChanged: {
        if (!shouldShow && animatedWidth <= 0.5)
            mounted = false;
    }

    Behavior on animatedWidth {
        NumberAnimation {
            duration: 500
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveDefaultSpatial
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveDefaultEffects
        }
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        active: wrapper.mounted
        sourceComponent: wrapper.sourceComponent
    }
}
