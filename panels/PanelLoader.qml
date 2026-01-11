import QtQuick
import Quickshell

LazyLoader {
  property bool isActive: true
  property bool extraCondition: true
  active: isActive && extraCondition
}
