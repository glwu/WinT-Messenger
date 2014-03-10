WinT LMS Build instructions
---------------------------

To build the app, you must:
    1. Install the Qt SDK >= 5.2.0
    2. Install XCode CLI tools on Mac.
    3. Install the Qt libs on Linux/UNIX.

*I: Compiling from the command line:*
    1. Navigate to the project directory using the 'cd' command.
    2. Run 'qmake':
        -> On Windows:
           + qmake --spec win32 
        -> On Mac: 
           + qmake --spec macx-g++
        -> On other UNIX desktop systems (such as Linux and BSD), qmake usually works directly.
    3. Run 'make' to begin the compilation process.
    4. If everything went correctly, you should have obtained a binary.
    5. Run 'make clean' to remove all object (*.o) files and the C++ mockup files.
    6. You are virtually done now, if you want to prepare the binary for deployment, refer to part III.

*II: Compiling from Qt Creator.*
    1. Open the lms.pro file with Qt Creator.
    2. Set the build options.
    3. Compile it by clicking on the build button.

*III: Deployment*
    **You should compile the app in 'release' mode**
    1. UNIX/Linux:
        + Most distributions already come with the Qt libraries preinstalled, it's not necessary to add the Qt libs manually.
        + It's preferred to compile the program under both 32 bit and 64 bit architectures.
        + You can create DEB and RPM packages, but it's a pain in the ass.
            + Most Linux users are smart enough to run the installation script (provided in the Systems folder).

    2. Mac OS X:
        + Run the 'macdeployqt' tool and copy the resulting app bundle in a DMG image.

    3. Windows:
	+ Build Qt statically.
        + Compile the project statically.
        + Test as required.
        + Package the resulting folder into an NSIS installer.
   
    4. Mobile systems:
        + Use the official IDE's (such as XCode for iOS) to build and deploy the app for mobile devices.