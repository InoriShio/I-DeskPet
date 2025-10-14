import QtQuick

Rectangle {
    anchors.fill: parent
    color: "transparent"

    AnimatedImage {
        anchors.fill: parent
        source: "../Gifs/evernight.gif"
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.MiddleButton) {
                toggleHelper.toggleLayer()
            }
        }
    }
}
