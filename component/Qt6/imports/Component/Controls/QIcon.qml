import QtQuick
import QtQuick.Controls
import Component

Text {
    property int iconSource
    property int iconSize: 20
    property color iconColor: QTheme.dark ? "#FFFFFF" : "#000000"
    id:control
    font.family: "Segoe Fluent Icons"
    font.pixelSize: iconSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: iconColor
    text: (String.fromCharCode(iconSource).toString(16))
    FontLoader{
        source: "../Font/Segoe_Fluent_Icons.ttf"
    }
}
