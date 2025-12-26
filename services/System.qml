pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property int refCount: 0

  // Battery
  readonly property QtObject battery: QtObject {
    property string status: ""
    property int percent: 0
    property bool charging: status === "Charging"
    property bool power: status !== "Discharging"
    property bool present: false
    property string name: ""

    readonly property string icon: {
      if (charging)
        return "󱐋";
      if (power)
        return "󰚥";
      if (percent < 20)
        return "󰂃";
      if (percent < 30)
        return "󰁻";
      if (percent < 50)
        return "󰁽";
      if (percent < 80)
        return "󰂀";
      return "󰁹";
    }
  }

  Process {
    id: findBattery
    running: true
    command: ["sh", "-c", "ls /sys/class/power_supply/ | grep -E 'BAT|BATT' | head -n 1"]
    stdout: StdioCollector {
      onStreamFinished: {
        let detected = text.trim();
        if (detected !== "") {
          root.battery.present = true;
          root.battery.name = detected;
          capacityFile.path = "/sys/class/power_supply/" + detected + "/capacity";
          statusFile.path = "/sys/class/power_supply/" + detected + "/status";
        }
      }
    }
  }

  Timer {
    running: root.refCount > 0 && root.battery.name !== ""
    interval: 5000
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      capacityFile.reload();
      statusFile.reload();
    }
  }

  FileView {
    id: capacityFile
    onLoaded: {
      let data = text();
      if (data && data.trim() !== "") {
        let val = parseInt(data.trim());
        if (!isNaN(val)) {
          root.battery.percent = val;
        }
      }
    }
  }

  FileView {
    id: statusFile
    onLoaded: {
      let data = text();
      if (data && data.trim() !== "") {
        root.battery.status = data.trim();
      }
    }
  }
}
