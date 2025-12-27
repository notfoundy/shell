import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: root

  implicitWidth: layout.implicitWidth
  implicitHeight: layout.implicitHeight

  RowLayout {
    id: layout

    anchors.fill: parent
    spacing: 0

    Cpu {}

    Rectangle {
      color: "#414868"
      opacity: 0.4
      Layout.preferredWidth: 1
      Layout.fillHeight: true
      Layout.topMargin: 8
      Layout.bottomMargin: 8
    }

    Ram {}
  }
}
