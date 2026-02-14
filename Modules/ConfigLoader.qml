pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
	id: root

	property alias gifFolder: adapter.gifFolder
	property string configDir: Quickshell.env("HOME") + "/.config/I-DeskPet"
	property string configPath: configDir + "/config.json"

	signal folderChanged()

	Process {
		id: dirCheck
		running: true
		command: [ "test", "-d", root.configDir ]

		onExited: function( exitCode ) {
			if ( exitCode !== 0 ) {
				console.log( "creating dir" )
				dirCreate.running = true
			}
			if ( exitCode !== 1 ) {
				console.log( "creating config" )
				configCheck.running = true
			}
        }
    }

	Process {
		id: dirCreate
		running: false
		command: [ "mkdir", "-p", root.configDir ]

		onExited: function(): void {
			console.log( "Created config directory:", root.configDir )
		}
	}

	FileView {
		id: watcher
		path: root.configPath

		watchChanges: true

		onFileChanged: reload()

		onAdapterUpdated: writeAdapter()

		JsonAdapter {
			id: adapter

            property string gifFolder: Quickshell.shellDir + "/Gifs"
		}
	}
}
