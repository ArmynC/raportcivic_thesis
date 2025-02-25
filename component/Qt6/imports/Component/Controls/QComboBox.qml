import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Component
import QtQuick.Templates as T

T.ComboBox {
    id: control
    signal commit(string text)
    property bool disabled: false
    property color normalColor: QTheme.dark ? Qt.rgba(62/255,62/255,62/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property color hoverColor: QTheme.dark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
    property color disableColor: QTheme.dark ? Qt.rgba(59/255,59/255,59/255,1) : Qt.rgba(252/255,252/255,252/255,1)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    font: QTextStyle.Body
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    enabled: !disabled
    delegate: QItemDelegate {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        palette.text: control.palette.text
        font: control.font
        palette.highlightedText: control.palette.highlightedText
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }
    focusPolicy:Qt.TabFocus
    indicator: QIcon {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 28
        iconSource:FluentIcons.ChevronDown
        iconSize: 15
        opacity: enabled ? 1 : 0.3
    }
    contentItem: T.TextField {
        property bool disabled: !control.editable
        leftPadding: !control.mirrored ? 10 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 10 : control.editable && activeFocus ? 3 : 1
        topPadding: 6 - control.padding
        bottomPadding: 6 - control.padding
        renderType: QTheme.nativeText ? Text.NativeRendering : Text.QtRendering
        selectionColor: QTools.withOpacity(QTheme.primaryColor,0.5)
        selectedTextColor: color
        text: control.editable ? control.editText : control.displayText
        enabled: control.editable
        autoScroll: control.editable
        font:control.font
        readOnly: control.down
        color: {
            if(control.disabled) {
                return QTheme.dark ? Qt.rgba(131/255,131/255,131/255,1) : Qt.rgba(160/255,160/255,160/255,1)
            }
            return QTheme.dark ?  Qt.rgba(255/255,255/255,255/255,1) : Qt.rgba(27/255,27/255,27/255,1)
        }
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: true
        verticalAlignment: Text.AlignVCenter
        background: QTextBoxBackground{
            border.width: 1
            bottomMargin: {
                if(!control.editable){
                    return 1
                }
                return contentItem && contentItem.activeFocus ? 2 : 1
            }
            inputItem: contentItem
        }
        Component.onCompleted: {
            forceActiveFocus()
        }
        Keys.onEnterPressed: (event)=> handleCommit(event)
        Keys.onReturnPressed:(event)=> handleCommit(event)
        function handleCommit(event){
            control.commit(control.editText)
            accepted()
        }
    }
    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 32
        border.color: QTheme.dark ? "#505050" : "#DFDFDF"
        border.width: 1
        visible: !control.flat || control.down
        radius: 4
        QFocusRectangle{
            visible: control.visualFocus
            radius:4
            anchors.margins: -2
        }
        color:{
            if(disabled){
                return disableColor
            }
            return hovered ? hoverColor :normalColor
        }
    }
    popup: T.Popup {
        y: control.height
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight, control.Window.height * 0.5) // mid height
        topMargin: 6
        bottomMargin: 6
        modal: true
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0
            T.ScrollIndicator.vertical: ScrollIndicator { }
        }
        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from:0
                to:1
                duration: QTheme.animationEnabled ? 83 : 0
            }
        }
        exit:Transition {
            NumberAnimation {
                property: "opacity"
                from:1
                to:0
                duration: QTheme.animationEnabled ? 83 : 0
            }
        }
        background:Rectangle{
            color:QTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(249/255,249/255,249/255,1)
            border.color: QTheme.dark ? Window.active ? Qt.rgba(55/255,55/255,55/255,1):Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
            border.width: 1
            radius: 5
            QShadow{
                radius: 5
            }
        }
    }
}
