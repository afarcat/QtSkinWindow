/* Copyright (C) 2020 afarcat <kabak@sina.com>. All rights reserved.
   Use of this source code is governed by a Apache license that can be
   found in the LICENSE file.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: window

    flags: basicFlags | Qt.WindowMinimizeButtonHint | Qt.WindowMaximizeButtonHint | Qt.WindowCloseButtonHint
    color: "#33000000"

    property int basicFlags: Qt.Window | Qt.FramelessWindowHint
    property bool fixedSize: (window.minimumWidth === window.maximumWidth && window.minimumHeight === window.maximumHeight)
    property string iconUrl: ""
    property int border: 5
    property alias windowContent: windowContent
    property bool enableCtrlWClose: true

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton //current use Qt.LeftButton
        enabled: window.visibility === Window.Windowed
        hoverEnabled: true
        preventStealing: true
        propagateComposedEvents: true
        z: -65535

        onPressed: {
            //if window is fixedSize, ignore it
            if (fixedSize) {
                return;
            }

            var rc = Qt.rect(0, 0, 0, 0);
            let e = 0;

            //top-left
            rc = Qt.rect(0, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge | Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }

            //top
            rc = Qt.rect(border, 0, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge;
                window.startSystemResize(e);
                return;
            }

            //top-right
            rc = Qt.rect(window.width-border, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.TopEdge | Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //right
            rc = Qt.rect(window.width-border, border, border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom-right
            rc = Qt.rect(window.width-border, window.height-border, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge | Qt.RightEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom
            rc = Qt.rect(border, window.height-border, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge;
                window.startSystemResize(e);
                return;
            }

            //bottom_left
            rc = Qt.rect(0, window.height-border,border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.BottomEdge | Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }

            //left
            rc = Qt.rect(0, border,border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                e = Qt.LeftEdge;
                window.startSystemResize(e);
                return;
            }
        }

        onPositionChanged: {
            //console.log("MouseArea.onPositionChanged=", mouse.x, mouse.y);

            //if window is fixedSize, ignore it
            if (fixedSize) {
                cursorShape = Qt.ArrowCursor;
                return;
            }

            var rc = Qt.rect(0, 0, 0, 0);

            //top-left
            rc = Qt.rect(0, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeFDiagCursor;
                return;
            }

            //top
            rc = Qt.rect(border, 0, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeVerCursor;
                return;
            }

            //top-right
            rc = Qt.rect(window.width-border, 0, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeBDiagCursor;
                return;
            }

            //right
            rc = Qt.rect(window.width-border, border, border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeHorCursor;
                return;
            }

            //bottom-right
            rc = Qt.rect(window.width-border, window.height-border, border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeFDiagCursor;
                return;
            }

            //bottom
            rc = Qt.rect(border, window.height-border, window.width-border*2, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeVerCursor;
                return;
            }

            //bottom_left
            rc = Qt.rect(0, window.height-border,border, border);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeBDiagCursor;
                return;
            }

            //left
            rc = Qt.rect(0, border,border, window.height-border*2);
            if (ptInRect(rc, mouse.x, mouse.y)) {
                cursorShape = Qt.SizeHorCursor;
                return;
            }

            //default
            cursorShape = Qt.ArrowCursor;
        }

        onExited: {
            cursorShape = Qt.ArrowCursor;
        }
    }

    Menu {
        id: systemMenu
        MenuItem {
            enabled: (window.flags & Qt.WindowMaximizeButtonHint) && (window.visibility === Window.Maximized)
            text: "🗗  " + qsTr("Restore(&R)")
            onTriggered: window.toggleMaximized()
        }

        //do this in c++
        /*MenuItem {
            enabled: window.visibility !== Window.Maximized
            text: "    " + qsTr("Move(&M)")
            onTriggered: {
                //1. move cursor pos to title center
                //2. change cursor shape to Qt.SizeAllCursor
            }
        }*/

        MenuItem {
            enabled: window.flags & Qt.WindowMinimizeButtonHint
            text: "🗕  " + qsTr("Minimize(&N)")
            onTriggered: window.showMinimized()
        }

        MenuItem {
            enabled: !fixedSize && (window.flags & Qt.WindowMaximizeButtonHint) && (window.visibility !== Window.Maximized)
            text: "🗖  " + qsTr("Maximize(&X)")
            onTriggered: window.toggleMaximized()
        }

        MenuSeparator{}

        MenuItem {
            enabled: window.flags & Qt.WindowCloseButtonHint
            text: "🗙  " + qsTr("Close(&C)  Alt+F4")
            action: Action {
                enabled: (window.flags & Qt.WindowCloseButtonHint) && enableCtrlWClose
                shortcut: "Ctrl+W"
                onTriggered: window.close()
            }
        }
    }

    Page {
        id: windowContent
        anchors.fill: parent
        anchors.margins: window.visibility === Window.Windowed ? border : 0
        clip: true

        header: Rectangle {
            height: closeButton.implicitHeight
            color: "whitesmoke"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 5
                spacing: 5

                SkinButton {
                    icon.color: "transparent"
                    icon.source: iconUrl

                    onPressed: {
                        systemMenu.popup(border, border+closeButton.height);
                    }

                    onDoubleClicked: {
                        window.close();
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: window.title
                    verticalAlignment: Text.AlignVCenter

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onPressed: {
                            window.startSystemMove();
                        }

                        onDoubleClicked: {
                            if (!fixedSize) {
                                toggleMaximized();
                            }
                        }

                        onReleased: {
                            if (mouse.button === Qt.RightButton) {
                                systemMenu.popup();
                            }
                        }
                    }
                }

                RowLayout {
                    spacing: 0

                    SkinButton {
                        visible: window.flags & Qt.WindowMinimizeButtonHint
                        backColorDown: "darkgrey"
                        backColorHover: "lightgrey"
                        text: "🗕"
                        tooltip: qsTr("Minimize")
                        onClicked: window.showMinimized()
                    }

                    SkinButton {
                        visible: !fixedSize && (window.flags & Qt.WindowMaximizeButtonHint)
                        backColorDown: "darkgrey"
                        backColorHover: "lightgrey"
                        text: window.visibility == Window.Maximized ? "🗗" : "🗖"
                        tooltip: window.visibility == Window.Maximized ? qsTr("Restore") : qsTr("Maximize")
                        onClicked: window.toggleMaximized()
                    }

                    SkinButton {
                        id: closeButton
                        visible: window.flags & Qt.WindowCloseButtonHint
                        backColorDown: "darkred"
                        backColorHover: "red"
                        text: "🗙"
                        tooltip: qsTr("Close")
                        onClicked: window.close()
                    }
                }
            }
        }
    }

    function ptInRect(rc, x, y)
    {
        if ((rc.x <= x && x <= (rc.x + rc.width)) &&
           (rc.y <= y && y <= (rc.y + rc.height))) {
            return true;
        }

        return false;
    }

    function toggleMaximized()
    {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }
}
