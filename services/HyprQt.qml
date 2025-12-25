pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland

Singleton {
  id: root
  readonly property int focusedId: Hyprland.focusedWorkspace?.id ?? -1
  readonly property var workspaces: Hyprland.workspaces.values

  function isActive(id) {
    return focusedId == id;
  }

  function isOccupied(id) {
    return workspaces.some(w => w.id === id);
  }

  function goToWorkspace(id) {
    Hyprland.dispatch("workspace " + id);
  }
}
