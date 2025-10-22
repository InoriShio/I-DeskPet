import QtQuick

MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    property bool dragging: false
    property real offsetX: 0
    property real offsetY: 0

    onPressed: {
        if (mouse.x >= original.x &&
        mouse.x <= original.x + original.width &&
        mouse.y >= original.y &&
        mouse.y <= original.y + original.height) {
            dragging = true
            offsetX = mouse.x - original.x
            offsetY = mouse.y - original.y
        }
    }

    onReleased: dragging = false

    onPositionChanged: {
        if (dragging) {
            original.x = Math.max(0, Math.min(mouse.x - offsetX, Screen.width - original.width))
            original.y = Math.max(0, Math.min(mouse.y - offsetY, Screen.height - original.height))
        }
    }
}
