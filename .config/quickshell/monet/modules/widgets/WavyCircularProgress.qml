import QtQuick
import qs.modules.common

Item {
    id: root
    property real progress: 0.0 // 0.0 - 1.0
    property color color: Colors.primary
    property color trackColor: Colors.secondary_container
    property real thickness: 5
    property int diameter: 40
    property real waveAmplitude: 4
    property int waveCount: 10 // Number of waves around the circle
    property real wavePhase: 0 // phase offset for animation
    property real scrollSpeed: 0.08 // scroll speed property
    property real progressGap: 0.4 // Gap between progress and remainder arcs, in radians

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
            var baseRadius = (width / 2) - root.waveAmplitude - (thickness / 2);

            var startAngle = -Math.PI / 2;
            var progressAngle = 2 * Math.PI * root.progress;
            var gap = root.progress > 0 && root.progress < 1 ? root.progressGap : 0;

            // Draw the remainder arc (trackColor)
            if (root.progress < 1) {
                ctx.beginPath();
                ctx.arc(centerX, centerY, baseRadius, startAngle + progressAngle + gap / 2, startAngle + 2 * Math.PI - gap / 2, false);
                ctx.lineWidth = thickness;
                ctx.strokeStyle = trackColor;
                ctx.lineCap = "round";
                ctx.stroke();
            }

            // Draw the progress arc (color)
            if (root.progress > 0) {
                var arcStart = startAngle + gap / 2;
                var arcEnd = startAngle + progressAngle - gap / 2;
                var steps = Math.max(32, Math.floor(128 * root.progress));
                ctx.beginPath();
                for (var i = 0; i <= steps; ++i) {
                    var t = i / steps;
                    var angle = arcStart + t * (arcEnd - arcStart);
                    var wave = Math.sin(root.waveCount * angle + root.wavePhase) * root.waveAmplitude;
                    var r = baseRadius + wave;
                    var x = centerX + r * Math.cos(angle);
                    var y = centerY + r * Math.sin(angle);
                    if (i === 0)
                        ctx.moveTo(x, y);
                    else
                        ctx.lineTo(x, y);
                }
                ctx.lineWidth = thickness;
                ctx.strokeStyle = color;
                ctx.lineCap = "round";
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
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }
}
