#ifndef MESSAGE_H
#define MESSAGE_H

#include <QSound>
#include <QObject>
#include <QString>
#include <QSettings>
#include <QDateTime>

class MessageManager : public QObject {

  Q_OBJECT

public:
  MessageManager();

  static QString formatMessage(const QString msg, const QString nick);
  static QString formatNotification(const QString msg);
  static QString addEmotes(QString msg);
};

#endif
