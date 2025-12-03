import QtQuick
import qs.Modules

Repeater {
    id: gifRepeater
    required property list<string> gifsList
    property int firstWidth
    property int lastWidth
    model: gifsList
    Item {
        x: index === 0 ? 0 : gifRepeater.itemAt(index - 1).x + gifRepeater.itemAt(index - 1).width
        y: Screen.height - height
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
