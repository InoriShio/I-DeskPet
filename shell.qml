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

    property bool onTop: true
	property list<Item> repeaterItems: []

    anchors {
        left: true
        bottom: true
		right: true
		top: true
    }

    margins {
        left: 0
        right: 0
        top: 0
        bottom: 9
    }

    GetGifs {
        id: getGifs
        gifFolder: ConfigLoader.gifFolder
        running: ConfigLoader.ready
    }

    GifsLoader {
        id: gifLoader
        gifsList: getGifs.gifsList
		onItemAdded: function( index, item ) {
			mainWindow.repeaterItems.push( item )
		}
    }

	Variants {
		id: maskVariants

		model: [ ...mainWindow.repeaterItems ]

		Region {
			required property Item modelData

			Component.onCompleted: {
				console.log(modelData)
			}

			x: modelData.x
			y: modelData.y
			width: modelData.width
			height: modelData.height
			intersection: Intersection.Subtract
		}
	}

    IpcHandler {
        target: "command"

        function toggleLayer(): void {
            if ( !mainWindow.onTop ) {
                mainWindow.WlrLayershell.layer = WlrLayer.Top
                mainWindow.onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                mainWindow.onTop = false
            }
        }

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

	mask: Region {
		width: Screen.width
		height: Screen.height
		intersection: Intersection.Xor
		regions: maskVariants.instances
	}

    property var petMove: Region { id: pets }

    property var noMove: Region {}

    property bool setMask: false
    
    IpcHandler {
        target: "Mask"

        function edmask(): void {
            if ( !mainWindow.setMask ) {
                mainWindow.mask = mainWindow.petMove
                mainWindow.setMask = true
            } else {
                mainWindow.mask = mainWindow.noMove
                mainWindow.setMask = false
            }
        }
    }
}
