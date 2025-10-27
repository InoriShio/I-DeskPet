import QtQuick
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    width: imageEvernight.width
    height: imageEvernight.height

    AnimatedImage {
        id: imageEvernight
        source: "../Gifs/Evernight.gif"
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
