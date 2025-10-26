import QtQuick

MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    drag.target: parent
    drag.axis: Drag.XAndYAxis
    drag.minimumX: 0
    drag.maximumX: Screen.width - parent.width
    drag.minimumY: 0
    drag.maximumY: Screen.height - parent.height
}
