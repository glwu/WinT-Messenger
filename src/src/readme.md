# WinT Messenger

---

[![Build Status](https://travis-ci.org/WinT-3794/WinT-Messenger.svg?branch=master)](https://travis-ci.org/WinT-3794/WinT-Messenger)

### Description of src module

The src module initializes and configures the QML interface and binds the qchat and xmpp modules to the QML interface using the *Bridge* class.

### Files
	
**Headers:**
	
+ <u>src/src/bridge.h</u>

	+ Definition of the *Bridge* class, which comunicates the QML interface with the chat modules (../modules).
	
+ <u>src/src/device_manager.h</u>

	+ Definition of the *DeviceManager* class, which determines the target operating system and implements a function to scale the QML interface to match the device's screen.
	
+ <u>src/src/settings.h</u>

	+ Definition of the *Settings* class, which implements a simple wrapper around QSettings for the QML interface.
	
+ <u>src/src/updater.h</u>

	+ Definition of the *Updater* class, which implements a simple way to check for application updates.

**Sources**
	
+ <u>src/main.cpp</u>

	+ Loads, configures and executes WinT Messenger.
	
+ <u>src/src/bridge.cpp</u>

	+ Implementation of the *Bridge* class.
	
+ <u>src/src/device_manager.cpp</u>

	+ Implementation of the *DeviceManager* class.
	
+ <u>src/src/settings.cpp</u>

	+ Implementation of the *Settings* class.
	
+ <u>src/src/udpater.cpp</u>

	+ Implementation of the *Updater* class.
	
