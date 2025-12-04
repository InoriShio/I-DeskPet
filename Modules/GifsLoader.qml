pragma ComponentBehavior: Bound

import QtQuick
import qs.Modules

Repeater {
    id: gifRepeater
    required property list<string> gifsList
    property int firstWidth
    property int lastWidth
    model: gifsList
    Item {
		id: gifItem

		required property int index
		required property string modelData

		function xPos(): void {
			let xPos = 0;
			const item = gifRepeater.itemAt(index - 1);
			if ( item ) xPos += item.x + item.width;
			return xPos;
		}

		Component.onCompleted: x = xPos()

		x: 0
        y: Screen.height - ( height + 10 )
        width: Math.floor( gif.sourceSize.width / 1.25 )
        height: Math.floor( gif.sourceSize.height / 1.25 )

        AnimatedImage {
            id: gif
            source: gifItem.modelData
            // fillMode: Image.PreserveAspectFit
            anchors.fill: parent
        }

        Mouse {}
    }
}
