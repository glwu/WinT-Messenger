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
QT += qml
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
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

win32* {
    RC_FILE = Systems/Windows/icon.rc
}

macx {
    ICON    = Systems/Mac/icon.icns
    RC_FILE = Systems/Mac/info.plist

    CONFIG += app_bundle

    QMAKE_INFO_PLIST = Systems/Mac/info.plist
    TARGET = "WinT\ Messenger"
}

RESOURCES += \
    Interface/Resources/Emotes/emotes.qrc \
    Interface/Resources/Images/images.qrc \
    Interface/QML/QML.qrc \
    Interface/Resources/Fonts/Fonts.qrc
