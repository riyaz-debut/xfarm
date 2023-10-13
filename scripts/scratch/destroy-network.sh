
docker rm -f $(docker ps -aq)
docker volume prune
docker network prune


sudo rm -rf ../docker-compose-ca/xfarm/fabric-ca/fabric-ca-server.db ../docker-compose-ca/bcp/fabric-ca/fabric-ca-server.db ../docker-compose-ca/orderer/fabric-ca/fabric-ca-server.db ../docker-compose-ca/esp/fabric-ca/fabric-ca-server.db ../docker-compose-ca/broker/fabric-ca/fabric-ca-server.db 



sudo rm -rf ../channel-artifacts
sudo rm -rf ../organizations
sudo rm -rf ../system-genesis-file
sudo rm -rf ../data
sudo rm -rf ../../network-data

sudo rm -rf ../system-genesis-file/genesis.block
