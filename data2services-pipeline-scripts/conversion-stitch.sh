                                                     
# stitch file in /data/data2services

docker run -it --rm -v /data/emonet/ncats/stitch:/data vemonet/data2services-download --download-datasets stitch

docker run -dit --rm -p 8047:8047 -p 31010:31010 --name drill -v /data:/data:ro apache-drill

docker run -it --rm --link drill:drill -v /data:/data autor2rml \
        -j "jdbc:drill:drillbit=drill:31010" -r \
        -o "/data/emonet/ncats/stitch/mapping.trig" \
        -d "/data/emonet/ncats/stitch" \
        -b "https://w3id.org/data2services/" \
        -g "https://w3id.org/data2services/graph/autor2rml/stitch"

docker run -it --rm --link drill:drill \
  -v /data/data2services:/data \
  r2rml /data/config.properties

# Load RDF file in GraphDB ncats-test repository

# Run SPARQL conversion scripts
#docker run -d --name convert_stitch --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/stitch" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var serviceUrl:http://localhost:7200/repositories/ncats-test inputGraph:https://w3id.org/data2services/graph/autor2rml/stitch outputGraph:https://w3id.org/data2services/graph/biolink/stitch
docker run -d --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/insert-biolink/stitch" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var serviceUrl:http://localhost:7200/repositories/test inputGraph:http://data2services/graph/autor2rml/stitch outputGraph:https://w3id.org/data2services/graph/biolink/stitch
# 1h:45m:43s

# compute-hcls-stats
docker run -d --link graphdb:graphdb vemonet/data2services-sparql-operations -f "https://github.com/MaastrichtU-IDS/d2s-transform-repository/tree/master/sparql/compute-hcls-stats" -ep "http://graphdb:7200/repositories/ncats-red-kg/statements" -un emonet -pw $PASSWORD -var inputGraph:https://w3id.org/data2services/graph/biolink/stitch
# 3m:49s