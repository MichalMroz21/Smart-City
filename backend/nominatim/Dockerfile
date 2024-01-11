FROM mediagis/nominatim:4.3
EXPOSE 8080
COPY data /nominatim/data
ENV PBF_PATH=/nominatim/data/pomorskie-latest.osm.pbf
ENV IMPORT_WIKIPEDIA=/nominatim/data/wikimedia-importance.sql.gz
