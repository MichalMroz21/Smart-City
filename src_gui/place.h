#ifndef PLACE_H
#define PLACE_H

#include <QObject>

class Place : public QObject
{
    Q_OBJECT
public:
    explicit Place(QObject *parent = nullptr);

signals:
};

#endif // PLACE_H
