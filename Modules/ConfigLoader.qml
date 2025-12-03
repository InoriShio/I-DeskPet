import QtCore
import QtQuick
import Quickshell.Io

QtObject {
    id: configLoader
    property string gifFolder: ""
    property bool loaded: false
    property string configDir: StandardPaths.homeLocation + "/.config/QTPet"
    property string configPath: configDir + "/config.json"

    signal folderChanged()

    // Process to check/create directory
    property var dirCheckProcess: Process {
        id: dirCheck
        running: false
        command: ["test", "-d", configLoader.configDir]

        onExited: {
            if (exitCode !== 0) {
                // Directory doesn't exist, create it
                dirCreateProcess.running = true
            } else {
                // Directory exists, check for config file
                fileCheckProcess.running = true
            }
        }
    }

    // Process to create directory
    property var dirCreateProcess: Process {
        id: dirCreate
        running: false
        command: ["mkdir", "-p", configLoader.configDir]

        onExited: {
            console.log("Created config directory:", configLoader.configDir)
            // After creating directory, create default config
            fileCreateProcess.running = true
        }
    }

    // Process to check if config file exists
    property var fileCheckProcess: Process {
        id: fileCheck
        running: false
        command: ["test", "-f", configLoader.configPath]

        onExited: {
            if (exitCode !== 0) {
                // File doesn't exist, create default config
                fileCreateProcess.running = true
            } else {
                // File exists, load it
                loadConfig()
            }
        }
    }

    // Process to create default config file
    property var fileCreateProcess: Process {
        id: fileCreate
        running: false
        command: ["sh", "-c", "echo '{\"gifFolder\": \"$HOME/.config/quickshell/QtDesktopPet/Gifs\"}' > " + configLoader.configPath]

        onExited: {
            console.log("Created default config file:", configLoader.configPath)
            loadConfig()
        }
    }

    // Timer to watch for config file changes
    property var configWatcher: Timer {
        id: watcher
        interval: 2000  // Check every 2 seconds
        running: configLoader.loaded
        repeat: true

        property string lastContent: ""

        onTriggered: {
            try {
                let currentContent = Qt.readFile(configLoader.configPath)
                if (lastContent !== "" && currentContent !== lastContent) {
                    console.log("Config file changed, reloading...")
                    loadConfig()
                    configLoader.folderChanged()
                }
                lastContent = currentContent
            } catch (e) {
                // File might have been deleted, ignore
            }
        }
    }

    function loadConfig() {
        try {
            let configText = Qt.readFile(configPath)
            let configData = JSON.parse(configText)

            // Replace $HOME with actual home directory
            let newFolder = configData.gifFolder.replace("$HOME", StandardPaths.homeLocation)

            if (gifFolder !== newFolder && loaded) {
                // Folder changed, emit signal
                gifFolder = newFolder
                folderChanged()
            } else {
                gifFolder = newFolder
            }

            loaded = true

            // Initialize watcher's lastContent on first load
            if (watcher.lastContent === "") {
                watcher.lastContent = configText
            }
        } catch (e) {
            console.error("Failed to load config:", e)
            // Fallback to default path
            gifFolder = StandardPaths.homeLocation + "/.config/quickshell/QtDesktopPet/Gifs"
            loaded = true
        }
    }

    Component.onCompleted: {
        // Start the check/create chain
        dirCheckProcess.running = true
    }
}
