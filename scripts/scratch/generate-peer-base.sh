#!/bin/bash


. utils.sh

if [[ $# -lt 1 ]] ; then
  warnln "Please provide machine name"
  exit 0
fi


. set-peer-base.sh $1


echo "**********************************************************"
echo "        GENERATING PEER BASE FOR ${MACHINE}"
echo "**********************************************************"


echo "
version: '2'

services:
  peer:    
    environment:
      - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
      # the following setting starts chaincode containers on the same
      # bridge network as the peers
      # https://docs.docker.com/compose/networking/      
      - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=xfarm-network
      - CORE_LOGGING_LEVEL=INFO
      - FABRIC_LOGGING_SPEC=INFO
      #- CORE_LOGGING_LEVEL=DEBUG
      - CORE_PEER_TLS_ENABLED=true
      - CORE_PEER_GOSSIP_USELEADERELECTION=true
      - CORE_PEER_GOSSIP_ORGLEADER=false
      - CORE_PEER_PROFILE_ENABLED=true
    # working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer
    # command: peer node start
    extra_hosts:        
      ${EXTRA_HOSTS}
" > ../docker-compose-network/peer-base.yaml




