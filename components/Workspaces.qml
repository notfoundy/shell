pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services

RowLayout {
  spacing: 5
  Repeater {
    model: 9

    delegate: Rectangle {
      required property int index
      property var isOccupied: HyprQt.isOccupied(index + 1)
      property bool isActive: HyprQt.isActive(index + 1)

      implicitWidth: 24
      implicitHeight: 24
      radius: 4
      color: "transparent"

      Text {
        anchors.centerIn: parent
        text: index + 1
        font.bold: true
        font.pixelSize: 14
        color: isActive ? "#0db9d7" : (isOccupied ? "#7aa2f7" : "#444b6a")
      }

      MouseArea {
        anchors.fill: parent
        onClicked: HyprQt.goToWorkspace(index + 1)
      }
    }
  }
}
