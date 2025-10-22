import QtQuick
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    width: 320
    height: 293

    // anchors.bottom: parent.bottom

    AnimatedImage {
        source: "../Gifs/evernight.gif"
        fillMode: Image.PreserveAspectFit
    }

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
}
