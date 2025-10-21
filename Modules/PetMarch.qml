import QtQuick
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    AnimatedImage {
        source: "../Gifs/evernight.gif"
        fillMode: Image.PreserveAspectFit
    }

    // margins {
    //     mainWindow.left: 50
    // }

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
