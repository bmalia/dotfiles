import QtQuick
import qs.modules.common

Item {
    id: root
    property real progress: 0.0 // 0.0 - 1.0
    property color color: Appearance.colors.primary
    property color trackColor: Appearance.colors.secondary_container
    property real thickness: 5
    property int diameter: 40
    property real waveAmplitude: 0
    property int waveCount: 10 // Number of waves around the circle
    property real wavePhase: 0 // phase offset for animation
    property real scrollSpeed: 0.08 // scroll speed property
    property real progressGap: 0.6 // Gap between progress and remainder arcs, in radians

    width: diameter
    height: diameter

    property Component centerItem

    // Animate the wave phase
    Timer {
        interval: 16 // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            root.wavePhase += root.scrollSpeed;
            if (root.wavePhase > Math.PI * 2)
                root.wavePhase -= Math.PI * 2;
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var centerX = width / 2;
            var centerY = height / 2;
            var baseRadius = (width / 2) - root.waveAmplitude - (root.thickness / 2);

            var startAngle = -Math.PI / 2;
            var progressAngle = 2 * Math.PI * root.progress;
            var gap = root.progress > 0 && root.progress < 1 ? root.progressGap : 0;

            // Draw the remainder arc (trackColor)
            if (root.progress < 1) {
                ctx.beginPath();
                ctx.arc(centerX, centerY, baseRadius, startAngle + progressAngle + gap / 2, startAngle + 2 * Math.PI - gap / 2, false);
                ctx.lineWidth = root.thickness;
                ctx.strokeStyle = root.trackColor;
                ctx.lineCap = "round";
                ctx.stroke();
            }

            // Draw the progress arc (color)
            if (root.progress > 0) {
                const arcStart = startAngle + gap / 2;
                const arcEnd = startAngle + progressAngle - gap / 2;

                ctx.beginPath();

                if (root.waveAmplitude <= 0.001) {
                    // Perfectly smooth when no wave is visible
                    ctx.arc(centerX, centerY, baseRadius, arcStart, arcEnd, false);
                } else {
                    // Increase sampling by rendered arc length for smoother wave
                    const arcLen = Math.abs(arcEnd - arcStart) * Math.max(1, baseRadius);
                    const steps = Math.max(96, Math.ceil(arcLen * 2.5));

                    for (let i = 0; i <= steps; ++i) {
                        const t = i / steps;
                        const angle = arcStart + t * (arcEnd - arcStart);
                        const wave = Math.sin(root.waveCount * angle + root.wavePhase) * root.waveAmplitude;
                        const r = baseRadius + wave;
                        const x = centerX + r * Math.cos(angle);
                        const y = centerY + r * Math.sin(angle);
                        if (i === 0)
                            ctx.moveTo(x, y);
                        else
                            ctx.lineTo(x, y);
                    }
                }

                ctx.lineWidth = root.thickness;
                ctx.strokeStyle = root.color;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.miterLimit = 2;
                ctx.stroke();
            }
        }
        Connections {
            target: root
            function onProgressChanged() {
                canvas.requestPaint();
            }
            function onColorChanged() {
                canvas.requestPaint();
            }
            function onTrackColorChanged() {
                canvas.requestPaint();
            }
            function onThicknessChanged() {
                canvas.requestPaint();
            }
            function onDiameterChanged() {
                canvas.requestPaint();
            }
            function onWaveAmplitudeChanged() {
                canvas.requestPaint();
            }
            function onWaveCountChanged() {
                canvas.requestPaint();
            }
            function onWavePhaseChanged() {
                canvas.requestPaint();
            }
            function onScrollSpeedChanged() {
                canvas.requestPaint();
            }
        }
        Component.onCompleted: requestPaint()
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: root.centerItem
    }

    Behavior on waveAmplitude {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on progress {
        NumberAnimation {
            duration: 350
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.easings.expressiveFastSpatial
        }
    }
}
