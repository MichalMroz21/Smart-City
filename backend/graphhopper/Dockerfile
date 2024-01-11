FROM ubuntu
EXPOSE 8989
COPY graphhopper .
RUN apt-get update && apt-get install -y default-jre
CMD ["bash", "/graphhopper.sh"]
#RUN ["java", "-version"]
#RUN ["java", "-D'dw.graphhopper.datareader.file=pomorskie-latest.osm.pbf'",  "-jar" , "graphhopper*.jar", "server", "foo.yml"]

#java -D"dw.graphhopper.datareader.file=pomorskie-latest.osm.pbf" -jar graphhopper*.jar server foo.yml
