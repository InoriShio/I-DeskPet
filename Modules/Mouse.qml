import QtQuick

MouseArea {
	acceptedButtons: Qt.LeftButton
	anchors.fill: parent
	drag.axis: Drag.XAndYAxis
	drag.maximumX: Screen.width - parent.width
	drag.maximumY: Screen.height - parent.height
	drag.minimumX: 0
	drag.minimumY: 0
	drag.target: parent
	hoverEnabled: true
}
