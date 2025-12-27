import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.components
import qs.services

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 32 + HyprQt.rounding
      margins.bottom: -HyprQt.rounding
      color: "transparent"

      Rectangle {
        id: barBg
        width: parent.width
        height: 32
        color: "#1a1b26"
        anchors.top: parent.top
      }

      // Left outward rounded corner
      Shape {
        anchors.top: barBg.bottom
        anchors.left: parent.left
        width: HyprQt.rounding
        height: HyprQt.rounding
        layer.enabled: true
        layer.samples: 4

        ShapePath {
          fillColor: "#1a1b26"
          strokeWidth: 0
          startX: 0
          startY: 0
          // Draw to the right (under the bar)
          PathLine {
            x: HyprQt.rounding
            y: 0
          }
          // Create the inverted arc returning to the left edge
          // This arc creates the outward rounded corner
          PathArc {
            x: 0
            y: HyprQt.rounding
            radiusX: HyprQt.rounding
            radiusY: HyprQt.rounding
            direction: PathArc.Counterclockwise
          }
          // Go back up along the screen edge to close the path
          PathLine {
            x: 0
            y: 0
          }
        }
      }

      // Right outward rounded corner
      Shape {
        anchors.top: barBg.bottom
        anchors.right: parent.right
        width: HyprQt.rounding
        height: HyprQt.rounding
        layer.enabled: true
        layer.samples: 4

        ShapePath {
          fillColor: "#1a1b26"
          strokeWidth: 0
          // On commence au point de jonction avec la barre (à gauche du coin)
          startX: HyprQt.rounding
          startY: 0
          // On trace vers la gauche (sous la barre)
          PathLine {
            x: 0
            y: 0
          }
          // On crée l'arc inversé qui revient vers le bord droit
          PathArc {
            x: HyprQt.rounding
            y: HyprQt.rounding
            radiusX: HyprQt.rounding
            radiusY: HyprQt.rounding
            direction: PathArc.Clockwise
          }
          // On remonte le long du bord droit
          PathLine {
            x: HyprQt.rounding
            y: 0
          }
        }
      }

      // Content
      Item {
        anchors.top: parent.top
        width: parent.width
        height: 32

        RowLayout {
          anchors.fill: parent
          anchors.leftMargin: 12
          anchors.rightMargin: 12

          RowLayout {
            id: leftSection
            Layout.alignment: Qt.AlignLeft
            Workspaces {}
            SystemGroup {}
          }

          Item {
            Layout.fillWidth: true
          }

          RowLayout {
            id: rightSection
            Layout.alignment: Qt.AlignRight
            Battery {}
          }
        }

        Clock {
          id: centerSection
          anchors.centerIn: parent
          color: "#a9b1d6"
          font.pixelSize: 14
        }
      }
    }
  }
}
