import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import Component

T.SpinBox {
    id: control
    property bool disabled: false
    property color normalColor: QTheme.dark ? Qt.rgba(56/255,56/255,56/255,1) : Qt.rgba(232/255,232/255,232/255,1)
    property color hoverColor: QTheme.dark ? Qt.rgba(64/255,64/255,64/255,1) : Qt.rgba(224/255,224/255,224/255,1)
    property color pressedColor: QTheme.dark ? Qt.rgba(72/255,72/255,72/255,1) : Qt.rgba(216/255,216/255,216/255,1)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             up.implicitIndicatorHeight, down.implicitIndicatorHeight)
    leftPadding: padding + (control.mirrored ? (up.indicator ? up.indicator.width : 0) : (down.indicator ? down.indicator.width : 0))
    rightPadding: padding + (control.mirrored ? (down.indicator ? down.indicator.width : 0) : (up.indicator ? up.indicator.width : 0))
    enabled: !disabled
    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        property color normalColor: QTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
        property color disableColor: QTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        property color placeholderNormalColor: QTheme.dark ? Qt.rgba(210/255,210/255,210/255,1) : Qt.rgba(96/255,96/255,96/255,1)
        property color placeholderFocusColor: QTheme.dark ? Qt.rgba(152/255,152/255,152/255,1) : Qt.rgba(141/255,141/255,141/255,1)
        property color placeholderDisableColor: QTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
        z: 2
        text: control.displayText
        clip: width < implicitWidth
        padding: 6
        font: control.font
        color: {
            if(!enabled){
                return disableColor
            }
            return normalColor
        }
        selectionColor: QTools.withOpacity(QTheme.primaryColor,0.5)
        selectedTextColor: color
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        Rectangle{
            width: parent.width
            height: contentItem.activeFocus ? 2 : 1
            anchors.bottom: parent.bottom
            visible: contentItem.enabled
            color: {
                if(contentItem.activeFocus){
                    return QTheme.primaryColor
                }
                if(QTheme.dark){
                    return Qt.rgba(166/255,166/255,166/255,1)
                }else{
                    return Qt.rgba(183/255,183/255,183/255,1)
                }
            }
            Behavior on height{
                enabled: QTheme.animationEnabled
                NumberAnimation{
                    duration: 83
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    up.indicator: QClip {
        x: control.mirrored ? 0 : control.width - width
        height: control.height
        implicitWidth: 32
        implicitHeight: 32
        radius: [0,4,4,0]
        Rectangle{
            anchors.fill: parent
            color: {
                if(control.up.pressed){
                    return control.pressedColor
                }
                if(control.up.hovered){
                    return control.hoverColor
                }
                return control.normalColor
            }
        }
        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: enabled ? QTheme.dark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1) : QColors.Grey90
        }
        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: 2
            height: parent.width / 3
            color: enabled ? QTheme.dark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1) : QColors.Grey90
        }
    }


    down.indicator: QClip {
        x: control.mirrored ? parent.width - width : 0
        height: control.height
        implicitWidth: 32
        implicitHeight: 32
        radius: [4,0,0,4]
        Rectangle{
            anchors.fill: parent
            color: {
                if(control.down.pressed){
                    return control.pressedColor
                }
                if(control.down.hovered){
                    return control.hoverColor
                }
                return normalColor
            }
        }
        Rectangle {
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: parent.width / 3
            height: 2
            color: enabled ? QTheme.dark ? Qt.rgba(1,1,1,1) : Qt.rgba(0,0,0,1) : QColors.Grey90
        }
    }

    background: Rectangle {
        implicitWidth: 136
        radius: 4
        border.width: 1
        border.color: {
            if(contentItem.disabled){
                return QTheme.dark ? Qt.rgba(73/255,73/255,73/255,1) : Qt.rgba(237/255,237/255,237/255,1)
            }
            return QTheme.dark ? Qt.rgba(76/255,76/255,76/255,1) : Qt.rgba(240/255,240/255,240/255,1)
        }
        color: {
            if(contentItem.disabled){
                return QTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
            }
            if(contentItem.activeFocus){
                return QTheme.dark ? Qt.rgba(36/255,36/255,36/255,1) : Qt.rgba(1,1,1,1)
            }
            if(contentItem.hovered){
                return QTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
            }
            return QTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(1,1,1,1)
        }
    }
}
