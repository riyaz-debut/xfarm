. utils.sh

# Join all the peers to the channel
if [[ $# -lt 1 ]] ; then
  warnln "Please add org name parameter."
  infoln "For eg ./start-org.sh xfarm"
  exit 0
fi

DOCKER_CA_F="${PWD}/../docker-compose-ca/${1}/compose/docker-compose-${1}-ca.yaml"
DOCKER_ORG_F="${PWD}/../docker-compose-network/docker-compose-${1}.yaml"

docker-compose -f ${DOCKER_CA_F} up -d 2>&1

sleep 1 

docker-compose -f ${DOCKER_ORG_F} up -d 2>&1
