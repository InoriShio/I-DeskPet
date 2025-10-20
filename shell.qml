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
        left: true
        bottom: true
    }
    margins {
        left: 0
        bottom: 9
    }

    surfaceFormat.opaque: false
    implicitWidth: 320 
    implicitHeight: 293

    property bool onTop: true

    IpcHandler {
        target: "command"

        // Keybind swap layer
        function toggleLayer(): void {
            if ( !mainWindow.onTop ) {
                mainWindow.WlrLayershell.layer = WlrLayer.Top
                mainWindow.onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                mainWindow.onTop = false
            }
        }

        // Keybind swap overlay
        function toggleOverlay(): void {
            if (!mainWindow.onTop) {
                mainWindow.WlrLayershell.layer = WlrLayer.Overlay
                mainWindow.onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                mainWindow.onTop = false
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
