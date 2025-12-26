pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
  id: root

  // Track active widgets to start/stop data polling (0 = idle)
  Component.onCompleted: System.refCount++
  Component.onDestruction: System.refCount--

  visible: System.battery.present

  color: "#1a1b26"
  radius: 6

  implicitWidth: layout.implicitWidth + 16
  implicitHeight: 26

  RowLayout {
    id: layout
    anchors.centerIn: parent
    spacing: 6

    Text {
      text: {
        text: System.battery.icon;
      }
      font.pixelSize: 13
      color: {
        if (System.battery.charging)
          return "#e0af68"; // Orange
        if (System.battery.power)
          return "#7aa2f7"; // Bleu
        if (System.battery.percent < 20)
          return "#f7768e"; // Rouge
        return "#9ece6a"; // Vert
      }
    }

    Text {
      text: System.battery.percent + "%"
      font.pixelSize: 11
      font.bold: true
      color: "#a9b1d6"
    }
  }
}
