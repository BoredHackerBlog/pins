# run this initially. no need to run it after that
# setup nodered
docker-compose up -d nodered
sleep 15
docker exec -w /data -it nodered npm install node-red-node-tail
docker-compose stop nodered

# setup suricata
docker-compose up -d suricata
sleep 15
docker exec -it --user suricata suricata suricata-update update-sources
docker exec -it --user suricata suricata suricata-update enable-source oisf/trafficid
docker exec -it --user suricata suricata suricata-update disable-source et/open
docker exec -it --user suricata suricata suricata-update --no-test
docker-compose stop suricata

# bring up all the containers
docker-compose up -d
