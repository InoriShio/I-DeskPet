pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Modules

PanelWindow {
    id: mainWindow
	WlrLayershell.namespace: "I-DeskPet"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    surfaceFormat.opaque: false
	color: "transparent"

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
        bottom: 0
        right: 0
        top: 0
    }

    GetGifs {
        id: getGifs
        gifFolder: ConfigLoader.gifFolder
    }

    GifsLoader {
        id: gifLoader
        gifsModel: getGifs.gifsModel
		onItemAdded: function( index, item ) {
			mainWindow.repeaterItems = Array.from( { length: gifLoader.count }, (_, i) => gifLoader.itemAt(i) ).filter( v => v !== null )
		}
		onItemRemoved: function( index, item ) {
			mainWindow.repeaterItems = Array.from( { length: gifLoader.count }, (_, i) => gifLoader.itemAt(i) ).filter( v => v !== null )
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

    property var petMove: Region { id: pets
		width: Screen.width
		height: Screen.height
		intersection: Intersection.Xor
		regions: maskVariants.instances
    }

    property var noMove: Region {}

    property bool setMask: true
    
    GlobalShortcut {
        appid: "I-DeskPet"
        name: "toggle-Layer"
        onPressed: {
            if (!mainWindow.onTop) {
                mainWindow.WlrLayershell.layer = WlrLayer.Overlay
                mainWindow.onTop = true
            } else {
                mainWindow.WlrLayershell.layer = WlrLayer.Bottom
                mainWindow.onTop = false
            }
        }
    }

    GlobalShortcut {
        appid: "I-DeskPet"
        name: "toggle-Region"
        onPressed: {
            if ( !mainWindow.setMask ) {
                mainWindow.mask = mainWindow.petMove
                mainWindow.setMask = true
            } else {
                mainWindow.mask = mainWindow.noMove
                mainWindow.setMask = false
            }
        }
    }

    GlobalShortcut {
        appid: "I-DeskPet"
        name: "cycle-zIndex"
        onPressed: {
            let items = mainWindow.repeaterItems
            if ( items.length < 2 ) return

            // Find the hovered GIF
            let hovered = null
            for ( let i = 0; i < items.length; i++ ) {
                if ( items[i].hovered ) {
                    hovered = items[i]
                    break
                }
            }
            if ( !hovered ) return

            let currentZ = hovered.zIndex
            let maxZ = items.length - 1

            if ( currentZ >= maxZ ) {
                // Already on top, wrap to bottom: shift everyone else up by 1
                for ( let i = 0; i < items.length; i++ ) {
                    if ( items[i] !== hovered ) {
                        items[i].zIndex += 1
                    }
                }
                hovered.zIndex = 0
            } else {
                // Swap with the item directly above
                for ( let i = 0; i < items.length; i++ ) {
                    if ( items[i] !== hovered && items[i].zIndex === currentZ + 1 ) {
                        items[i].zIndex = currentZ
                        break
                    }
                }
                hovered.zIndex = currentZ + 1
            }
        }
    }
}
