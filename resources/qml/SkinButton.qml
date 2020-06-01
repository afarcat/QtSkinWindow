/* Copyright (C) 2020 afarcat <kabak@sina.com>. All rights reserved.
   Use of this source code is governed by a Apache license that can be
   found in the LICENSE file.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15

ToolButton {
    id: control
    hoverEnabled: true

    property color backColorNormal: "transparent"
    property color backColorDown: "transparent"
    property color backColorHover: "transparent"
    property string tooltip: ""

    //tooltip support
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.visible: hovered && (tooltip !== "")
    ToolTip.text: tooltip

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 40

        width: parent.width
        height: parent.height
        color:control.down ? control.backColorDown : (control.hovered ? backColorHover : control.backColorNormal)
    }
}
