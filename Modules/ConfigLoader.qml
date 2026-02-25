pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
	id: root

	property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet"
	property string configPath: configDir + "/config.json"
	property alias gifFolder: adapter.gifFolder
	property alias maxScaling: adapter.maxScale

	Process {
		id: dirCheck

		command: ["test", "-d", root.configDir]
		running: true

		onExited: function (exitCode) {
			if (exitCode !== 0) {
				console.log("creating dir");
				dirCreate.running = true;
			}
		}
	}

	Process {
		id: dirCreate

		command: ["mkdir", "-p", root.configDir]
		running: false

		onExited: function (): void {
			console.log("Created config directory:", root.configDir);
		}
	}

	FileView {
		id: watcher

		path: root.configPath
		watchChanges: true

		onAdapterUpdated: writeAdapter()
		onFileChanged: reload()

		JsonAdapter {
			id: adapter

			property string gifFolder: Quickshell.shellDir + "/Gifs"
			property real maxScale: 1
		}
	}
}
