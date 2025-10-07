import QtQuick
import Quickshell
import Quickshell.Wayland
//import qs.Gifs

PanelWindow {
    id: mainWindow
    WlrLayershell.layer: WlrLayer.Bottom 
    color: "transparent"
    surfaceFormat.opaque: false
    implicitWidth: screen.width 
    implicitHeight: screen.height

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

    ListModel {
        id: petModels
        ListElement {
            width: 320;
            height: 293;
            x: 0;
            y: 1124;
            source: "./Gifs/evernight.gif"
        }
    }

    Repeater {
        model: petModels
        delegate: Item {
            width: model.width
            height: model.height
            x: model.x
            y: model.y

            AnimatedImage {
                anchors.fill: parent
                source: model.source
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                drag.target: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.MiddleButton) {
                        mainWindow.toggleLayer()
                    }
                }
            }
        }
    }
}
