import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// Qt6
import QtQuick.Dialogs
import QtMultimedia


Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("MediaPlayer")

    ColumnLayout {
        anchors.fill: parent

        // Menu to open video location
        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            nameFilters: [ "Video files (*.mp4 *.avi *.mkv *.wma *.mpeg *..mpg)", "All files (*)" ]
            onAccepted: {
                mediaPlayer.stop()
                if (typeof fileDialog.currentFile !== "undefined") {
                    mediaPlayer.source = fileDialog.currentFile
                } else {
                    mediaPlayer.source = fileDialog.fileUrls[0]
                }

                mediaPlayer.play()
            }
        }

        MenuBar {
            id: menuBar
            Layout.fillWidth: true

            Menu {
                title: qsTr("&File")
                Action {
                    text: qsTr("&Open")
                    onTriggered: fileDialog.open()
                }
            }
        }

        // Video frame
        Frame {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "Black"
            }


            // Player
            // Used MediaPlayer + VideoOutput + AudioOutput because qml component `Video` that combines all of them, presented bugs in Qt6
            MediaPlayer {
                id: mediaPlayer
                videoOutput: videoOutput
                audioOutput: AudioOutput {
                 volume: 1
                 muted: false
                }
            }

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
            }
        }

        // Slider control to select video position
        RowLayout {
            id: sliderControl
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.margins: 20

            Button {
                text: "PAUSE"
                visible: mediaPlayer.playbackState === MediaPlayer.PlayingState
                onClicked: mediaPlayer.pause()
            }

            Button {
                text: "PLAY"
                visible: mediaPlayer.playbackState !== MediaPlayer.PlayingState
                onClicked: mediaPlayer.play()
            }

            // Text to show current video position in mm:ss.
            Text {
                id: mediaTime
                horizontalAlignment: Text.AlignRight
                text: {
                    var m = Math.floor(mediaPlayer.position / 60000)
                    var ms = (mediaPlayer.position / 1000 - m * 60).toFixed(1)
                    return `${m}:${ms.padStart(4, 0)}`
                }
            }

            // Slide that controls position and is updated as video is playing
            Slider {
                id: mediaSlider
                Layout.fillWidth: true
                enabled: mediaPlayer.seekable
                to: 1.0
                value: mediaPlayer.position / mediaPlayer.duration
                onMoved: mediaPlayer.position = value * mediaPlayer.duration
            }
        }
    }
}
