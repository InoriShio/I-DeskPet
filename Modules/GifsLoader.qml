pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Modules

Repeater {
    id: gifRepeater
    required property list<string> gifsList

    model: gifsList
    Item {
		id: gifItem

		required property int index
		required property string modelData

		// function xPos(): int {
		// 	let xPos = 0;
		// 	const item = gifRepeater.itemAt(index - 1);
		// 	if ( item ) xPos += item.x + item.width;
		// 	return xPos;
		// }

		// Component.onCompleted: x = xPos()

		onXChanged: gifSaved.positionX = gifItem.x
		onYChanged: gifSaved.positionY = gifItem.y
        width: Math.floor( gif.sourceSize.width / gifSaved.scaling )
		height: Math.floor( gif.sourceSize.height / gifSaved.scaling )

        AnimatedImage {
            id: gif
            source: gifItem.modelData
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }

		Mouse {
			onWheel: (wheel)=> {
				gifSaved.scaling = Math.max( 1, ( gifSaved.scaling + 0.1 * ( wheel.angleDelta.y / 120 ) ) )
			}
			
			onClicked: gifSaved.scaling = 1
		}

		FileView {
			id: watcher
			path: configPath

			property list<string> gifNames: gifItem.modelData.split("/")
			property string name: gifNames[gifNames.length - 1].split(".")[0] + ".json"
			property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet/"
			property string configPath: configDir + name
			// property int yGif: ( screen.height - gifItem.height )

			onLoaded: {
				gifItem.x = gifSaved.positionX
				gifItem.y = gifSaved.positionY
			}

			watchChanges: true

			onFileChanged: reload()

			onAdapterUpdated: writeAdapter()

			JsonAdapter {
				id: gifSaved

				property real scaling: 1
				property int positionX: 0
				property int positionY: 0
			}
		}
    }
}
