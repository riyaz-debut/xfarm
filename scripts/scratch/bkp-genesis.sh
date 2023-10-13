export PATH=${PWD}/../../fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../configtx
export VERBOSE=false


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
  configtxgen -profile MultiNodeEtcdRaft -channelID system-channel -outputBlock ../system-genesis-file/genesis.block -configPath ../configtx/
  res=$?
  { set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
    fatalln "Failed to generate orderer genesis block..."
  fi
}

createConsortium