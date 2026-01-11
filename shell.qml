import Quickshell
import QtQuick
import qs.panels

ShellRoot {
  component PanelFamilyLoader: LazyLoader {
    active: true
  }

  PanelFamilyLoader {
    component: IterPanelFamily {}
  }
}
