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

		required property string fileBaseName
		required property url fileUrl
		property alias hovered: mouse.containsMouse
		required property int index
		property bool loaded: false
		property alias zIndex: gifSaved.zIndex

		height: Math.floor(gif.sourceSize.height / gifSaved.scaling)
		visible: gifItem.loaded
		width: Math.floor(gif.sourceSize.width / gifSaved.scaling)
		z: gifSaved.zIndex

		onXChanged: if (gifItem.loaded)
			gifSaved.positionX = gifItem.x
		onYChanged: if (gifItem.loaded)
			gifSaved.positionY = gifItem.y

		AnimatedImage {
			id: gif

			anchors.fill: parent
			fillMode: Image.PreserveAspectFit
			source: gifItem.fileUrl
		}

		Mouse {
			id: mouse

			onDoubleClicked: gifSaved.scaling = 1
			onWheel: wheel => {
				gifSaved.scaling = Math.max(ConfigLoader.maxScaling, (gifSaved.scaling + 0.1 * (wheel.angleDelta.y / 120)));
			}
		}

		FileView {
			id: watcher

			property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet/"
			property string configPath: configDir + name
			property string name: gifItem.fileBaseName + ".json"

			path: configPath
			watchChanges: true

			onAdapterUpdated: writeAdapter()
			onFileChanged: reload()
			onLoadFailed: {
				gifSaved.zIndex = gifItem.index;
				writeAdapter();
				gifItem.loaded = true;
			}
			onLoaded: {
				if (gifSaved.zIndex === -1)
					gifSaved.zIndex = gifItem.index;
				gifItem.x = gifSaved.positionX;
				gifItem.y = gifSaved.positionY;
				gifItem.loaded = true;
			}

			JsonAdapter {
				id: gifSaved

				property int positionX: 0
				property int positionY: 0
				property real scaling: 1
				property int zIndex: -1
			}
		}
	}
}
