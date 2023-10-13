. ${PWD}/scratch/channel-core.sh


# Join all the peers to the channel


if [[ $# -lt 1 ]] ; then
  warnln "Please add org name parameter"
  exit 0
fi

ORG_NAME=$1 

joinChannel $ORG_NAME 1

sleep 1

joinChannel $ORG_NAME 2

sleep 1

#Creting anchor peer txn
setAnchorPeer $ORG_NAME

#Updating anchor peer
updateAnchorPeers $ORG_NAME 1
