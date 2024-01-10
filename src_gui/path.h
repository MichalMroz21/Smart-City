#ifndef PATH_H
#define PATH_H

#include <QObject>

class Path : public QObject
{
    Q_OBJECT
public:
    Add(Place &place);
    explicit Path(QObject *parent = nullptr);

signals:
};

#endif // PATH_H
