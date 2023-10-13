#!/bin/bash

# my_dir="$(dirname "$0")"
# echo "$PWD/utils.sh"
# . "$my_dir/utils.sh"

. utils.sh
# imports
# . utils.sh

script_dir="$(dirname "$0")"
# . "$script_dir/../utils/utils.sh"
# echo "oieoiwuoriuwr3294872839492834792387"
echo "$script_dir/utils.sh"



export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/orderer.xfarm.com/msp/tlscacerts/tlsca.xfarm.com-cert.pem
export PEER0_ORG1_CA=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/peers/peer0.org1.xfarm.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/peers/peer1.org1.xfarm.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/peers/peer0.org2.xfarm.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/peers/peer1.org2.xfarm.com/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
   PEER0NAME=peer0.org1.xfarm.com
   ORGNAME=ORG1
    export CORE_PEER_LOCALMSPID="org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/users/Admin@org1.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org1.xfarm.com:7051  
  elif [ $USING_ORG -eq 4 ]; then
   PEER0NAME=peer0.org2.xfarm.com
   ORGNAME=ORG2
    export CORE_PEER_LOCALMSPID="org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/users/Admin@org2.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org2.xfarm.com:9051  
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}


setPeersGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 11 ]; then
    PEER_NAME=peer0.org1.xfarm.com
    export CORE_PEER_LOCALMSPID="org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/users/Admin@org1.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org1.xfarm.com:7051
  elif [ $USING_ORG -eq 32 ]; then
  PEER_NAME=peer1.org1.xfarm.com
    export CORE_PEER_LOCALMSPID="org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/users/Admin@org1.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer1.org1.xfarm.com:8051
  elif [ $USING_ORG -eq 41 ]; then
  PEER_NAME=peer0.org2.xfarm.com
    export CORE_PEER_LOCALMSPID="org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/users/Admin@org2.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org2.xfarm.com:9051
  elif [ $USING_ORG -eq 42 ]; then
    PEER_NAME=peer1.org2.xfarm.com
    export CORE_PEER_LOCALMSPID="org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/users/Admin@org2.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer1.org2.xfarm.com:10051  
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

setOrgPeersGlobals() {
  local USING_ORG=""
  USING_ORG=$1
  USING_PEER=$2
  infoln "Using organization ${USING_ORG} and Peer ${USING_PEER}"
 
  # export CORE_PEER_TLS_ENABLED=true
  if [ $USING_ORG == "org1" ] && [ $USING_PEER == 1 ]; then 
    PEER_NAME=peer0.org1.xfarm.com
    export CORE_PEER_LOCALMSPID="org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/users/Admin@org1.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org1.xfarm.com:7051
  elif [ $USING_ORG == "org1" ] && [ $USING_PEER == 2 ]; then
  PEER_NAME=peer1.org1.xfarm.com
    export CORE_PEER_LOCALMSPID="org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/users/Admin@org1.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer1.org1.xfarm.com:8051
  elif [ $USING_ORG == "org2" ] && [ $USING_PEER == 1 ]; then
  PEER_NAME=peer0.org2.xfarm.com
    export CORE_PEER_LOCALMSPID="org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/users/Admin@org2.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer0.org2.xfarm.com:9051
  elif [ $USING_ORG == "org2" ] && [ $USING_PEER == 2 ]; then
    PEER_NAME=peer1.org2.xfarm.com
    export CORE_PEER_LOCALMSPID="org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/users/Admin@org2.xfarm.com/msp
    export CORE_PEER_ADDRESS=peer1.org2.xfarm.com:10051  
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.org1.xfarm.com:7051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer.org2.xfarm.com:9051  
  else
    errorln "ORG Unknown"
  fi
}

# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do

    setGlobals $1
    PEER=$P                                                                                                                                                         

    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$CORE_PEER_TLS_ROOTCERT_FILE")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    shift 
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[:space:]*//')"

}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
