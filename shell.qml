import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: mainWindow
    WlrLayershell.layer: WlrLayer.Bottom 
    color: "transparent"
    surfaceFormat.opaque: false
    implicitWidth: screen.width 
    implicitHeight: screen.height

    ListModel {
        id: petModels
        ListElement {
            x: 200;
            y: 200;
            width: 100;
            height: 100;
            clip: false;
            source: "/home/inorishio/Pictures/Gifs/everknight-evernight.gif"
        }
        ListElement {
            x: 200;
            y: 250;
            width: 100;
            height: 100;
            clip: false;
            source: "/home/inorishio/Pictures/Gifs/Yukinon-Cat.gif"
        }
        ListElement {
            x: 200;
            y: 300;
            width: 100;
            height: 100;
            clip: false;
            source: "/home/inorishio/Pictures/Gifs/Yukinon-Cat.gif"
        }
    }

    Repeater {
        model: petModels
        delegate: Item {
            width: model.width
            height: model.height
            x: model.x
            y: model.y
            clip: model.clip

            AnimatedImage {
                anchors.fill: parent
                source: model.source
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                anchors.fill: parent
                drag.target: parent
            }
        }
    }
}
