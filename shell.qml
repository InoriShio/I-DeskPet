pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Modules

PanelWindow {
    id: mainWindow
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    surfaceFormat.opaque: false
    implicitWidth: Screen.width
    implicitHeight: Screen.height

    property bool onTop: true
    property bool setMask: true

    GetGifs {
        id: getGifs
        running: true
    }
    
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

    Rectangle {
        color: mainWindow.color
        anchors.centerIn: parent
        implicitWidth: Screen.width
        implicitHeight: Screen.height

        GifsLoader {
            id: gifloader
            gifsList: getGifs.gifsList
        }
    }
}
