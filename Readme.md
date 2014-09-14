## WinT Messenger 

[![Build Status](https://travis-ci.org/WinT-3794/WinT-Messenger.svg?branch=master)](https://travis-ci.org/WinT-3794/WinT-Messenger)

WinT Messenger is a practical instant messaging application developed by a small team of students working in the WinT 3794 team. The application is written in QML/C++ and can be used with the most popular desktop and mobile operating systems.

The application supports local

You can see how the whole app works here, or even write code to make it better!

## Contributing

1. Join [https://groups.google.com/forum/#!forum/wint-messenger](https://groups.google.com/forum/#!forum/wint-messenger) to stay up to date with the development and help the community!
2. Fork this project!
3. Make your changes on a branch.
4. Make changes!
5. Send pull request from your fork.
6. We'll review it, and push your changes to the site!

## License

This project is released under the GNU GPL 3.0 License.

## Useful links

+ [Project website](http://wint-im.sf.net)
+ [Wint 3794 website](http://wint3794.org)
+ [SourceForge Project](http://sf.net/p/wint-im)
+ [OpenHub Project](http://openhub.net/p/wint-im)
+ [Developer Documentation](http://wint-im.sf.net/doxygen/)
+ [Contact developer](mailto:alex.racotta@gmail.com)
+ [Contact WinT 3794](mailto:wint3794@hotmail.com)

## Developer's notes

### Notes

This project's code is divided in modules, so you can take the code from an individual module, such as the LAN Chat module (qchat) and easily implement it in your program. Each chat module is completely standalone and has an example 

For the moment, we have implemented the following modules:

+ LAN Chat with file sharing support (src/modules/qchat)
+ XMPP Chat based on QXMPP libraries (src/modules/xmpp)

## Setup/Compiling

### Windows

1. Install the Qt SDK from [http://qt-project.org/downloads](http://qt-project.org/downloads).
2. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code and extract it with your favorite ZIP utility.
3. Open the wint-im.pro file with Qt Creator.
4. Configure the project by selecting Windows as your target system.
5. Select the "release" build option.
5. Build and run WinT Messenger by pressing CTRL + R.

**Notes:** 

+ In order to compile the application, you will need to install OpenSSL in "C:\OpenSSL-Win32\". You can get the installer [here](http://slproweb.com/download/Win32OpenSSL-1_0_1h.exe).

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
10. To install, navigate to the directory where you extracted the source code and locate a folder similar to "build-wint-im-Desktop_Qt_5_3_clang_64bit-Release/app/" and copy the WinT Messenger.app to your Applications folder.

### Linux

#### Method 1 (Recommended)

1. Install the Qt SDK from [http://qt-project.org/downloads](http://qt-project.org/downloads).
2. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code and extract it with your favorite ZIP utility.
3. Open the wint-im.pro file with Qt Creator.
4. Configure the project by selecting Windows as your target system.
5. Select the "release" build option.
5. Build and run WinT Messenger by pressing CTRL + R.
6. Navigate to the build directory with your preferred terminal emulator.
7. Run "sudo make install" (without the quotes) to configure and install the application.

#### Method 2 (Ubuntu-based distros only)

1. [Download](https://github.com/WinT-3794/WinT-Messenger/archive/master.zip) the source code.

2. Run the following commands to install the required packages for compiling

        sudo add-apt-repository --yes ppa:ubuntu-sdk-team/ppa
        sudo add-apt-repository --yes ppa:canonical-qt5-edgers/qt5-beta2
        sudo apt-get update
        sudo apt-get install build-essential qt5-qmake openssl-devel libssl-dev libpulse-dev qtbase5-dev qtdeclarative
        
	+ Note that your distribution may require more packages to be installed.

3. Then, go to your downloads folder and unzip the current commit.

        cd ~/Downloads
        unzip WinT-Messenger-master.zip -d WinT-Messenger-master
        cd WinT-Messenger-master
	
4. Make a directory to build the software
    
    	mkdir build
    	cd build
    
5. Compile the application

        qmake -qt=qt5 ../wint-im.pro
        make
    
6. Run the application
	
        make clean
        cd app
        ./wint-messenger
	
7. To install WinT Messenger, run the following:

        sudo make install
	
That's all! To run WinT Messenger, you can type "wint-messenger" (without quotes) in Terminal. You can also run WinT Messenger from your application menu (Gnome) or Dash (Unity).
