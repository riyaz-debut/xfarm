#!/bin/bash

# script_dir="$(dirname "$0")"


# . "$script_dir/../utils/utils.sh"
# . "$script_dir/../envVar.sh"

# . utils.sh
# . envVar.sh
. envVar.sh


export PATH=${PWD}/../fabric-samples/bin:$PATH
export VERBOSE=false
export FABRIC_CFG_PATH=${PWD}/../configtx/

CHANNEL_NAME="xfarm-channel"
CHANNELFILE="${PWD}/../channel-artifacts/${CHANNEL_NAME}.block"
echo $CHANNELFILE;

DELAY=2
CLI_DELAY=3


export VERBOSE=false
MAX_RETRY=5


export FABRIC_CFG_PATH=${PWD}/../configtx/

export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/orderer.xfarm.com/msp/tlscacerts/tlsca.xfarm.com-cert.pem


#join channel
joinChannel(){
	
	echo "============================================="
	echo "joining channel for peer${2} of ${1}"
	echo "============================================="

	ORG=$1
	PEER=$2
	setOrgPeersGlobals $ORG $PEER
	local rc=1
	local COUNTER=1

	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
	sleep $DELAY
	set -x
	peer channel join -b $CHANNELFILE >&../logs/joinChannel.txt
	res=$?
	{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat ../logs/joinChannel.txt
	verifyResult $res "After $MAX_RETRY attempts, peer has failed to join channel '$CHANNEL_NAME' "
}


setAnchorPeer(){
	export FABRIC_CFG_PATH=${PWD}/../configtx/
	echo "==========================="
	echo "SET ANCHOR PEER FOR "$1
	echo "==========================="
	
	configtxgen -profile OrgsChannel -outputAnchorPeersUpdate ../channel-artifacts/$1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg $1MSP    
    output=$?
    if [ $output -ne 0 ]; then
        echo "********************anchor peer" $1 "not generated**************"
    else
        echo "********************anchor peer for" $1 "generated*******************" 
    fi    

 }


updateAnchorPeers(){
	export FABRIC_CFG_PATH=${PWD}/../configtx/
	echo "==========================="
	echo "UPDATING ANCHOR PEER FOR "$2
	echo "==========================="
	ORG=$1
	PEER=$2
	setOrgPeersGlobals $ORG $PEER
	set -x
	peer channel update -o  orderer.xfarm.com:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.xfarm.com -f ../channel-artifacts/$1MSPanchors.tx --tls --cafile $ORDERER_CA
	res=$?
  	{ set +x; } 2>/dev/null
	echo "==========================="
	echo "ANCHOR PEER for" $1 "UPDATE"
	echo "===========================" 
}
