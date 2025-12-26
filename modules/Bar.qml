import Quickshell
import QtQuick.Layouts
import QtQuick
import qs.components

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

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 0

        // Left
        RowLayout {
          id: leftSection
          Layout.alignment: Qt.AlignLeft

          Workspaces {}
        }

        Item {
          Layout.fillWidth: true
        }

        // Right
        RowLayout {
          id: rightSection
          Layout.alignment: Qt.AlignRight

          Battery {}
        }
      }

      // Center
      RowLayout {
        id: centerSection
        anchors.centerIn: parent
        Clock {
          color: "#a9b1d6"
          font.pixelSize: 14
        }
      }
    }
  }
}
