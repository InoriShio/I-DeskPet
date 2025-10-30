import QtQuick
import QtQuick.Controls
import qs.Modules

Repeater {
    id: gifRepeater
    required property list<string> gifsList
    model: gifsList
    Item {
        width: gif.width
        height: gif.height
        AnimatedImage {
            id: gif
            source: modelData
            fillMode: Image.PreserveAspectFit
        }

        Mouse {}
    }
}

