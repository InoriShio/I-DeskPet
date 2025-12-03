pragma Singleton

import QtCore
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
	id: root

	property alias gifFolder: adapter.gifFolder
	property alias ready: root.loaded

	property bool loaded: false
	property string configDir: Quickshell.env("HOME") + "/.config/QtDesktopPet"
	property string configPath: configDir + "/config.json"

	signal folderChanged()

	Process {
		id: dirCheck
		running: true
		command: ["test", "-d", root.configDir]

		onExited: function( exitCode ) {
			if (exitCode !== 0) {
				dirCreate.running = true
			} else {
				fileCheck.running = true
			}
		}
	}

	Process {
		id: dirCreate
		running: false
		command: ["mkdir", "-p", root.configDir]

		onExited: function(): void {
			console.log("Created config directory:", root.configDir)
			fileCreate.running = true
		}
	}

	Process {
		id: fileCheck
		running: false
		command: ["test", "-f", root.configPath]

		onExited: function( exitCode ): void {
			if (exitCode !== 0) {
				fileCreate.running = true
			}
		}
	}

	Process {
		id: fileCreate

		property string homeDir: Quickshell.env("HOME")

		running: false
		command: ["sh", "-c", `echo '{\"gifFolder\": \"${homeDir}/.config/quickshell/QtDesktopPet/Gifs\"}' > ` + root.configPath]
	}

	FileView {
		id: watcher
		path: root.configPath

		watchChanges: true

		onFileChanged: reload()

		onLoaded: root.loaded = true

		JsonAdapter {
			id: adapter

			property string gifFolder: ""
		}
	}
}
