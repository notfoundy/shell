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

  // Cpu
  readonly property QtObject cpu: QtObject {
    property int usage: 0
    property real lastIdle: 0
    property real lastTotal: 0
    readonly property string icon: ""
  }

  // ram
  readonly property QtObject ram: QtObject {
    property real used: 0
    property real total: 0
    readonly property int usage: total > 0 ? Math.round((used / total) * 100) : 0
    readonly property string icon: ""
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

  Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
      onRead: data => {
        if (!data)
          return;
        let p = data.trim().split(/\s+/);
        let idle = parseInt(p[4]) + parseInt(p[5]);
        let total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);

        if (root.cpu.lastTotal > 0) {
          let totalDiff = total - root.cpu.lastTotal;
          let idleDiff = idle - root.cpu.lastIdle;
          root.cpu.usage = Math.round(100 * (1 - (idleDiff / totalDiff)));
        }
        root.cpu.lastTotal = total;
        root.cpu.lastIdle = idle;
      }
    }
  }

  Timer {
    running: root.refCount > 0
    interval: 2000
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuProc.running = true;
      memInfo.reload();
      if (root.battery.name !== "") {
        capacityFile.reload();
        statusFile.reload();
      }
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

  FileView {
    id: memInfo
    path: "/proc/meminfo"
    onLoaded: {
      let data = text();
      let totalMatch = data.match(/MemTotal:\s+(\d+)/);
      let availMatch = data.match(/MemAvailable:\s+(\d+)/);
      if (totalMatch && availMatch) {
        root.ram.total = parseInt(totalMatch[1]);
        root.ram.used = root.ram.total - parseInt(availMatch[1]);
      }
    }
  }
}
