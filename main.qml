import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/resources/qml"

SkinWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Skin Window Demo")
    iconUrl: "qrc:/resources/images/qt-logo.png"

    //for test fixedSize
    /*minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 480
    maximumHeight: 480*/

    ScrollView {
        parent: windowContent   //MUST use this for display titleBar
        anchors.fill: parent

        ListView {
            id: listView
            width: parent.width
            model: 20

            delegate: ItemDelegate {
                width: parent.width
                highlighted: ListView.isCurrentItem
                onClicked: listView.currentIndex = index
                text: "Item " + (index + 1)
            }
        }
    }
}
