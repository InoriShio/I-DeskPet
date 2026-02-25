
	FileView {
		id: watcher
		path: configPath

		property string name: gifItem.fileBaseName + ".json"
		property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet/"
		property string configPath: configDir + name

		onLoaded: {
			if ( gifSaved.zIndex === -1 ) gifSaved.zIndex = gifItem.index
			gifItem.x = gifSaved.positionX
			gifItem.y = gifSaved.positionY
			gifItem.loaded = true
		}

		onLoadFailed: {
			gifSaved.zIndex = gifItem.index
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
			property int zIndex: -1
		}
	}
}
