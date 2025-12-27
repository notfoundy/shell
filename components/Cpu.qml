import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.services

Rectangle {
  id: root

  // Track active widgets to start/stop data polling (0 = idle)
  Component.onCompleted: System.refCount++
  Component.onDestruction: System.refCount--

  color: "#1a1b26"
  radius: 6
  implicitWidth: layout.implicitWidth + 16
  implicitHeight: 30

  RowLayout {
    id: layout
    anchors.centerIn: parent
    spacing: 8

    Item {
      width: 20
      height: 20

      Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.samples: 4

        // Circle background
        ShapePath {
          fillColor: "transparent"
          strokeColor: "#414868"
          strokeWidth: 2
          PathAngleArc {
            centerX: 10
            centerY: 10
            radiusX: 8
            radiusY: 8
            startAngle: -90
            sweepAngle: 360
          }
        }

        // Circle usage ring
        ShapePath {
          fillColor: "transparent"
          strokeColor: System.cpu.usage > 80 ? "#f7768e" : "#7aa2f7"
          strokeWidth: 2
          capStyle: ShapePath.RoundCap
          PathAngleArc {
            centerX: 10
            centerY: 10
            radiusX: 8
            radiusY: 8
            startAngle: -90
            sweepAngle: (System.cpu.usage / 100) * 360
          }
        }
      }

      Text {
        anchors.centerIn: parent
        text: System.cpu.icon
        font.pixelSize: 10
        color: "#c0caf5"
      }
    }

    Text {
      text: System.cpu.usage + "%"
      color: "#a9b1d6"
      font.pixelSize: 11
      font.bold: true
    }
  }
}
