# WinT Messenger

---

[![Build Status](https://travis-ci.org/WinT-3794/WinT-Messenger.svg?branch=master)](https://travis-ci.org/WinT-3794/WinT-Messenger)

### Description of qchat module

The qchat module implements an simple and lightweight LAN chat implementation that has the ability to:

+ Send/receive formated messages
+ Send/receive user information, such as nickname and profile picture
+ Send/receive binary files

Note that for each peer we will have two connections, one for sending/receiving messages and another for sending/receiving files. We need to have two connections so that the sender of a file can receive and send messages while the file is transfered to the rest of the group.

**Note:** The design and implementation of the qChat module is inspired by [Nokia's Network Chat Example](http://doc.qt.digia.com/4.6/network-network-chat.html).

### Files
	
**Headers:**
	
+ <u>src/client.h</u>

	+ Definition of the *Client* class, which manages peer-to-peer connections to send and receive data.
	
+ <u>src/peermanager.h</u>

	+ Definition of the *PeerManager* class, which searches and discovers for new peers in the network.
	
+ <u>src/qchat.h</u>

	+ Definition of the *QChat* class, which provides a simple and customizable wraper around the *Client* class.
	
+ <u>src/file-connection/f_connection.h</u>

	+ Definition of the *FConnection* class (F stands for File), which allows us to share and receive files and information about the shared files, such as the file size, the file name and the progress of the download.
	
+ <u>src/file-connection/f_server.h</u>

	+ Listens for incoming connections and redirects them to the *PeerManager* so that we can connect to new peers. This process only happens once per connected peer and it can be viewed as the "identification" process. 
	
+ <u>src/message-connection/m_connection.h</u>

	+ Definition of the *MConnection* class (M stands for Message), which allows us to share and receive messages.
	
+ <u>src/message-connection/m_server.h</u>

	+ Listens for incoming connections and redirects them to the *PeerManager* so that we can connect to new peers. This process only happens once per connected peer and it can be viewed as the "identification" process. 
	

**Sources**
	
+ <u>src/client.cpp</u>

	+ Implementation of the *Client* class.
	
+ <u>src/peermanager.cpp</u>

	+ Implementation of the *PeerManager* class.
	
+ <u>src/qchat.cpp</u>

	+ Implementation of the *QChat* class.
	
+ <u>src/file-connection/f_connection.cpp</u>

	+ Implementation of the *FConnection* class.
	
+ <u>src/file-connection/f_server.cpp</u>

	+ Implementation of the *FServer* class.
	
+ <u>src/message-connection/m_connection.cpp</u>

	+ Implementation of the *MConnection* class.
	
+ <u>src/message-connection/m_server.cpp</u>

	+ Implementation of the *MServer* class.
	
