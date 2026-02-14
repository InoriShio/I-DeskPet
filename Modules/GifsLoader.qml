pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import qs.Modules

Repeater {
    id: gifRepeater
    required property FolderListModel gifsModel

    model: gifsModel
    Item {
		id: gifItem

		required property url fileUrl
		required property string fileBaseName
		property bool loaded: false

		visible: gifItem.loaded
		onXChanged: if ( gifItem.loaded ) gifSaved.positionX = gifItem.x
		onYChanged: if ( gifItem.loaded ) gifSaved.positionY = gifItem.y
        width: Math.floor( gif.sourceSize.width / gifSaved.scaling )
		height: Math.floor( gif.sourceSize.height / gifSaved.scaling )

        AnimatedImage {
            id: gif
            source: gifItem.fileUrl
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }

		Mouse {
			onWheel: (wheel)=> {
				gifSaved.scaling = Math.max( 1, ( gifSaved.scaling + 0.1 * ( wheel.angleDelta.y / 120 ) ) )
			}
			
			onDoubleClicked: gifSaved.scaling = 1
		}

		FileView {
			id: watcher
			path: configPath

			property string name: gifItem.fileBaseName + ".json"
			property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet/"
			property string configPath: configDir + name

			onLoaded: {
				gifItem.x = gifSaved.positionX
				gifItem.y = gifSaved.positionY
				gifItem.loaded = true
			}

			onLoadFailed: {
				writeAdapter()
				gifItem.loaded = true
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
