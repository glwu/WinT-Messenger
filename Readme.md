# WinT Messenger

*Simple and lightweight messaging application*

---

[![Build Status](https://travis-ci.org/WinT-3794/WinT-Messenger.svg?branch=master)](https://travis-ci.org/WinT-3794/WinT-Messenger)

WinT Messenger is a practical instant messaging application developed by a small team of students working in the WinT 3794 team. The application is written in QML/C++ and can be used with the most popular desktop and mobile operating systems.

You can see how the whole app works here, or even write code to make it better!

## Contributing

1. Join [https://groups.google.com/forum/#!forum/wint-messenger](https://groups.google.com/forum/#!forum/wint-messenger) to stay up to date with the development and help the community!
2. Fork this project!
3. Make your changes on a branch.
4. Make changes!
5. Send pull request from your fork.
6. We'll review it, and push your changes to the site!

## Developer's documentation

You can find the Doxygen documentation for version 1.2.1 [here](http://wint-im.sf.net/dev-doc/html/index.html). Updated documentation for 1.3.0 will be uploaded soon.


## Setup/Compiling

### Windows

1. Install the Qt SDK from [http://qt-project.org/downloads](http://qt-project.org/downloads).
2. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code and extract it with your favorite ZIP utility.
3. Open the wint-im.pro file with Qt Creator.
4. Configure the project by selecting Windows as your target system.
5. Select the "release" build option.
5. Build and run WinT Messenger by pressing CTRL + R.

**Note:** If you want to install the software, you will need to deploy it with the "windeployqt" tool. I will upload instructions regarding deployment soon.

### Mac OS X

1. Download Xcode from the App Store.
2. Open Xcode and accept the license agreement.
3. After you accept the license agreement, you can safely quit Xcode (CMD + Q).
4. Install the Qt SDK from [http://qt-project.org/downloads](http://qt-project.org/downloads).
5. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code and extract it with your favorite ZIP utility.
6. Open the wint-im.pro file with Qt Creator.
7. Configure the project by selecting Mac OS X as your target system.
8. Select the "release" build option.
9. Build and run WinT Messenger by pressing CMD + R.
10. To install, navigate to the directory where you extracted the source code and locate a folder similar to "build-wint-im-Desktop_Qt_5_3_clang_64bit-Release" and copy the WinT Messenger.app to your Applications folder.

### Ubuntu-based distros

1. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code.

2. Run the following commands to install the required packages for compiling

   		sudo add-apt-repository --yes ppa:ubuntu-sdk-team/ppa
    	sudo add-apt-repository --yes ppa:canonical-qt5-edgers/qt5-beta2
    	sudo apt-get update -qq
    	sudo apt-get install -qq qt5-qmake libpulse-dev qtbase5-dev qtdeclarative$

3. Then, go to your downloads folder and unzip the current commit.

		cd ~/Downloads
		unzip WinT-Messenger-master.zip -d Wint-Messenger-master
		cd wint-messenger-master
	
4. Make a directory to build the software
    
    	mkdir build
    	cd build
    
5. Compile the application

    	qmake -qt=qt5 ../wint-im.pro
	    make
    
6. Run the application
	
		make clean
		./wint-messenger
	
7. To install WinT Messenger, run the following:

		sudo cp wint-messenger /usr/bin/wint-messenger
	
8. Create the application launchers for your application menu:

		cd ../sys/linux
		sudo cp wint-messenger.svg /usr/share/pixmaps/wint-messenger.svg
		sudo cp wint-messenger.desktop /usr/share/applications/wint-messenger.desktop
		
**Note:** We will configure the project to create an installation script for the next commit during the following week.
	
That's all! To run WinT Messenger, you can type "wint-messenger" (without quotes) in Terminal. You can also run WinT Messenger from your application menu (Gnome) or Dash (Unity).
