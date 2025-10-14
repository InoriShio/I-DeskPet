pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Modules
import qs.Functions

PanelWindow {
    id: mainWindow
    WlrLayershell.layer: WlrLayer.Top
    color: "transparent"
    anchors {
        bottom: true
        left: true
    }
    surfaceFormat.opaque: false
    implicitWidth: 320 
    implicitHeight: 293
    margins {
        left: 0
        bottom: 5
    }

    IpcHandler {
        id: ipc
        target: mainWindow
        function getColor() { return mainWindow.color.toString() }
    }

    ToggleLayer {
        id: toggleHelper
    }

    PetMarch{
        id:petMarch
    }
}
