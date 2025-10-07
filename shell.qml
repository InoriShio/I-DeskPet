pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
//import qs.Gifs

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

    property bool onTop: true

    function toggleLayer() {
        if (onTop) {
            WlrLayershell.layer = WlrLayer.Bottom
            onTop = false
        } else {
            WlrLayershell.layer = WlrLayer.Top
            onTop = true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        id: petContainer
        AnimatedImage {
            anchors.fill: parent
            source: "Gifs/evernight.gif"
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.MiddleButton
            onClicked: (mouse) => {
                if (mouse.button === Qt.MiddleButton) {
                    mainWindow.toggleLayer()
                }
            }
        }
    }
}
