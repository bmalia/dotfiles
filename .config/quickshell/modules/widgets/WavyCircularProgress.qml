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
    property int waveCount: 6 // Number of waves around the circle
    property real wavePhase: 0 // phase offset for animation
    property real scrollSpeed: 0.08 // <--- NEW: scroll speed property
    width: diameter
    height: diameter

    property Component centerItem

    // Animate the wave phase
    Timer {
        interval: 16 // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            root.wavePhase += root.scrollSpeed; // <--- Use scrollSpeed here
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

            var inset = thickness / 2;
            var centerX = width / 2;
            var centerY = height / 2;
            var maxInset = Math.max(root.waveAmplitude, thickness / 2);
            var baseRadius = (width / 2) - root.waveAmplitude - (thickness / 2);

            // Draw track (plain circle)
            ctx.beginPath();
            ctx.arc(centerX, centerY, baseRadius, 0, 2 * Math.PI, false);
            ctx.lineWidth = thickness;
            ctx.strokeStyle = trackColor;
            ctx.lineCap = "round";
            ctx.stroke();

            // Draw wavy progress arc
            if (root.progress > 0) {
                var startAngle = -Math.PI / 2;
                var endAngle = startAngle + 2 * Math.PI * root.progress;
                var steps = Math.max(32, Math.floor(128 * root.progress));
                ctx.beginPath();
                for (var i = 0; i <= steps; ++i) {
                    var t = i / steps;
                    var angle = startAngle + t * (endAngle - startAngle);
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
            onProgressChanged: canvas.requestPaint()
            onColorChanged: canvas.requestPaint()
            onTrackColorChanged: canvas.requestPaint()
            onThicknessChanged: canvas.requestPaint()
            onDiameterChanged: canvas.requestPaint()
            onWaveAmplitudeChanged: canvas.requestPaint()
            onWaveCountChanged: canvas.requestPaint()
            onWavePhaseChanged: canvas.requestPaint()
            onScrollSpeedChanged: canvas.requestPaint() // <--- Optional: repaint if speed changes
        }
        Component.onCompleted: requestPaint()
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: root.centerItem
    }

    Behavior on waveAmplitude {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
}