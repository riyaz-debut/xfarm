./scratch/generate-msp.sh re-generate

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





