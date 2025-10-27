import QtQuick

Rectangle {
    width: imageAcheron.width
    height: imageAcheron.height

    AnimatedImage {
        id: imageAcheron
        source: "../Gifs/Acheron.gif"
        fillMode: Image.PreserveAspectFit
    }
}
