//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "../Headers/Bridge.h"

#ifdef Q_OS_WIN
#include <qt_windows.h>
#include <qwindowdefs_win.h>
#endif

Bridge::Bridge() {
  _btChatEnabled = false;
  _netChatEnabled = false;
  _netHotspot = false;
}

Bridge::~Bridge() {
  stopBtChat();
  stopNetChat();
  stopHotspot();
}

void Bridge::attachFile() {
  if (netChatEnabled())
    netChat->shareFile();

  if (btChatEnabled())
    btChat->shareFile();
}

void Bridge::sendMessage(QString text) {
  returnPressed(text);
}

void Bridge::startNetChat() {
  stopNetChat();

  netChat = new NetChat();
  netChatObjects.append(netChat);
  _netChatEnabled = true;

  QObject::connect(netChat, SIGNAL(newMessage(QString)),    this,    SLOT(processMessage(QString)));
  QObject::connect(netChat, SIGNAL(newUser(QString)),       this,    SIGNAL(newUser(QString)));
  QObject::connect(netChat, SIGNAL(delUser(QString)),       this,    SIGNAL(delUser(QString)));
  QObject::connect(this,    SIGNAL(returnPressed(QString)), netChat, SLOT(returnPressed(QString)));
}

void Bridge::stopNetChat() {
  qDeleteAll(netChatObjects.begin(), netChatObjects.end());
  netChatObjects.clear();
  _netChatEnabled = false;
}

void Bridge::startBtChat() {
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS) && !defined(Q_OS_BLACKBERRY)
  btChat = new BtChat();
  btChatObjects.append(btChat);
  _btChatEnabled = true;

  QObject::connect(btChat, SIGNAL(insertMessage(QString)),  this,    SLOT(processMessage(QString)));
  QObject::connect(btChat, SIGNAL(newUser(QString)),        this,    SIGNAL(newUser(QString)));
  QObject::connect(btChat, SIGNAL(delUser(QString)),        this,    SIGNAL(delUser(QString)));
  QObject::connect(this,    SIGNAL(returnPressed(QString)), btChat, SLOT(returnPressed(QString)));
#endif
}

void Bridge::stopBtChat() {
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS) && !defined(Q_OS_BLACKBERRY)
  qDeleteAll(btChatObjects.begin(), btChatObjects.end());
  btChatObjects.clear();
  _btChatEnabled = false;
#endif
}

void Bridge::showBtSelector() {
  btChat->showBtSelector();
}

void Bridge::stopHotspot() {
  if (hotspotEnabled()) {
#ifdef Q_OS_WIN
      ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN STOP HOSTEDNETWORK", 0, SW_HIDE);
      stopNetChat();
      _netHotspot = false;
      return;
#endif

#ifdef Q_OS_ANDROID
      /// SOME FUNCTION TO STOP HOTSPOT
      stopNetChat();
      _netHotspot = false;
      return;
#endif

#ifdef Q_OS_LINUX
      /// SOME FUNCTION TO STOP HOTSPOT
      stopNetChat();
      _netHotspot = false;
      return;
#endif

#ifdef Q_OS_MAC
      /// SOME FUNCTION TO STOP HOTSPOT
      stopNetChat();
      _netHotspot = false;
      return;
#endif

#ifdef Q_OS_IOS
      /// SOME FUNCTION TO STOP HOTSPOT
      stopNetChat();
      _netHotspot = false;
      return;
#endif
   }
}

void Bridge::startHotspot(const QString &_ssid, const QString &_password) {
#ifdef Q_OS_WIN
  ShellExecute(0, L"RUNAS", L"NETSH", QString("WLAN SET HOSTED NETWORK MODE=ALLOW SSID=%1 KEY=%2").arg(_ssid, _password).toStdWString().c_str(), 0, SW_HIDE);
  ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN REFRESH HOSTEDNETWORK KEY", 0, SW_HIDE);
  ShellExecute(0, L"RUNAS", L"NETSH", L"WLAN START HOSTEDNETWORK",       0, SW_HIDE);

  startNetChat();
  _netHotspot = true;
  return;
#endif

#ifdef Q_OS_ANDROID
  /// SOME FUNCTION TO CREATE A HOTSPOT
#endif

#ifdef Q_OS_LINUX
  /// SOME FUNCTION TO CREATE A HOTSPOT
#endif

#ifdef Q_OS_MAC
  /// SOME FUNCTION TO CREATE A HOTSPOT
#endif

#ifdef Q_OS_IOS
  /// SOME FUNCTION TO CREATE A HOTSPOT
#endif
}

bool Bridge::netChatEnabled() {
  return _netChatEnabled;
}

bool Bridge::hotspotEnabled() {
  return _netHotspot;
}

bool Bridge::btChatEnabled() {
  return _btChatEnabled;
}

void Bridge::processMessage(const QString &text) {
  newMessage(MessageManager::addEmotes(text, DeviceManager::ratio(14)));
}
