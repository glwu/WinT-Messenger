//
//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//  Please check the license.txt file for more information.
//

#include "window.h"

Window::Window(QWidget *parent) : QDialog(parent), ui(new Ui::Window) {
    ui->setupUi(this);

    // Get the user name
    nick = QInputDialog::getText(this, tr("Enter name"), tr("User name:"));

    // Create and configure the chat module
    qChat = new QChat();
    qChat->setNickname(nick);

    // Connect signals/slots
    connect(ui->appendButton, SIGNAL(clicked()), this, SLOT(shareFiles()));
    connect(qChat, SIGNAL(delUser(QString)), this, SLOT(removeUser(QString)));
    connect(ui->messageLineEdit, SIGNAL(returnPressed()), this, SLOT(returnPressed()));
    connect(qChat, SIGNAL(newUser(QString,QString)), this, SLOT(newUser(QString,QString)));
    connect(qChat, SIGNAL(newDownload(QString,QString,int)), this, SLOT(newDownload(QString,QString,int)));
    connect(qChat, SIGNAL(downloadComplete(QString,QString)), this, SLOT(downloadComplete(QString,QString)));
    connect(qChat, SIGNAL(newMessage(QString,QString,QString,QString,char)), this, SLOT(newMessage(QString,QString,QString,QString,char)));

    // Add the welcome message
    ui->chatLog->setTextColor(Qt::gray);
    ui->chatLog->append(tr("Welcome to the chat room!"));
    ui->chatLog->setTextColor(Qt::black);

    // Add ourselves to the user list
    ui->userList->addItem(tr("%1 (You)").arg(nick));
}

Window::~Window() {
    delete ui;
}

void Window::shareFiles() {
    // Get the selected items from the QFile dialog.
    QStringList filenames = QFileDialog::getOpenFileNames(0, tr("Select files"));

    // Get the number of selected files
    int count = filenames.count();

    // Get the number of selected files, this variable will decrease
    // each time that the sharing of an individual file is complete.
    int toUpload = filenames.count();

    // Send the selected files while toUpload is greater than 0
    while (toUpload > 0) {
        // Check that the file exists and send it
        if (!filenames.at(count - toUpload).isEmpty())
            qChat->shareFile(filenames.at(count - toUpload));

        // Decrease the number of files that need to be uploaded
        toUpload -= 1;
    }
}

void Window::returnPressed() {
    qChat->returnPressed(ui->messageLineEdit->text());
    ui->messageLineEdit->clear();
}

void Window::removeUser(QString nick) {
    // Search if the requested user is registered
    QList<QListWidgetItem *> items = ui->userList->findItems(nick, Qt::MatchExactly);

    // Delete the user (only if found)
    if (!items.isEmpty()) {
        delete items.at(0);

        // Notify the user that a peer has left
        ui->chatLog->setTextColor(Qt::gray);
        ui->chatLog->append(tr("* %1 has left").arg(nick));
        ui->chatLog->setTextColor(Qt::black);
    }
}

void Window::newUser(QString nick, QString face) {
    // For this example, we don't use the profile pictures
    face.clear();

    // Add a new user based on the \c nick
    if (!nick.isEmpty()) {
        ui->userList->addItem(nick);
        ui->chatLog->setTextColor(Qt::gray);
        ui->chatLog->append(tr("* %1 has joined").arg(nick));
        ui->chatLog->setTextColor(Qt::black);
    }
}

void Window::downloadComplete(QString peer_address, QString f_name) {
    // Create the notification
    QString message = tr("Download of %1 (by %2) saved in %3").arg
            (f_name, peer_address, qChat->getDownloadPath());

    // Notify the user
    ui->chatLog->setTextColor(Qt::gray);
    ui->chatLog->append(message);
    ui->chatLog->setTextColor(Qt::black);
}

void Window::newDownload(QString peer_address, QString f_name, int f_size) {
    // Create the notification
    QString message = tr("%1 shared %2 (%3 bytes)").arg
            (peer_address, f_name, QString::number(f_size));

    // Notify the user
    ui->chatLog->setTextColor(Qt::gray);
    ui->chatLog->append(message);
    ui->chatLog->setTextColor(Qt::black);
}

void Window::newMessage(QString from, QString face, QString message, QString color, char localUser) {
    // Clear the values that we don't use
    face.clear();
    localUser = 0;

    // Create a single message based on the string and format it in HTML
    QString finalMessage = tr("<font color=%1>%2</font>: %3")
            .arg(color, from, message);

    // Append the message to the UI
    ui->chatLog->append(finalMessage);
}
