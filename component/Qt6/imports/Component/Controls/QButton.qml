import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Component


Button {
    property bool disabled: false
    property string contentDescription: ""
    property color normalColor: QTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property color hoverColor: QTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(246/255,246/255,246/255,1)
    property color disableColor: QTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(251/255,251/255,251/255,1)
    property color dividerColor: QTheme.dark ? Qt.rgba(80/255,80/255,80/255,1) : Qt.rgba(233/255,233/255,233/255,1)
    property color textColor: {
        if(QTheme.dark){
            if(!enabled){
                return Qt.rgba(131/255,131/255,131/255,1)
            }
            if(pressed){
                return Qt.rgba(162/255,162/255,162/255,1)
            }
            return Qt.rgba(1,1,1,1)
        }else{
            if(!enabled){
                return Qt.rgba(160/255,160/255,160/255,1)
            }
            if(pressed){
                return Qt.rgba(96/255,96/255,96/255,1)
            }
            return Qt.rgba(0,0,0,1)
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked()
    id: control
    enabled: !disabled
    verticalPadding: 0
    horizontalPadding:12
    font:QTextStyle.Body
    focusPolicy:Qt.TabFocus
    background: QControlBackground{
        implicitWidth: 30
        implicitHeight: 30
        radius: 4
        color: {
            if(!enabled){
                return disableColor
            }
            return hovered ? hoverColor :normalColor
        }
        shadow: !pressed && enabled
        QFocusRectangle{
            visible: control.activeFocus
            radius:4
        }
    }
    contentItem: QText {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: control.font
        color: control.textColor
    }
}
