import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

import QFlipper 1.0
import Theme 1.0

Item {
    id: control

    signal screenStreamRequested

    readonly property var deviceState: Backend.deviceState

    width: 360
    height: 156

    visible: opacity > 0

    // Custom device illustration is authored in orange; rotate from that base hue.
    readonly property color imgBase: "#ff8a2c"
    readonly property real imgHueShift: {
        var d = Theme.accentHue - imgBase.hslHue;
        if(d > 0.5) d -= 1.0;
        else if(d < -0.5) d += 1.0;
        return d;
    }

    Behavior on x {
        PropertyAnimation {
            easing.type: Easing.InOutQuad
            duration: 350
        }
    }

    Behavior on opacity {
        PropertyAnimation {
            easing.type: Easing.InOutQuad
            duration: 350
        }
    }

    Image {
        id: flipperImage
        anchors.fill: parent
        source: "qrc:/assets/gfx/images/flipper-custom.png"
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(1165, 462)
        visible: false
    }

    // Hue-rotate the illustration so it follows the theme accent.
    HueSaturation {
        anchors.fill: flipperImage
        source: flipperImage
        hue: control.imgHueShift
        saturation: Theme.accentSat - 1 // gray accent -> grayscale illustration
        lightness: Theme.svgLightShift
    }

    AbstractButton {
        id: clickArea
        width: control.width
        height: control.height
        visible: screenCanvas.visible
        onClicked: control.screenStreamRequested()
    }

    Rectangle {
        id: blueLed
        visible: !!deviceState && deviceState.isRecoveryMode

        x: 234
        y: 90

        width: 9
        height: width

        radius: Math.round(width / 2)
        color: Theme.color.lightblue
    }

    Image {
        id: defaultScreen
        visible: false // custom illustration already includes its own screen art

        x: 93
        y: 26

        source: deviceState && deviceState.isRecoveryMode ? "qrc:/assets/gfx/images/recovery.svg" :
                Backend.backendState === ApplicationBackend.Finished ? "qrc:/assets/gfx/images/success.svg" :
                                                                       "qrc:/assets/gfx/images/default.svg"
        sourceSize: Qt.size(128, 64)
    }

    ScreenCanvas {
        id: screenCanvas

        // Aligned to the custom illustration's screen. Rendered at 2x (crisp)
        // then scaled down to fill the screen area (avoids the 1x integer snap).
        x: 61
        y: 34
        width: 256
        height: 128
        // Non-uniform scale: fill the screen width and the screen height.
        transform: Scale { origin.x: 0; origin.y: 0; xScale: 164 / 256; yScale: 88 / 128 }

        visible: Backend.screenStreamer.isEnabled &&
                 Backend.backendState > ApplicationBackend.WaitingForDevices &&
                 Backend.backendState < ApplicationBackend.ScreenStreaming

        foregroundColor: Theme.color.darkorange1
        backgroundColor: Theme.color.lightorange2

        frame: Backend.screenStreamer.screenFrame
    }

    ExpandWidget {
        id: expandWidget

        x: 61
        y: 34

        width: 164
        height: 88

        visible: screenCanvas.visible
        opacity: clickArea.hovered ? clickArea.down ? 0.9 : 1 : 0
    }
}
