pragma Singleton

import QtQuick 2.15
import QFlipper 1.0

QtObject {
    id: root

    // User-selected accent color (persisted in Preferences). Drives the whole accent family.
    readonly property color accent: Preferences.accentColor

    // Hue (0..1) and saturation scale taken from the chosen accent.
    // Achromatic picks (grey/white) collapse to a clean monochrome theme.
    readonly property real accentHue: accent.hslHue >= 0 ? accent.hslHue : 0
    readonly property real accentSat: accent.hslSaturation
    readonly property real accentLight: accent.hslLightness

    // Brightness factor: 1.0 at the default accent lightness (0.65), scales the whole theme.
    readonly property real lightFactor: accentLight / 0.65

    // Hue rotation applied to baked purple SVG assets so they follow the accent too.
    // (HueSaturation.hue: -1..1 maps to -360..360 degrees.)
    readonly property color svgBase: "#a64dff"
    readonly property real svgHueShift: {
        var d = accentHue - svgBase.hslHue;
        if(d > 0.5) d -= 1.0;
        else if(d < -0.5) d += 1.0;
        return d;
    }
    // Lightness offset for baked SVGs (HueSaturation.lightness: -1..1), 0 at default brightness.
    readonly property real svgLightShift: Math.max(-1, Math.min(1, accentLight - 0.65))

    // Separate color for the navigation d-pad. White (sat 0) keeps it black/white.
    readonly property color dpad: Preferences.dpadColor
    readonly property real dpadHue: dpad.hslHue >= 0 ? dpad.hslHue : 0
    readonly property real dpadSat: dpad.hslSaturation

    // Build a themed shade: chosen hue, per-shade saturation & lightness scaled by the accent.
    function shade(s, l) {
        return Qt.hsla(root.accentHue,
                       Math.min(1, s * root.accentSat),
                       Math.max(0, Math.min(1, l * root.lightFactor)),
                       1);
    }

    readonly property var color: QtObject {
        readonly property color transparent: Qt.rgba(0, 0, 0, 0)

        // Accent family — derived live from Preferences.accentColor.
        readonly property color lightorange1:  root.shade(1.000, 0.700)
        readonly property color lightorange2:  root.shade(1.000, 0.651)
        readonly property color lightorange3:  root.shade(0.738, 0.465)
        readonly property color darkorange1:   root.shade(1.000, 0.145)
        readonly property color darkorange2:   root.shade(0.566, 0.145)
        readonly property color mediumorange1: root.shade(0.639, 0.378)
        readonly property color mediumorange2: root.shade(0.830, 0.253)
        readonly property color mediumorange3: root.shade(0.804, 0.222)
        readonly property color mediumorange4: root.shade(0.631, 0.373)
        readonly property color mediumorange5: root.shade(0.580, 0.392)

        // Status colors — intentionally fixed.
        readonly property color lightgreen: "#2ed832"
        readonly property color mediumgreen1: "#285b12"
        readonly property color mediumgreen2: "#203812"
        readonly property color darkgreen: "#0c160c"

        readonly property color lightblue: "#228cff"
        readonly property color mediumblue: "#143c66"
        readonly property color darkblue1: "#11355c"
        readonly property color darkblue2: "#152b47"

        readonly property color lightred1: "#ff5b27"
        readonly property color lightred2: "#ff5924"
        readonly property color lightred3: "#ff1f00"
        readonly property color lightred4: "#ff3c00"
        readonly property color mediumred1: "#953618"
        readonly property color mediumred2: "#672715"
        readonly property color darkred1: "#451a0e"
        readonly property color darkred2: "#331400"
    }

    readonly property var timing: QtObject {
        readonly property int toolTipDelay: 500
    }
}
