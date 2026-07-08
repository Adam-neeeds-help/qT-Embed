import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0
import QFlipper 1.0

Item {
    id: overlay
    visible: opacity > 0

    Behavior on opacity {
        PropertyAnimation {
            easing.type: Easing.InOutQuad
            duration: 150
        }
    }

    ThemedImage {
        id: usbPlug

        x: parent.width - 216
        y: 145

        source: "qrc:/assets/gfx/images/typec.svg"
        sourceSize: Qt.size(159, 37)
    }

    TextLabel {
        id: connectMsg
        anchors.horizontalCenter: parent.horizontalCenter
        y: 264

        color: Theme.color.lightorange2
        text: qsTr("Connect your T-Embed")

        font.family: "Born2bSportyV2"
        font.pixelSize: 48
    }

    // Optional manual COM-port override (defaults to "Auto (detect)").
    ColumnLayout {
        id: comPortPanel
        x: 16
        y: 14
        width: 150
        spacing: 2

        TextLabel {
            text: qsTr("COM port")
            color: Theme.color.lightorange2
            font.pixelSize: 18
        }

        ComboBox {
            id: comCombo
            Layout.fillWidth: true
            font.pixelSize: 18

            model: SerialPorts.ports
            currentIndex: SerialPorts.selectedIndex

            onActivated: SerialPorts.selectedIndex = index
            onPressedChanged: if(pressed) SerialPorts.refresh()
        }
    }

    ThemedImage {
        id: spinner

        anchors.rightMargin: 31
        anchors.bottomMargin: 21

        anchors.right: overlay.right
        anchors.bottom: overlay.bottom

        source: "qrc:/assets/gfx/images/spinner.svg"
        sourceSize: Qt.size(24, 24)

        opacity: Backend.isQueryInProgress

        PropertyAnimation {
            target: spinner
            duration: 1500
            loops: Animation.Infinite
            property: "rotation"
            running: Backend.isQueryInProgress
            from: 0
            to: 360
        }

        Behavior on opacity {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
                duration: 150
            }
        }
    }
}
