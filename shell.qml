pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Modules

PanelWindow {
    id: mainWindow
    color: "transparent"
    property bool onTop: true
    property bool setMask: true
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: 0
    anchors {
        left: true
        right: true
        bottom: true
    }

    margins {
        left: 9
        right: 9
        bottom: 9
    }

    mask: Region {
        Region {
            item: dragEvernight
        }

        Region {
            item: dragAcheron
        }
    }

    property var yesMask: Region {
        Region {
            item: dragEvernight
        }

        Region {
            item: dragAcheron
        }
    }

    property var noMask: Region {
    }

    IpcHandler {
        target: "Mask"

        function edmask(): void {
            if ( !mainWindow.setMask ) {
                mainWindow.mask = yesMask
                mainWindow.setMask = true
            } else {
                mainWindow.mask = noMask
                mainWindow.setMask = false
            }
        }
    }

    surfaceFormat.opaque: false
    implicitWidth: Screen.width
    implicitHeight: Screen.height

    Item {
        id: dragEvernight
        x: 0
        y: Screen.height - evernight.height
        width: evernight.width
        height: evernight.height
        PetMarch {
            id: evernight
            color: mainWindow.color
        }

        Mouse {
        }
    }

    Item {
        id: dragAcheron
        x: Screen.width - acheron.width
        y: Screen.height - acheron.height
        width: acheron.width
        height: acheron.height
        PetAcheron {
            id: acheron
            color: mainWindow.color
        }

        Mouse {
        }
    }
}
