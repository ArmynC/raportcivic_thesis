import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Component

QButton {
    text: {
        if(control.current){
            return control.current.toLocaleDateString(QApp.locale,"yyyy/M/d")
        }
        return qsTr("Alege data")
    }
    property date from: new Date(1924, 0, 1)
    property date to: new Date(2124, 11, 31)
    property var current
    signal accepted()
    id:control
    onClicked: {
        popup.showPopup()
    }
    rightPadding: 36
    CalendarModel {
        id:calender_model
        from: control.from
        to: control.to
    }
    Item{
        id:d
        property var window : Window.window
        property date displayDate: {
            if(control.current){
                return control.current
            }
            return new Date()
        }
        property date toDay : new Date()
        property int pageIndex: 0
        signal nextButton
        signal previousButton
        property point yearRing : Qt.point(0,0)
    }
    QIcon{
        iconSource: FluentIcons.Calendar
        iconSize: 14
        iconColor: control.textColor
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 12
        }
    }
    Menu{
        id:popup
        height: container.height
        width: container.width
        modal: true
        Overlay.modal: Item {}
        enter: Transition {
            reversible: true
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
        contentItem: Item{
            clip: true
            QFrame{
                id:container
                width: 300
                height: 360
                ColumnLayout  {
                    anchors.fill: parent
                    spacing: 0
                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        RowLayout{
                            anchors.fill: parent
                            spacing: 10
                            Item{
                                Layout.leftMargin: parent.spacing
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                QTextButton{
                                    width: parent.width
                                    anchors.centerIn: parent
                                    contentItem: QText {
                                        text: d.displayDate.toLocaleString(QApp.locale, "MMMM yyyy")
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    visible: d.pageIndex === 0
                                    onClicked: {
                                        d.pageIndex = 1
                                    }
                                }
                                QTextButton{
                                    width: parent.width
                                    anchors.centerIn: parent
                                    contentItem: QText {
                                        text: d.displayDate.toLocaleString(QApp.locale, "yyyy")
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    visible: d.pageIndex === 1
                                    onClicked: {
                                        d.pageIndex = 2
                                    }
                                }
                                QTextButton{
                                    width: parent.width
                                    anchors.centerIn: parent
                                    contentItem: QText {
                                        text: "%1-%2".arg(d.yearRing.x).arg(d.yearRing.y)
                                        verticalAlignment: Text.AlignVCenter
                                        textColor: QTheme.fontTertiaryColor
                                    }
                                    visible: d.pageIndex === 2
                                }
                            }
                            QIconButton{
                                id:icon_up
                                iconSource: FluentIcons.CaretUpSolid8
                                iconSize: 10
                                onClicked: {
                                    d.previousButton()
                                }
                            }
                            QIconButton{
                                id:icon_down
                                iconSource: FluentIcons.CaretDownSolid8
                                iconSize: 10
                                Layout.rightMargin: parent.spacing
                                onClicked: {
                                    d.nextButton()
                                }
                            }
                        }
                        QDivider{
                            width: parent.width
                            height: 1
                            anchors.bottom: parent.bottom
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        StackView{
                            id:stack_view
                            anchors.fill: parent
                            initialItem: com_page_one
                            replaceEnter : Transition{
                                OpacityAnimator{
                                    from: 0
                                    to: 1
                                    duration: 83
                                }
                                ScaleAnimator{
                                    from: 0.5
                                    to: 1
                                    duration: 167
                                    easing.type: Easing.OutCubic
                                }
                            }
                            replaceExit : Transition{
                                OpacityAnimator{
                                    from: 1
                                    to: 0
                                    duration: 83
                                }
                                ScaleAnimator{
                                    from: 1.0
                                    to: 0.5
                                    duration: 167
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                        Connections{
                            target: d
                            function onPageIndexChanged(){
                                if(d.pageIndex === 0){
                                    stack_view.replace(com_page_one)
                                }
                                if(d.pageIndex === 1){
                                    stack_view.replace(com_page_two)
                                }
                                if(d.pageIndex === 2){
                                    stack_view.replace(com_page_three)
                                }
                            }
                        }
                        Component{
                            id:com_page_three
                            GridView{
                                id:grid_view
                                cellHeight: 75
                                cellWidth: 75
                                clip: true
                                boundsBehavior: GridView.StopAtBounds
                                ScrollBar.vertical: QScrollBar {}
                                model: {
                                    var fromYear = calender_model.from.getFullYear()
                                    var toYear = calender_model.to.getFullYear()
                                    return toYear-fromYear+1
                                }
                                highlightRangeMode: GridView.StrictlyEnforceRange
                                onCurrentIndexChanged:{
                                    var year = currentIndex + calender_model.from.getFullYear()
                                    var start = Math.ceil(year / 10) * 10
                                    var end = start+10
                                    d.yearRing = Qt.point(start,end)
                                }
                                highlightMoveDuration: 100
                                Component.onCompleted: {
                                    grid_view.highlightMoveDuration = 0
                                    currentIndex = d.displayDate.getFullYear()-calender_model.from.getFullYear()
                                    timer_delay.restart()
                                }
                                Connections{
                                    target: d
                                    function onNextButton(){
                                        grid_view.currentIndex = Math.min(grid_view.currentIndex+16,grid_view.count-1)
                                    }
                                    function onPreviousButton(){
                                        grid_view.currentIndex = Math.max(grid_view.currentIndex-16,0)
                                    }
                                }
                                Timer{
                                    id:timer_delay
                                    interval: 100
                                    onTriggered: {
                                        grid_view.highlightMoveDuration = 100
                                    }
                                }
                                currentIndex: -1
                                delegate: Item{
                                    property int year : calender_model.from.getFullYear()+modelData
                                    property bool toYear: year === d.toDay.getFullYear()
                                    implicitHeight: 75
                                    implicitWidth: 75
                                    QControl{
                                        id:control_delegate
                                        width: 60
                                        height: 60
                                        anchors.centerIn: parent
                                        Rectangle{
                                            width: 48
                                            height: 48
                                            radius: width/2
                                            color: {
                                                if(toYear){
                                                    if(control_delegate.pressed){
                                                        return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.2) : Qt.lighter(QTheme.primaryColor,1.2)
                                                    }
                                                    if(control_delegate.hovered){
                                                        return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.1) : Qt.lighter(QTheme.primaryColor,1.1)
                                                    }
                                                    return QTheme.primaryColor
                                                }else{
                                                    if(control_delegate.pressed){
                                                        return QTheme.itemPressColor
                                                    }
                                                    if(control_delegate.hovered){
                                                        return QTheme.itemHoverColor
                                                    }
                                                    return QColors.Transparent
                                                }
                                            }
                                            anchors.centerIn: parent
                                        }

                                        QText{
                                            text: year
                                            anchors.centerIn: parent
                                            opacity: {
                                                if(year >= d.yearRing.x &&  year <= d.yearRing.y){
                                                    return 1
                                                }
                                                if(control_delegate.hovered){
                                                    return 1
                                                }
                                                return 0.3
                                            }
                                            color: {
                                                if(toYear){
                                                    return QColors.White
                                                }
                                                if(control_delegate.pressed){
                                                    return QTheme.dark ? QColors.Grey100 : QColors.Grey100
                                                }
                                                if(control_delegate.hovered){
                                                    return QTheme.dark ? QColors.Grey80 : QColors.Grey120
                                                }
                                                return QTheme.dark ? QColors.White : QColors.Grey220
                                            }
                                        }
                                        onClicked: {
                                            d.displayDate = new Date(year,0,1)
                                            d.pageIndex = 1
                                        }
                                    }
                                }
                            }
                        }
                        Component{
                            id:com_page_two

                            ListView{
                                id:listview
                                ScrollBar.vertical: QScrollBar {}
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                clip: true
                                boundsBehavior: ListView.StopAtBounds
                                spacing: 0
                                highlightMoveDuration: 100
                                model: {
                                    var fromYear = calender_model.from.getFullYear()
                                    var toYear = calender_model.to.getFullYear()
                                    var yearsArray = []
                                    for (var i = fromYear; i <= toYear; i++) {
                                        yearsArray.push(i)
                                    }
                                    return yearsArray
                                }
                                currentIndex: -1
                                onCurrentIndexChanged:{
                                    var year = model[currentIndex]
                                    var month = d.displayDate.getMonth()
                                    d.displayDate = new Date(year,month,1)
                                }
                                Connections{
                                    target: d
                                    function onNextButton(){
                                        listview.currentIndex = Math.min(listview.currentIndex+1,listview.count-1)
                                    }
                                    function onPreviousButton(){
                                        listview.currentIndex = Math.max(listview.currentIndex-1,0)
                                    }
                                }
                                Component.onCompleted: {
                                    listview.highlightMoveDuration = 0
                                    currentIndex = model.indexOf(d.displayDate.getFullYear())
                                    timer_delay.restart()
                                }
                                Timer{
                                    id:timer_delay
                                    interval: 100
                                    onTriggered: {
                                        listview.highlightMoveDuration = 100
                                    }
                                }
                                delegate: Item{
                                    id:layout_congrol
                                    property int year : modelData
                                    width: listview.width
                                    height: 75*3
                                    GridView{
                                        anchors.fill: parent
                                        cellHeight: 75
                                        cellWidth: 75
                                        clip: true
                                        interactive: false
                                        boundsBehavior: GridView.StopAtBounds
                                        model: 12
                                        delegate: Item{
                                            property int month : modelData
                                            property bool toMonth: layout_congrol.year === d.toDay.getFullYear() && month === d.toDay.getMonth()
                                            implicitHeight: 75
                                            implicitWidth: 75
                                            QControl{
                                                id:control_delegate
                                                width: 60
                                                height: 60
                                                anchors.centerIn: parent
                                                Rectangle{
                                                    width: 48
                                                    height: 48
                                                    radius: width/2
                                                    color: {
                                                        if(toMonth){
                                                            if(control_delegate.pressed){
                                                                return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.2) : Qt.lighter(QTheme.primaryColor,1.2)
                                                            }
                                                            if(control_delegate.hovered){
                                                                return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.1) : Qt.lighter(QTheme.primaryColor,1.1)
                                                            }
                                                            return QTheme.primaryColor
                                                        }else{
                                                            if(control_delegate.pressed){
                                                                return QTheme.itemPressColor
                                                            }
                                                            if(control_delegate.hovered){
                                                                return QTheme.itemHoverColor
                                                            }
                                                            return QColors.Transparent
                                                        }
                                                    }
                                                    anchors.centerIn: parent
                                                }
                                                QText{
                                                    text: new Date(layout_congrol.year,month).toLocaleString(QApp.locale, "MMMM")
                                                    anchors.centerIn: parent
                                                    opacity: {
                                                        if(layout_congrol.year === d.displayDate.getFullYear()){
                                                            return 1
                                                        }
                                                        if(control_delegate.hovered){
                                                            return 1
                                                        }
                                                        return 0.3
                                                    }
                                                    color: {
                                                        if(toMonth){
                                                            return QColors.White
                                                        }
                                                        if(control_delegate.pressed){
                                                            return QTheme.dark ? QColors.Grey100 : QColors.Grey100
                                                        }
                                                        if(control_delegate.hovered){
                                                            return QTheme.dark ? QColors.Grey80 : QColors.Grey120
                                                        }
                                                        return QTheme.dark ? QColors.White : QColors.Grey220
                                                    }
                                                }
                                                onClicked: {
                                                    d.displayDate = new Date(layout_congrol.year,month)
                                                    d.pageIndex = 0
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Component{
                            id:com_page_one
                            ColumnLayout  {
                                DayOfWeekRow {
                                    id: dayOfWeekRow
                                    locale: QApp.locale
                                    font: QTextStyle.Body
                                    delegate: Label {
                                        text: model.shortName
                                        font: dayOfWeekRow.font
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    Layout.column: 1
                                    Layout.fillWidth: true
                                }
                                ListView{
                                    id:listview
                                    property bool isCompleted: false
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    highlightRangeMode: ListView.StrictlyEnforceRange
                                    clip: true
                                    boundsBehavior: ListView.StopAtBounds
                                    spacing: 0
                                    highlightMoveDuration: 100
                                    currentIndex: -1
                                    ScrollBar.vertical: QScrollBar {}
                                    onCurrentIndexChanged:{
                                        if(isCompleted){
                                            var month = calender_model.monthAt(currentIndex)
                                            var year = calender_model.yearAt(currentIndex)
                                            d.displayDate = new Date(year,month,1)
                                        }
                                    }
                                    Component.onCompleted: {
                                        listview.model = calender_model
                                        listview.highlightMoveDuration = 0
                                        currentIndex  = calender_model.indexOf(d.displayDate)
                                        timer_delay.restart()
                                        isCompleted = true
                                    }
                                    Timer{
                                        id:timer_delay
                                        interval: 100
                                        onTriggered: {
                                            listview.highlightMoveDuration = 100
                                        }
                                    }
                                    Connections{
                                        target: d
                                        function onNextButton(){
                                            listview.currentIndex = Math.min(listview.currentIndex+1,listview.count-1)
                                        }
                                        function onPreviousButton(){
                                            listview.currentIndex = Math.max(listview.currentIndex-1,0)
                                        }
                                    }
                                    delegate: MonthGrid {
                                        id: grid
                                        width: listview.width
                                        height: listview.height
                                        month: model.month
                                        year: model.year
                                        spacing: 0
                                        locale: QApp.locale
                                        delegate: QControl {
                                            required property bool today
                                            required property int year
                                            required property int month
                                            required property int day
                                            required property int visibleMonth
                                            id: control_delegate
                                            visibleMonth: grid.month
                                            implicitHeight: 40
                                            implicitWidth: 40
                                            Rectangle{
                                                width: 34
                                                height: 34
                                                radius: width/2
                                                color: {
                                                    if(today){
                                                        if(control_delegate.pressed){
                                                            return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.2) : Qt.lighter(QTheme.primaryColor,1.2)
                                                        }
                                                        if(control_delegate.hovered){
                                                            return QTheme.dark ? Qt.darker(QTheme.primaryColor,1.1) : Qt.lighter(QTheme.primaryColor,1.1)
                                                        }
                                                        return QTheme.primaryColor
                                                    }else{
                                                        if(control_delegate.pressed){
                                                            return QTheme.itemPressColor
                                                        }
                                                        if(control_delegate.hovered){
                                                            return QTheme.itemHoverColor
                                                        }
                                                        return QColors.Transparent
                                                    }
                                                }
                                                anchors.centerIn: parent
                                            }
                                            Rectangle{
                                                width: 40
                                                height: 40
                                                border.width: 1
                                                anchors.centerIn: parent
                                                radius: width/2
                                                border.color: QTheme.primaryColor
                                                color: QColors.Transparent
                                                visible: {
                                                    if(control.current){
                                                        var y = control.current.getFullYear()
                                                        var m = control.current.getMonth()
                                                        var d =  control.current.getDate()
                                                        if(y === year && m === month && d === day){
                                                            return true
                                                        }
                                                        return false
                                                    }
                                                    return false
                                                }
                                            }
                                            QText{
                                                text: day
                                                opacity: {
                                                    if(month === grid.month){
                                                        return 1
                                                    }
                                                    if(control_delegate.hovered){
                                                        return 1
                                                    }
                                                    return 0.3
                                                }
                                                anchors.centerIn: parent
                                                color: {
                                                    if(today){
                                                        return QColors.White
                                                    }
                                                    if(control_delegate.pressed){
                                                        return QTheme.dark ? QColors.Grey100 : QColors.Grey100
                                                    }
                                                    if(control_delegate.hovered){
                                                        return QTheme.dark ? QColors.Grey80 : QColors.Grey120
                                                    }
                                                    return QTheme.dark ? QColors.White : QColors.Grey220
                                                }
                                            }
                                            onClicked: {
                                                control.current = new Date(year,month,day)
                                                control.accepted()
                                                popup.close()
                                            }
                                        }
                                        background: Item {
                                            x: grid.leftPadding
                                            y: grid.topPadding
                                            width: grid.availableWidth
                                            height: grid.availableHeight
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        background: Item{
            QShadow{
                radius: 5
            }
        }
        function showPopup() {
            var pos = control.mapToItem(null, 0, 0)
            if(d.window.height>pos.y+control.height+container.height){
                popup.y = control.height
            } else if(pos.y>container.height){
                popup.y = -container.height
            } else {
                popup.y = d.window.height-(pos.y+container.height)
            }
            popup.x = -(popup.width-control.width)/2
            popup.open()
        }
    }
}
