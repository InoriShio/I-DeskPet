import QtQuick

MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    drag.target: dragEvernight
    drag.axis: Drag.XAndYAxis
    drag.minimumX: 0
    drag.maximumX: Screen.width - evernight.width
    drag.minimumY: 0
    drag.maximumY: Screen.height - evernight.height
}
