. envVar.sh

export PATH=${PWD}/../fabric-samples/bin:$PATH
export VERBOSE=false
export FABRIC_CFG_PATH=${PWD}/../configtx/

CHANNEL_NAME="osqo-channel"

export VERBOSE=false

export FABRIC_CFG_PATH=${PWD}/../configtx/

export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/osqo.com/orderers/orderer.osqo.com/msp/tlscacerts/tlsca.osqo.com-cert.pem

signConfigtxAsPeerOrg() {  
  ORG=$1
  PEER=$2
  setOrgPeersGlobals $ORG $PEER
  CONFIGTXFILE=$3  
 
  echo "checking ${CORE_PEER_LOCALMSPID}" 
  peer channel list
  set -x
  peer channel signconfigtx -f "${CONFIGTXFILE}"
  { set +x; } 2>/dev/null
}

