. envVar.sh


export PATH=${HOME}/fabric-samples/bin:$PATH
export VERBOSE=false
export FABRIC_CFG_PATH=${PWD}/../configtx/

CHANNEL_NAME="xfarm-channel"

CHANNELFILE="../channel-artifacts/${CHANNEL_NAME}.block"


DELAY=2
CLI_DELAY=3
MAX_RETRY=5

if [ ! -d "${PWD}/../channel-artifacts" ]; then
	mkdir ${PWD}/../channel-artifacts
else
	errorln "The channel artifacts is exists"
	exit 0
fi

if [ ! -d "${PWD}/../system-genesis-file" ]; then
	mkdir ${PWD}/../system-genesis-file
else
	errorln "The system-genesis-file is exists."
	exit 0
fi


# =========== Generate orderer system channel genesis block. ===============
function createConsortium() {

  which configtxgen
  if [ "$?" -ne 0 ]; then
    fatalln "configtxgen tool not found."
  fi

  echo "=================================================="
  echo "Generate orderer genesis block."
  echo "=================================================="

  set -x
  configtxgen -profile MultiNodeEtcdRaft -channelID system-channel -outputBlock ${PWD}/../system-genesis-file/genesis.block -configPath ${PWD}/../configtx/
  res=$?
  { set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
    fatalln "Failed to generate orderer genesis block..."
  fi
}

createChannelTx() {
	export FABRIC_CFG_PATH=${PWD}/../configtx/
	set -x
	configtxgen -profile OrgsChannel -outputCreateChannelTx ${PWD}/../channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
    verifyResult $res "Failed to generate channel configuration transaction..."
}


infoln "Generating Consortium "

createConsortium

# Create channeltx
echo "Generating channel create transaction '${CHANNEL_NAME}.tx'"
createChannelTx