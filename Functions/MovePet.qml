import QtQuick

MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    drag.target: null  // Not using built-in drag behavior

    onPositionChanged: {
        if (mouse.buttons & Qt.LeftButton) {
            petMarch.mleft = mouse.x
            petMarch.mbottom = mouse.y
            console.log("mleft:", petMarch.mleft, "mbottom:", petMarch.mbottom)
        }
    }
}
