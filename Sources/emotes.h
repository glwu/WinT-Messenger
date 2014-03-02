#ifndef EMOTES_H
#define EMOTES_H

#include <QObject>
#include <QSettings>

class Emotes : public QObject {

    Q_OBJECT

public:
    Emotes();
    QString addEmotes(QString msg);
};

#endif
