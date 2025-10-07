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

    ListModel {
        id: petModels
        ListElement {
            width: 320;
            height: 293;
            x: 200;
            y: 200;
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
            }
        }
    }
}
