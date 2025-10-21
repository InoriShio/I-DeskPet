pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules
import qs.Functions

PanelWindow {
    id: mainWindow
    color: "transparent"
    property bool onTop: true
    WlrLayershell.layer: WlrLayer.Top
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

    ToggleLayer {
        id: toggleHelper
    }

    PetMarch {
        id: petMarch
    }
}
