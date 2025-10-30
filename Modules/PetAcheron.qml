import QtQuick

Rectangle {
    width: AnimatedImage.width
    height: AnimatedImage.height

    AnimatedImage {
        fillMode: Image.PreserveAspectFit
    }
}
