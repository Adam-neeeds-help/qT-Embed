import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0
import QFlipper 1.0
import Primitives 1.0

// Standalone, freely-movable theme window. Drag the title bar to move it anywhere
// on the desktop (including outside the qFlipper window).
Window {
    id: control

    flags: Qt.FramelessWindowHint | Qt.Dialog
    color: "transparent"

    width: 520
    height: box.implicitHeight

    function open() {
        control.x = Screen.virtualX + Math.round((Screen.width - control.width) / 2);
        control.y = Screen.virtualY + Math.round((Screen.height - control.height) / 2);
        control.show();
        control.raise();
        control.requestActivate();
    }

    readonly property string defaultAccent: "#a64dff"

    readonly property color cur: Preferences.accentColor
    readonly property real curH: cur.hslHue >= 0 ? cur.hslHue : 0
    readonly property real curS: cur.hslSaturation
    readonly property real curL: cur.hslLightness

    readonly property color curDpad: Preferences.dpadColor
    readonly property real curDpadH: curDpad.hslHue >= 0 ? curDpad.hslHue : 0

    function toHex(c) {
        function h(x) { return ("0" + Math.round(x * 255).toString(16)).slice(-2); }
        return "#" + h(c.r) + h(c.g) + h(c.b);
    }

    function apply(hh, ss, ll) {
        Preferences.accentColor = control.toHex(Qt.hsla(hh, ss, ll, 1));
    }

    readonly property var presets: [
        "#ff8a2c", "#ff5a00", "#ffd11a", "#3bd13b", "#00e0a0",
        "#1ad1d1", "#228cff", "#a64dff", "#ff4fa3", "#e0e0e0"
    ]

    Shortcut { sequence: "Escape"; onActivated: control.close() }

    Rectangle {
        id: box
        anchors.fill: parent

        color: "black"
        radius: 7
        border.width: 2
        border.color: Theme.color.lightorange2

        implicitHeight: header.height + body.implicitHeight + 36

        // --- Draggable header (system move) ---
        Rectangle {
            id: header
            height: 42
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: box.border.width
            color: Theme.color.lightorange2

            TextLabel {
                anchors.centerIn: parent
                text: qsTr("THEME COLOR")
                color: Theme.color.darkorange1
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: 36
                cursorShape: Qt.SizeAllCursor
                onPressed: control.startSystemMove()
            }

            Button {
                flat: true
                padding: 0
                width: 24
                height: 24
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8

                backgroundColor: ColorSet {
                    normal: Theme.color.darkorange1
                    hover: Theme.color.mediumorange2
                    down: Theme.color.lightred2
                }

                icon.source: "qrc:/assets/gfx/controls/windows/close.svg"
                icon.width: 20
                icon.height: 20
                onClicked: control.close()
            }
        }

        ColumnLayout {
            id: body
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: 16
            spacing: 10

            TextLabel {
                text: qsTr("Presets")
                color: Theme.color.lightorange2
            }

            Grid {
                Layout.alignment: Qt.AlignHCenter
                columns: 5
                spacing: 10

                Repeater {
                    model: control.presets

                    Rectangle {
                        width: 66
                        height: 30
                        radius: 6
                        color: modelData

                        readonly property bool selected:
                            Preferences.accentColor.toLowerCase() === modelData.toLowerCase()

                        border.width: selected ? 3 : 1
                        border.color: selected ? "white" : Qt.rgba(1, 1, 1, 0.25)

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Preferences.accentColor = modelData
                        }
                    }
                }
            }

            // --- Hue ---
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4
                spacing: 10
                TextLabel { text: qsTr("Hue"); color: Theme.color.lightorange2; Layout.preferredWidth: 140 }
                Rectangle {
                    id: hueBar
                    Layout.fillWidth: true
                    height: 22
                    radius: 5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.000; color: Qt.hsva(0.000, 1, 1, 1) }
                        GradientStop { position: 0.167; color: Qt.hsva(0.167, 1, 1, 1) }
                        GradientStop { position: 0.333; color: Qt.hsva(0.333, 1, 1, 1) }
                        GradientStop { position: 0.500; color: Qt.hsva(0.500, 1, 1, 1) }
                        GradientStop { position: 0.667; color: Qt.hsva(0.667, 1, 1, 1) }
                        GradientStop { position: 0.833; color: Qt.hsva(0.833, 1, 1, 1) }
                        GradientStop { position: 1.000; color: Qt.hsva(1.000, 1, 1, 1) }
                    }
                    Rectangle {
                        width: 8; height: parent.height + 8; radius: 3; y: -4
                        x: Math.round(control.curH * (hueBar.width - width))
                        color: "white"; border.width: 2; border.color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        function pick(mx) { control.apply(Math.max(0, Math.min(1, mx / width)), control.curS, control.curL); }
                        onPressed: function(mouse) { pick(mouse.x); }
                        onPositionChanged: function(mouse) { if(pressed) pick(mouse.x); }
                    }
                }
            }

            // --- Saturation ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                TextLabel { text: qsTr("Saturation"); color: Theme.color.lightorange2; Layout.preferredWidth: 140 }
                Rectangle {
                    id: satBar
                    Layout.fillWidth: true
                    height: 22
                    radius: 5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0; color: Qt.hsla(control.curH, 0, 0.5, 1) }
                        GradientStop { position: 1; color: Qt.hsla(control.curH, 1, 0.5, 1) }
                    }
                    Rectangle {
                        width: 8; height: parent.height + 8; radius: 3; y: -4
                        x: Math.round(control.curS * (satBar.width - width))
                        color: "white"; border.width: 2; border.color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        function pick(mx) { control.apply(control.curH, Math.max(0, Math.min(1, mx / width)), control.curL); }
                        onPressed: function(mouse) { pick(mouse.x); }
                        onPositionChanged: function(mouse) { if(pressed) pick(mouse.x); }
                    }
                }
            }

            // --- Brightness ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                TextLabel { text: qsTr("Brightness"); color: Theme.color.lightorange2; Layout.preferredWidth: 140 }
                Rectangle {
                    id: brightBar
                    Layout.fillWidth: true
                    height: 22
                    radius: 5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0;   color: Qt.hsla(control.curH, control.curS, 0, 1) }
                        GradientStop { position: 0.5; color: Qt.hsla(control.curH, control.curS, 0.5, 1) }
                        GradientStop { position: 1;   color: Qt.hsla(control.curH, control.curS, 1, 1) }
                    }
                    Rectangle {
                        width: 8; height: parent.height + 8; radius: 3; y: -4
                        x: Math.round(control.curL * (brightBar.width - width))
                        color: "white"; border.width: 2; border.color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        function pick(mx) { control.apply(control.curH, control.curS, Math.max(0.04, Math.min(1, mx / width))); }
                        onPressed: function(mouse) { pick(mouse.x); }
                        onPositionChanged: function(mouse) { if(pressed) pick(mouse.x); }
                    }
                }
            }

            // --- D-pad ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                TextLabel { text: qsTr("D-pad"); color: Theme.color.lightorange2; Layout.preferredWidth: 140 }
                Rectangle {
                    id: dpadBar
                    Layout.fillWidth: true
                    height: 22
                    radius: 5
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.000; color: Qt.hsva(0.000, 1, 1, 1) }
                        GradientStop { position: 0.167; color: Qt.hsva(0.167, 1, 1, 1) }
                        GradientStop { position: 0.333; color: Qt.hsva(0.333, 1, 1, 1) }
                        GradientStop { position: 0.500; color: Qt.hsva(0.500, 1, 1, 1) }
                        GradientStop { position: 0.667; color: Qt.hsva(0.667, 1, 1, 1) }
                        GradientStop { position: 0.833; color: Qt.hsva(0.833, 1, 1, 1) }
                        GradientStop { position: 1.000; color: Qt.hsva(1.000, 1, 1, 1) }
                    }
                    Rectangle {
                        width: 8; height: parent.height + 8; radius: 3; y: -4
                        x: Math.round(control.curDpadH * (dpadBar.width - width))
                        color: "white"; border.width: 2; border.color: "black"
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        function pick(mx) { Preferences.dpadColor = control.toHex(Qt.hsla(Math.max(0, Math.min(1, mx / width)), 1, 0.6, 1)); }
                        onPressed: function(mouse) { pick(mouse.x); }
                        onPositionChanged: function(mouse) { if(pressed) pick(mouse.x); }
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 8
                Layout.bottomMargin: 4
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                spacing: 20

                SmallButton {
                    radius: 7
                    text: qsTr("Reset")
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: {
                        Preferences.accentColor = control.defaultAccent;
                        Preferences.dpadColor = "#ffffff";
                    }
                }

                SmallButton {
                    radius: 7
                    text: qsTr("Done")
                    highlighted: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: control.close()
                }
            }
        }
    }
}
