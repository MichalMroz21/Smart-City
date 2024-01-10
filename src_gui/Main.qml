import QtQuick

import QtPositioning
import QtLocation

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Rectangle{

        anchors.fill: parent

        Plugin{
            id: mapPlugin
            name: "osm"

            PluginParameter{
                name: "osm.mapping.providersrepository.disabled"
                value: "true"
            }

            PluginParameter{
                name: "osm.mapping.providersrepository.address"
                value: "http://maps-redirect.qt.io/osm/5.6/"
            }
        }

        Map{
            id: mapView
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(25.6565, 125.6849);
            zoomLevel: 15
        }
    }
}
