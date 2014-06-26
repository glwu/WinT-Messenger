import QtQuick 2.2

// Draw a text with some common properties
Text {

    // Create the properties
    property string fontSize: "small"
    property string style: "default"

    // Set the font properties
    font.family: global.font
    font.pixelSize: units.fontSize(fontSize)

    // Set the color properties
    linkColor: Qt.darker(theme.primary, 1.2)
    color: style === "default" ? theme.textColor : theme.getStyleColor(style)
}
