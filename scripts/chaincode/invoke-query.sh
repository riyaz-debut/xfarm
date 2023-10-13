. envVar.sh

if [[ $# -lt 1 ]] ; then
  warnln "PLease add org name parameter"
  exit 0
fi


CHANNEL_NAME="xfarm-channel"
CC_NAME="xfarm-chaincode"
#set org
ORG=$1

chaincodeInvoke() {
#    $2
    echo "============================================="
    echo "INVOKING CHAINCODE"
    echo "============================================="
    ARGS=$1    
    ORG=$2
    PEER=$3
    setOrgPeersGlobals $ORG $PEER

    peer chaincode invoke -o orderer.xfarm.com:7050 --ordererTLSHostnameOverride orderer.xfarm.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses peer0.org1.xfarm.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.xfarm.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c $1 >&../logs/invokeLogs.txt
    res=$?
    { set +x; } 2>/dev/null

    cat ../logs/invokeLogs.txt
}



chaincodeQuery() {
    
    ORG=$2
    PEER=$3
    setOrgPeersGlobals $ORG $PEER

    echo "============================================="
    echo "QUERY CHAINCODE"
    echo "============================================="
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c $1 >&../logs/queryChaincode.txt
    res=$?
    { set +x; } 2>/dev/null
    cat ../logs/queryChaincode.txt
}

chaincodeQuery '{"Args":["GetAllAssets"]}' $ORG 1

sleep 3

# add new entry
chaincodeInvoke '{"Args":["CreateAsset","test_kk","blue","6","methodbridge","900"]}' $ORG 1

sleep 5

# reading asset by id 
chaincodeQuery '{"Args":["ReadAsset","test_kk"]}' $ORG 1

sleep 3

chaincodeQuery '{"Args":["ReadAsset","asset1"]}' $ORG 1

# delete asset
chaincodeInvoke '{"Args":["DeleteAsset","asset1"]}' $ORG 1

sleep 5

# checking whether asset1 deleted 
chaincodeQuery '{"Args":["ReadAsset","asset1"]}' $ORG 1

chaincodeQuery '{"Args":["GetAllAssets"]}' $ORG 1
