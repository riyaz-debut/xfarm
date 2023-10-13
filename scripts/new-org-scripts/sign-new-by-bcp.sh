
# imports
. envVar.sh
. utils.sh


CHANNEL_NAME="osqo-channel"

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/osqo.com/orderers/orderer.osqo.com/msp/tlscacerts/tlsca.osqo.com-cert.pem


# Set the peerOrg admin of an org and sign the config update
signConfigtxAsPeerOrg() {  
  CONFIGTXFILE=$1  
  export CORE_PEER_LOCALMSPID="bcpMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BCP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/users/Admin@bcp.osqo.com/msp
    export CORE_PEER_ADDRESS=peer0.bcp.osqo.com:9051
  
  echo "checking ${CORE_PEER_LOCALMSPID}" 
  peer channel list
  set -x
  peer channel signconfigtx -f "${CONFIGTXFILE}"
  { set +x; } 2>/dev/null
}


# infoln "Signing config transaction"

# infoln "Signing config transaction from org 1 i.e. osqo"
# signConfigtxAsPeerOrg ./new_org_update_in_envelope.pb
