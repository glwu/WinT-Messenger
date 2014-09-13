//  This file is part of WinT Messenger
//
//  Copytight (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "image_provider.h"

#include <qdebug.h>
ImageProvider::ImageProvider()
    : QQuickImageProvider (QQuickImageProvider::Image) {}

void ImageProvider::clearImages()
{
    m_id_list.clear();
    m_image_list.clear();
}

void ImageProvider::addImage (const QImage& image, const QString& id)
{
    m_id_list.append (id);
    m_image_list.append (image);
}

QImage ImageProvider::requestImage (const QString& id,
                                    QSize *size,
                                    const QSize& requestedSize)
{
    Q_UNUSED (size);
    Q_UNUSED (requestedSize);

    int index = m_id_list.indexOf (id);
    return index >= 0 ? m_image_list.at (index)
           : QImage (":/faces/generic-user.png");
}
