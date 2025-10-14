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
        bottom: 9
    }

    property bool onTop: true

    IpcHandler {
        target: "command"

        // Keybind swap layer
        function toggleLayer(): void {
            if (!onTop) {
                mainWindow.WlrLayershell.layer = WlrLayer.Top
                onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                onTop = false
            }
        }

        // Keybind swap overlay
        function toggleOverlay(): void {
            if (!onTop) {
                mainWindow.WlrLayershell.layer = WlrLayer.Overlay
                onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                onTop = false
            }
        }
    }

    ToggleLayer {
        id: toggleHelper
    }

    PetMarch{
        id:petMarch
    }
}
