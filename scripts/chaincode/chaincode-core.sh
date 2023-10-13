. envVar.sh


export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/orderer.xfarm.com/msp/tlscacerts/tlsca.xfarm.com-cert.pem
export PEER0_ORG1_CA=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/peers/peer0.org1.xfarm.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/../organizations/peerOrganizations/org1.xfarm.com/peers/peer1.org1.xfarm.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/peers/peer0.org2.xfarm.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/../organizations/peerOrganizations/org2.xfarm.com/peers/peer1.org2.xfarm.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../configtx/

CHANNEL_NAME="xfarm-channel"

CC_NAME=$1 #"xfarm-chaincode"
CC_SRC_PATH=$2 #"${PWD}/../chaincode-typescript"
CC_SRC_LANGUAGE=typescript
CC_VERSION=$3 #"2.0"
CC_SEQUENCE=$4
CC_INIT_FCN="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"

DELAY="3"
MAX_RETRY="5"
VERBOSE="false"



  
  CC_SRC_LANGUAGE=$(echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:])

  CC_RUNTIME_LANGUAGE=node

  infoln "Compiling TypeScript code into JavaScript..."
  pushd $CC_SRC_PATH
  npm install
  npm run build
  popd
  successln "Finished compiling TypeScript code into JavaScript"

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


packageChaincode() {
  echo "============================================================================================"
  infoln "PACKAGE CHAINCODE WITH NAME ${CC_NAME} Verison ${CC_VERSION} and Sequence ${CC_SEQUENCE} "
  echo "============================================================================================"
    rm -rf ../${CC_NAME}.tar.gz    
    # ORG=$1
	  # setPeersGlobals $ORG
    echo "dced" $CC_NAME $CC_SRC_PATH $CC_RUNTIME_LANGUAGE $CC_VERSION
    peer lifecycle chaincode package ../${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&../logs/logsPackage.txt   
    res=$?
    { set +x; } 2>/dev/null
    echo "'package chaincode"
    cat ../logs/logsPackage.txt
    
}

installChaincode() {
   
    ORG=$1
    PEER=$2
    setOrgPeersGlobals $ORG $PEER
    echo "===================== INSTALLING CHAINCODE on $ORG and $PEER } ===================== "
    set -x
    peer lifecycle chaincode install ../${CC_NAME}.tar.gz>&../logs/installLogs.txt
    res=$?
    { set +x; } 2>/dev/null   
}

queryInstalled() {
    ORG=$1
    PEER=$2
	  setOrgPeersGlobals $ORG $PEER

    set -x
    peer lifecycle chaincode queryinstalled >&../logs/queryInstalledChaincodelogs.txt
    { set +x; } 2>/dev/null
    cat ../logs/queryInstalledChaincodelogs.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" ../logs/queryInstalledChaincodelogs.txt)
    echo PackageID is ${PACKAGE_ID}    
}


approveForMyOrg() {
  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" ../logs/queryInstalledChaincodelogs.txt
    { set +x; } 2>/dev/null)
  echo "Package id ", $PACKAGE_ID
  ORG=$1
  setOrgPeersGlobals $ORG 1
 
  set -x
  peer lifecycle chaincode approveformyorg -o orderer.xfarm.com:7050 --ordererTLSHostnameOverride orderer.xfarm.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} >&../logs/approveLogs.txt
  res=$?    
  { set +x; } 2>/dev/null
}
