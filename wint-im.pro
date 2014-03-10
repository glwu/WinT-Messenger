# Copyright (C) 2014 the WinT Team
# Please License.txt and the Authors.txt files for more information

TARGET   = wint-im
TEMPLATE = app

# Uncomment the following line for building the app statically
#CONFIG  += STATIC

# Make sure that all files are enconded in UTF-8
CODECFORTR  = UTF-8
CODECFORSRC = UTF-8

# Import the following Qt components
QT += gui
QT += quick
QT += network
QT += widgets
#QT += bluetooth

# Include the source code and the interface
include(Sources/src.pri)

# Additional options for iOS, Android, Windows & OS X
ios {
    QMAKE_INFO_PLIST = Systems/iOS/info.plist
    RC_FILE          = Systems/iOS/info.plist
    RC_FILE         += Systems/iOS/icon.png
    FONTS.files      = $$PWD/Interface/Resources/Fonts/Regular.ttf
    FONTS.path         = fonts
    QMAKE_BUNDLE_DATA += FONTS

    # Bluetooth is not currently supported in iOS
    QT -= bluetooth
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/Systems/Android
}

win32* {
    RC_FILE = Systems/Windows/icon.rc
}

macx {
    ICON    = Systems/Mac/icon.icns
    RC_FILE = Systems/Mac/info.plist

    CONFIG += app_bundle

    QMAKE_INFO_PLIST = Systems/Mac/info.plist
}

# Generate the resource file
RES += \
    $$PWD/Interface/QML/Pages/About.qml \
    $$PWD/Interface/QML/Pages/Connect.qml \
    $$PWD/Interface/QML/Pages/Donate.qml \
    $$PWD/Interface/QML/Pages/FirstLaunch.qml \
    $$PWD/Interface/QML/Pages/Help/AboutGPL.qml \
    $$PWD/Interface/QML/Pages/Help/AboutQt.qml \
    $$PWD/Interface/QML/Pages/Help/Credits.qml \
    $$PWD/Interface/QML/Pages/Help/Help.qml \
    $$PWD/Interface/QML/Pages/Help/Notice.qml \
    $$PWD/Interface/QML/Pages/Help/Documentation.qml \
    $$PWD/Interface/QML/Pages/LanChat.qml \
    $$PWD/Interface/QML/Pages/Preferences.qml \
    $$PWD/Interface/QML/Pages/Start.qml \
    $$PWD/Interface/QML/Widgets/Button.qml \
    $$PWD/Interface/QML/Widgets/ChatInterface.qml \
    $$PWD/Interface/QML/Widgets/Colors.qml \
    $$PWD/Interface/QML/Widgets/Label.qml \
    $$PWD/Interface/QML/Widgets/Logo.qml \
    $$PWD/Interface/QML/Widgets/Page.qml \
    $$PWD/Interface/QML/Widgets/Textbox.qml \
    $$PWD/Interface/QML/Widgets/Toolbar.qml \
    $$PWD/Interface/QML/main.qml \
    $$PWD/Interface/Resources/Fonts/Regular.ttf \

OTHER_FILES += $$RES
GENERATED_RES_FILE = $$OUT_PWD/resources.qrc

RES_CONTENT += \
    "<RCC>" \
    "    <qresource>"

for (res_file, RES) {
    res_absolute_path = $$absolute_path($$res_file)
    relativepath_in   = $$relative_path($$res_absolute_path, $$_PRO_FILE_PWD_)
    relativepath_out  = $$relative_path($$res_absolute_path, $$OUT_PWD)
    RES_CONTENT      += "        <file alias=\"$$relativepath_in\">$$relativepath_out</file>"
}

RES_CONTENT += \
    "    </qresource>" \
    "</RCC>"

write_file($$GENERATED_RES_FILE, RES_CONTENT) | error("Aww shit! There was a fucking error creating resources file!")

RESOURCES += $$GENERATED_RES_FILE \
    Interface/Resources/Emotes/emotes.qrc \
    Interface/Resources/Images/images.qrc
