#include "path.h"


Path::Path(QObject *parent)
    : QObject{parent}
{


}


Path::Add(Place *place)
{
    places.append(place);
}
