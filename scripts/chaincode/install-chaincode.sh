
if [[ $# -lt 4 ]] ; then
  warnln "Invalid arguments supplied"
  infoln "Valid call example: ./install-chaincode.sh -org xfarm -ccn basic -ccp ../chaincode-typescript --ver 1.0 --seq 1"
  exit 0
fi

. ${PWD}/chaincode/chaincode-core.sh $2 $3 $4 $5

ORG=$1
packageChaincode

# sleep 2

echo "============================================="
echo "Installing on for peer0 of ${ORG}"
echo "============================================="

installChaincode $ORG 1

# sleep 2

echo "============================================="
echo "Installing on for peer1 of ${ORG}"
echo "============================================="


installChaincode $ORG 2

sleep 1

echo "============================================="
echo "Query Installed chaincode on ${ORG} peers"
echo "============================================="


queryInstalled $ORG 1

queryInstalled $ORG 2

# sleep 2

echo "============================================="
echo "Approve chaincode definition for org ${ORG}"
echo "============================================="

approveForMyOrg $ORG


