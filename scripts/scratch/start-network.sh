./scratch/generate-msp.sh re-generate

./scratch/ccp-generate.sh

./scratch/genesis.sh


echo "================================= UP PEERS FILE =================================="

./start-org.sh orderer

./start-org.sh org1

./start-org.sh org2

echo "================================= CREATE CHANNEL =================================="

./scratch/create-channel.sh

echo "================================= JOIN PEERS TO CHANNEL =================================="


./scratch/join-channel-org.sh org1

./scratch/join-channel-org.sh org2

echo "================================= INSTALL CHAINCODE =================================="

./chaincode/install-chaincode.sh org1 xfarm-chaincode ../xfarm-cc 1.0 1

./chaincode/install-chaincode.sh org2 xfarm-chaincode ../xfarm-chaincode 1.0 1

echo "================================= COMMIT CHAINCODE =================================="

./chaincode/commit-chaincode.sh org1 xfarm-chaincode 1.0 1


echo "=========================== Create ccp connection files ================================="



# echo "================================= INVOKE QUERY CHAINCODE =================================="

# ./chaincode/invoke-query.sh osqo 
