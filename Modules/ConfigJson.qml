pragma Singleton

import QtCore
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
	id: root

	property alias gifFolder: adapter.gifFolder
	property alias scaling: adapter.scaling
	property alias maxWidth: adapter.maxWidth
	property alias maxHeight: adapter.maxHeight
	property string configDir: Quickshell.env("HOME") + "/.local/state/I-DeskPet"
	property string configPath: configDir + "/name.json"

	signal folderChanged()

	Process {
		id: dirCheck
		running: true
		command: ["test", "-d", root.configDir]

		onExited: function( exitCode ) {
			if (exitCode !== 0) {
				dirCreate.running = true
			}
        }
    }


	// name
	Component.onCompleted: {
		var s = gifItem.modelData.split("/")
		console.log(s[s.length - 1].split(".")[0].add(".json"))
	}

	Process {
		id: dirCreate
		running: false
		command: ["mkdir", "-p", root.configDir]

		onExited: function(): void {
			console.log("Created config directory:", root.configDir)
		}
	}

	FileView {
		id: watcher
		path: root.configPath

		watchChanges: true

		onFileChanged: reload()

		JsonAdapter {
			id: adapter

            property string gifFolder: Quickshell.shellDir + "/Gifs"
			property var scaling: 1
			property int maxWidth: 1000
			property int maxHeight: 1000
		}
	}
}
