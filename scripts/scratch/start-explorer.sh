
echo "###################################"
echo "Copying connection file to explorer"
echo "###################################"

cp ../organizations/peerOrganizations/org1.xfarm.com/connection-xfarm.json ../explorer/connection-profile/



echo "###################################"
echo "RUNNING EXPLORER COMPOSE FILE"
echo "###################################"
docker-compose -f ../explorer/docker-compose.yaml up -d


