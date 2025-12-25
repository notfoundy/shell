pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import "../components"

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

      implicitHeight: 30
      color: "#1a1b26"

      Clock {
        anchors.centerIn: parent
        color: "#a9b1d6"
        font.pixelSize: 14
      }
    }
  }
}
