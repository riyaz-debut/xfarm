

. envVar.sh
# . utils.sh

if [[ $# -lt 1 ]] ; then
  warnln "Please add new org msp name for eg. oregonMSP "
  exit 0
fi


NEW_ORG_MSP=$1;
CHANNEL_NAME="osqo-channel"

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/osqo.com/orderers/orderer.osqo.com/msp/tlscacerts/tlsca.osqo.com-cert.pem

#Peer msp
export CORE_PEER_LOCALMSPID="osqoMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_OSQO_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/osqo.osqo.com/users/Admin@osqo.osqo.com/msp
export CORE_PEER_ADDRESS=peer0.osqo.osqo.com:7051


fetchChannelConfig() {
  ORG=$1
  CHANNEL=$2
  OUTPUT=$3

  # setGlobals $ORG

  infoln "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config ../new-org-config/config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.osqo.com -c "$CHANNEL" --tls --cafile "$ORDERER_CA"
  { set +x; } 2>/dev/null

  infoln "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input ../new-org-config/config_block.pb --type common.Block --output ../new-org-config/config_block.json
  jq .data.data[0].payload.data.config ../new-org-config/config_block.json >"${OUTPUT}"
  { set +x; } 2>/dev/null
}

createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config --output ../new-org-config/original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config --output ../new-org-config/modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original ../new-org-config/original_config.pb --updated ../new-org-config/modified_config.pb --output ../new-org-config/config_update.pb
  configtxlator proto_decode --input ../new-org-config/config_update.pb --type common.ConfigUpdate --output ../new-org-config/config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat ../new-org-config/config_update.json)'}}}' | jq . > ../new-org-config/config_update_in_envelope.json
  configtxlator proto_encode --input ../new-org-config/config_update_in_envelope.json --type common.Envelope --output "${OUTPUT}"
  { set +x; } 2>/dev/null
}


# Fetch the config for the channel, writing it to config.json
fetchChannelConfig 1 "${CHANNEL_NAME}" ../new-org-config/config.json

# Modify the configuration to append the new org
set -x
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"'${NEW_ORG_MSP}'":.[1]}}}}}' ../new-org-config/config.json ../new-org-config/orgconfig.json > ../new-org-config/modified_config.json
{ set +x; } 2>/dev/null

# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to org3_update_in_envelope.pb
createConfigUpdate "${CHANNEL_NAME}" ../new-org-config/config.json ../new-org-config/modified_config.json ../new-org-config/new_org_update_in_envelope.pb

infoln "Envelope is created successfully. Please share the  new_org_update_in_envelope.pb file with other orgs to sign"


echo "Share the config.json file to the new org"

