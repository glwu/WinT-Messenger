//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex_spataru@outlook.com>
//
//  Please check the license.txt file for more information.
//

#ifndef IMAGE_PROVIDER_H
#define IMAGE_PROVIDER_H

#include <QImage>
#include <QtQuick/QQuickImageProvider>

class ImageProvider : public QQuickImageProvider
{

    public:
        explicit ImageProvider();
        void clearImages();

        void addImage (const QImage& image, const QString& id);
        QImage requestImage (const QString& id, QSize *size,
                             const QSize& requestedSize);

    private:

        QList<QString> m_id_list;
        QList<QImage> m_image_list;
};

#endif
