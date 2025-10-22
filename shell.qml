pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules
// import qs.Functions

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
        right: 0
        top: 0
        bottom: 9
    }

    mask: Region {
        intersection: intersection.Intersect
    }

    surfaceFormat.opaque: false
    implicitWidth: Screen.width
    implicitHeight: Screen.height

    PetMarch {
        id: petMarch2
        color: mainWindow.color
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    // Mve this pet
    PetMarch {
        id: original
        color: mainWindow.color
        x: 0
        y: 1147
        // anchors.leftMargin: parent.leftMargin
        // anchors.bottomMargin: parent.bottomMargin
    }

    Mouse {
    }
}
