import QtQuick
import Quickshell.Wayland

QtObject {
    property bool onTop: true

    // The main toggle function
    function toggleLayer() {
        if (!onTop) {
            mainWindow.WlrLayershell.layer = WlrLayer.Top
            onTop = true
        } else {
            mainWindow.WlrLayershell.layer = WlrLayer.Bottom
            onTop = false
        }
        console.log("Toggled layer, onTop =")
    }
}
