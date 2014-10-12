//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#ifndef PLATFORMS_H
#define PLATFORMS_H

/*!
 * \brief The Platforms header
 *
 * This header file allows us to
 * define macros that help us
 * identify the target operating system
 * and help us customize the software
 * based on the current operating system
 * during the compilation process.
 */

// First of all, define all systems as false
// so that we won't need to define them again
// in each #if defined(...)

#ifndef IOS
#define IOS false
#endif

#ifndef LINUX
#define LINUX false
#endif

#ifndef ANDROID
#define ANDROID false
#endif

#ifndef WINDOWS
#define WINDOWS false
#endif

#ifndef MAC_OS_X
#define MAC_OS_X false
#endif

#ifndef BLACKBERRY
#define BLACKBERRY false
#endif

#ifndef SSL_SUPPORT
#define SSL_SUPPORT true
#endif

// Define the defined OS as true, we need to undefine
// the macro before assigning a new value to avoid
// compilation warnings.

// iOS
#if defined(Q_OS_IOS)
#undef IOS
#undef SSL_SUPPORT
#define IOS true
#define SSL_SUPPORT false
#endif

// Linux
#if defined(Q_OS_LINUX)
#undef LINUX
#define LINUX true
#endif

// Android
#if defined(Q_OS_ANDROID)
#undef ANDROID
#define ANDROID true
#endif

// Windows
#if defined(Q_OS_WIN32)
#undef WINDOWS
#define WINDOWS true
#endif

// Mac OS X
#if defined(MAC_OS_X)
#undef MAC_OS_X
#define MAC_OS_X true
#endif

// BlackBerry
#if defined(Q_OS_BLACKBERRY)
#undef BLACKBERRY
#define BLACKBERRY true
#endif

// Define the MOBILE_TARGET macro
#if (ANDROID || IOS || BLACKBERRY)
#define MOBILE_TARGET true
#else
#define MOBILE_TARGET false
#endif

#endif
