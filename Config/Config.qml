
	FileView {
		id: watcher
		path: root.configPath

		watchChanges: true

		onFileChanged: reload()

		onAdapterUpdated: writeAdapter()

		JsonAdapter {
			id: adapter

            property string gifFolder: Quickshell.shellDir + "/Gifs"
			property real maxScaling: 1
		}
	}
