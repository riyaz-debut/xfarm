. envVar.sh

# export FABRIC_CFG_PATH=${PWD}/../configtx/
# export CORE_PEER_TLS_ENABLED=true
# export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/osqo.com/orderers/orderer.osqo.com/msp/tlscacerts/tlsca.osqo.com-cert.pem
# export PEER0_OSQO_CA=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/peers/peer0.osqo.osqo.com/tls/ca.crt
# export PEER1_OSQO_CA=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/peers/peer1.osqo.osqo.com/tls/ca.crt
# export PEER0_BCP_CA=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/peers/peer0.bcp.osqo.com/tls/ca.crt
# export PEER1_BCP_CA=${PWD}/../organizations/peerOrganizations/bcp.osqo.com/peers/peer1.bcp.osqo.com/tls/ca.crt
# export PEER0_ESP_CA=${PWD}/../organizations/peerOrganizations/esp.osqo.com/peers/peer0.esp.osqo.com/tls/ca.crt
# export PEER1_ESP_CA=${PWD}/../organizations/peerOrganizations/esp.osqo.com/peers/peer1.esp.osqo.com/tls/ca.crt
# export PEER0_BROKER_CA=${PWD}/../organizations/peerOrganizations/broker.osqo.com/peers/peer0.broker.osqo.com/tls/ca.crt
# export PEER1_BROKER_CA=${PWD}/../organizations/peerOrganizations/broker.osqo.com/peers/peer1.broker.osqo.com/tls/ca.crt


if [[ $# -lt 4 ]] ; then
  warnln "Invalid arguments supplied"
  infoln "Valid call example: ./commit-chaincode.sh --org osqo --ccn basic --ver 1.0 --seq 1"
  exit 0
fi


ORG=$1
CHANNEL_NAME="xfarm-channel"
CC_NAME=$2
CC_VERSION=$3
CC_SEQUENCE=$4
CC_INIT_FCN="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"
DELAY="3"
MAX_RETRY="5"
VERBOSE="false"

INIT_REQUIRED="--init-required"  
if [ "$CC_INIT_FCN" = "NA" ]; then
  INIT_REQUIRED=""
fi

if [ "$CC_END_POLICY" = "NA" ]; then
  CC_END_POLICY=""
else
  CC_END_POLICY="--signature-policy $CC_END_POLICY"
fi

if [ "$CC_COLL_CONFIG" = "NA" ]; then
  CC_COLL_CONFIG=""
else
  CC_COLL_CONFIG="--collections-config $CC_COLL_CONFIG"
fi

checkCommitReadiness() {
   
    ORG=$1
    PEER=$2
	  setOrgPeersGlobals $ORG $PEER
    echo "============================================="
    echo "CHECKING CHAINCODE COMMIT READINESS Using Org ${ORG}"
    echo "============================================="
    set -x
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --output json >&../logs/commitReadinesslogs.txt
    { set +x; } 2>/dev/null
    cat ../logs/commitReadinesslogs.txt
}

commitChaincode() {
    set -x
    # check for osqo
    ORG=$1
    PEER=$2
	  setOrgPeersGlobals $ORG $PEER

    peer lifecycle chaincode commit -o orderer.xfarm.com:7050 --ordererTLSHostnameOverride orderer.xfarm.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses peer0.org1.xfarm.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.xfarm.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} >&../logs/commitLogs.txt
    res=$?
    { set +x; } 2>/dev/null
    cat ../logs/commitLogs.txt
}




queryCommitted() {
    ORG=$1
    PEER=$2
	  setOrgPeersGlobals $ORG $PEER

    echo "============================================="
    echo "COMMIT CHAINCODE Org ${ORG}"
    echo "============================================="
    set -x
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME} >&../logs/queryCommitedlogs.txt
    res=$?
    { set +x; } 2>/dev/null
    cat ../logs/queryCommitedlogs.txt

}

echo "============================================="
echo "checkCommitReadiness CHAINCODE for $CC_NAME"
echo "============================================="


checkCommitReadiness $ORG 2

sleep 2

echo "============================================="
echo "Commit CHAINCODE $CC_NAME"
echo "============================================="


commitChaincode $ORG 2

sleep 2

echo "============================================="
echo "Query Committed CHAINCODE $CC_NAME"
echo "============================================="



queryCommitted $ORG 2
