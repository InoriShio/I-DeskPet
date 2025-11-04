import Quickshell.Io

Process {
    id: getGifsProcess
    property list<string> gifsList: []
    command: ["sh", "-c", "/home/inorishio/.config/quickshell/QtDesktopPet/Scripts/gifs.sh"]
    stdout: StdioCollector {
        onStreamFinished: {
            var gifs = this.text.trim().split("\n")
            getGifsProcess.gifsList = gifs
        }
    }

}
