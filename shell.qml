pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
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

    GetGifs {
        id: getGifs
        running: true
    }

    GifsLoader {
        id: gifloader
        gifsList: getGifs.gifsList
        onItemAdded: {
            mainWindow.petRegion( item )
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

    mask: Region {
        id: pets
    }
}
