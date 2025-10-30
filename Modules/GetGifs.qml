import Quickshell
import Quickshell.Io

Process {
    id: getGifsProcess
    property list<string> gifsList: []
    command: ["sh", "-c", "./Scripts/files.sh"]
    stdout: StdioCollector {
        onStreamFinished: {
            var gifs = this.text.trim().split("\n")
            getGifsProcess.gifsList = gifs
        }
    }
}
