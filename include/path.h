#ifndef PATH_H
#define PATH_H

#include <QObject>
#include <QList>
#include "place.h"
class Path : public QObject
{
    Q_OBJECT
    QList<Place*> places;


    void DisplayPathPlaces();

    void GetPath();
    void DrawPathMap();

public:
    void Add(Place *place);
    void CalculatePath();
    explicit Path(QObject *parent = nullptr);

signals:
};

#endif // PATH_H
