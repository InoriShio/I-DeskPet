import Quickshell.Io

Process {
    id: getGifsProcess
    required property string gifFolder
    property list<string> gifsList: []

    command: ["find", gifFolder, "-type", "f", "-name", "*.gif"]

    stdout: StdioCollector {
        onStreamFinished: {
            var gifs = this.text.trim().split("\n")
            if (gifs.length > 0 && gifs[0] !== "") {
                getGifsProcess.gifsList = gifs
            } else {
                getGifsProcess.gifsList = []
            }
        }
    }

    function reload() {
        // Clear current list and restart the process
        gifsList = []
        running = false
        running = true
    }

    onGifFolderChanged: {
        if (running) {
            reload()
        }
    }
}
