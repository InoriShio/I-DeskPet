import Quickshell.Io

Process {
    id: getGifsProcess
    property list<string> gifsList: []
    command: ["sh", "-c", "$HOME/.config/quickshell/QtDesktopPet/Scripts/files.sh"]
    stdout: StdioCollector {
        onStreamFinished: {
            var gifs = this.text.trim().split("\n")
            getGifsProcess.gifsList = gifs
        }
    }
}
