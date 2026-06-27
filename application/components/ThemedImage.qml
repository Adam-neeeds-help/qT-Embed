import QtQuick 2.15
import Qt5Compat.GraphicalEffects

import Theme 1.0

// An Image whose (purple) baked colors are hue-rotated to follow the theme accent.
Item {
    id: root

    property alias source: img.source
    property alias sourceSize: img.sourceSize
    property alias fillMode: img.fillMode

    implicitWidth: img.implicitWidth
    implicitHeight: img.implicitHeight
    width: implicitWidth
    height: implicitHeight

    Image {
        id: img
        anchors.fill: parent
        visible: false
    }

    HueSaturation {
        anchors.fill: img
        source: img
        hue: Theme.svgHueShift
        saturation: Theme.accentSat - 1 // gray accent -> grayscale image
        lightness: Theme.svgLightShift
    }
}
