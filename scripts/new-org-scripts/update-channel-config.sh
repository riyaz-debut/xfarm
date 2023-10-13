
# imports
. envVar.sh
. utils.sh


CHANNEL_NAME="osqo-channel"

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/osqo.com/orderers/orderer.osqo.com/msp/tlscacerts/tlsca.osqo.com-cert.pem
export CORE_PEER_LOCALMSPID="osqoMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OSQO_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/users/Admin@osqo.osqo.com/msp
export CORE_PEER_ADDRESS=peer0.osqo.osqo.com:7051


set -x
peer channel update -f ../new-org-config/new_org_update_in_envelope.pb -c ${CHANNEL_NAME} -o orderer.osqo.com:7050 --ordererTLSHostnameOverride orderer.osqo.com --tls --cafile ${ORDERER_CA}
{ set +x; } 2>/dev/null
