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

    ConfigLoader {
        id: configLoader
        onFolderChanged: {
            console.log("Folder changed to:", gifFolder)
            getGifs.reload()
        }
    }

    GetGifs {
        id: getGifs
        gifFolder: configLoader.gifFolder
        running: configLoader.loaded
    }

    GifsLoader {
        id: gifloader
        gifsList: getGifs.gifsList
        onItemAdded: {
            mainWindow.petRegion( item )
        }
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

    function petRegion( itemObject ) {
        let newregion = regionComponent.createObject( pets, { "item": itemObject })
        pets.regions.push( newregion )
    }

    Component {
        id: regionComponent
        Region { }
    }

    mask: Region {}

    property var petMove: Region { id: pets }

    property var noMove: Region {}

    property bool setMask: false
    
    IpcHandler {
        target: "Mask"

        function edmask(): void {
            if ( !mainWindow.setMask ) {
                mainWindow.mask = petMove
                mainWindow.setMask = true
            } else {
                mainWindow.mask = noMove
                mainWindow.setMask = false
            }
        }
    }
}
