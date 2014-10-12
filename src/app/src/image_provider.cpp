//  This file is part of WinT Messenger
//
//  Copyright (c) 2013-2014 WinT 3794
//  Copyright (c) 2013-2014 Alex Spataru <alex.racotta@gmail.com>
//
//  Please check the license.txt file for more information.
//

#include "image_provider.h"

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

    // Return the Image at the index of the specified user ID
    int index = m_id_list.indexOf (id);

    // If user cannot be found, return generic user image
    return index >= 0 ? m_image_list.at (index)
           : QImage (":/faces/generic-user.png");
}
