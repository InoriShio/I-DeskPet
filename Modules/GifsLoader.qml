pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.Modules

Repeater {
    id: gifRepeater
    required property list<string> gifsList

    model: gifsList
    Item {
		id: gifItem

		required property int index
		required property string modelData

		function xPos(): int {
			let xPos = 0;
			const item = gifRepeater.itemAt(index - 1);
			if ( item ) xPos += item.x + item.width;
			return xPos;
		}

		Component.onCompleted: x = xPos()

		x: 0
        y: Screen.height - height
        width: ( Math.floor( gif.sourceSize.width / ConfigLoader.scaling ) ? gif.sourceSize.width )
		height: ( Math.floor( gif.sourceSize.height / ConfigLoader.scaling ) ? gif.sourceSize.height )

        AnimatedImage {
            id: gif
            source: gifItem.modelData
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }

        Mouse {}
    }
}
