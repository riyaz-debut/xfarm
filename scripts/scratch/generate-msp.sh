#!/bin/bash

. envVar.sh

if [[ $# -lt 1 ]] ; then
  warnln "Invalid Command"
  exit 0
fi


if [[ $1 != "re-generate" ]] ; then
  warnln "Invalid Command"
  exit 0
fi


ORG1="org1"
ORG2="org2"
ORDERER="orderer"


# certificate authorities compose file for org1
COMPOSE_FILE_CA_ORG1=../docker-compose-ca/org1/compose/docker-compose-org1-ca.yaml

# certificate authorities compose file for org2
COMPOSE_FILE_CA_ORG2=../docker-compose-ca/org2/compose/docker-compose-org2-ca.yaml

# certificate authorities compose file for orderer
COMPOSE_FILE_CA_ORDERER=../docker-compose-ca/orderer/compose/docker-compose-orderer-ca.yaml

function orgCaUp(){
  docker-compose -f $1 up -d 2>&1
}

orgCaUp $COMPOSE_FILE_CA_ORG1
orgCaUp $COMPOSE_FILE_CA_ORG2
orgCaUp $COMPOSE_FILE_CA_ORDERER

export PATH=${HOME}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/../configtx
export VERBOSE=false


# ================================ ORGANIZATIONS ==============================================


# ================================ ENROLLING CA ADMIN FOR ORGS =================================
function enrollOrgCaAdmin(){
    echo "=================================================="
    echo "ENROLL CA for "$1
    echo "=================================================="

    # rm -rf ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/
    mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$1.xfarm.com/


    set -x
    fabric-ca-client enroll -u https://admin:adminpw@localhost:$2 --caname ca-$1 --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
    { set +x; } 2>/dev/null

}

enrollOrgCaAdmin $ORG1 7054 
enrollOrgCaAdmin $ORG2 8054

# Writing config.yaml file for Orgs
echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/org1.xfarm.com/msp/config.yaml

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/org2.xfarm.com/msp/config.yaml

    
# ================================ REGISTER PEERS FOR ORGS =========================================

function RegisterPeers(){
  echo "=================================================="
  echo "Register peer0 for "$1
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$1.xfarm.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  echo "=================================================="
  echo "Register peer1 for "$1
  echo "=================================================="
  set -x
  fabric-ca-client register --caname ca-$1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null


}

RegisterPeers $ORG1
RegisterPeers $ORG2

# ================================= REGISTER USERS FOR ORGS ==========================================

function RegisterUser(){
  echo "=================================================="
  echo "Register user for "$1
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$1.xfarm.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

}

RegisterUser $ORG1
RegisterUser $ORG2

# ================================ REGISTER ADMIN FOR ORGS =============================================

function RegisterOrgAdmin(){
  echo "=================================================="
  echo "Register Admin for "$1
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$1.xfarm.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name $1admin --id.secret $1adminpw --id.type admin --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

}

RegisterOrgAdmin $ORG1
RegisterOrgAdmin $ORG2

# ================================ GENERATE MSP PEERS FOR ORGS =======================================

function GenerateMsp(){
  echo "=================================================="
  echo "Generate MSP for peer0 "$1
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/$1.xfarm.com/

  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/msp --csr.hosts peer0.$1.xfarm.com --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/
  

  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/msp/config.yaml

  echo "=================================================="
  echo "Generate MSP for peer1 "$1
  echo "=================================================="

  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/msp --csr.hosts peer1.$1.xfarm.com --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/msp/config.yaml


  echo "=================================================="
  echo "Generate MSP for USER "$1
  echo "=================================================="

  # //adding tls-cert into users folder
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/User1@$1.xfarm.com/msp --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  # copying config.yaml into users msp folder
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/User1@$1.xfarm.com/msp/config.yaml


  echo "=================================================="
  echo "Generate MSP for ORG ADMIN "$1
  echo "=================================================="

  # adding tls-cert into admin folder
  set -x
  fabric-ca-client enroll -u https://$1admin:$1adminpw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/Admin@$1.xfarm.com/msp --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null


  DIR="../../organizations/keystore-file/"
  if [ ! -d "$DIR" ]; then
    # Take action if $DIR not exists. #
    mkdir -p ../organizations/keystore-file
    println "storing keystore file"
    cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/Admin@$1.xfarm.com/msp/keystore/* ${PWD}/../organizations/keystore-file/$1-key   
  else
    cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/Admin@$1.xfarm.com/msp/keystore/* ${PWD}/../organizations/keystore-file/$1-key
    println "keystore file already saved"
  fi

  # copying config.yaml into admin msp folder
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/users/Admin@$1.xfarm.com/msp/config.yaml


}

GenerateMsp $ORG1 7054
GenerateMsp $ORG2 8054

# =============================== REGISTER TLS FOR PEERS =========================================

function GeneratePeerTLS(){
  echo "=================================================="
  echo "Generate TLS for peer0 "$1
  echo "=================================================="
  
  # creating tls
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls --enrollment.profile tls --csr.hosts peer0.$1.xfarm.com --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/server.key


  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/tlsca/tlsca.$1.xfarm.com-cert.pem

  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/ca
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer0.$1.xfarm.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/ca/ca.$1.xfarm.com-cert.pem

  echo "=================================================="
  echo "Generate TLS for peer1 "$1
  echo "=================================================="

  # creating tls
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls --enrollment.profile tls --csr.hosts peer1.$1.xfarm.com --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/server.key



  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/tlsca/tlsca.$1.xfarm.com-cert.pem

  mkdir -p ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/ca
  cp ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/peers/peer1.$1.xfarm.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/$1.xfarm.com/ca/ca.$1.xfarm.com-cert.pem
}

GeneratePeerTLS $ORG1 7054
GeneratePeerTLS $ORG2 8054

# =========================================== ORDERER ======================================

# =============================== ENROLLING CA ADMIN FOR ORDERER ===============================
function enrollOrdererCaAdmin(){
    echo "=================================================="
    echo "ENROLL CA for "$1
    echo "=================================================="

    mkdir -p ${PWD}/../organizations/ordererOrganizations/xfarm.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/xfarm.com/

    set -x
    fabric-ca-client enroll -u https://admin:adminpw@localhost:$2 --caname ca-$1 --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
    { set +x; } 2>/dev/null

}

# enrolling orderer CA Admin
enrollOrdererCaAdmin $ORDERER 9054

# Writing config.yaml file for orderer
    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/ordererOrganizations/xfarm.com/msp/config.yaml


# =============================== REGISTER ORDERER ===============================

function RegisterOrderer(){
  echo "=================================================="
  echo "Register orderer "
  echo "=================================================="

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/xfarm.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null
}

RegisterOrderer $ORDERER

# =============================== REGISTER ORDERER ADMIN ===============================

function RegisterOrdererAdmin(){
  echo "=================================================="
  echo "Register orderer admin"
  echo "=================================================="

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/xfarm.com/

  set -x
  fabric-ca-client register --caname ca-$1 --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null
}

RegisterOrdererAdmin $ORDERER


# =============================== REGISTER ORDERER MSP ===============================

function GenerateOrdererMSP(){
  echo "=================================================="
  echo "Generating orderer MSP for" $2
  echo "=================================================="

  echo "ca orderer"
  echo $1

   echo "ca node"
  echo $2

   echo "port"
  echo $3

 export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/xfarm.com/

  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:$3 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/msp --csr.hosts $2.xfarm.com --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/msp/config.yaml

 } 

GenerateOrdererMSP $ORDERER orderer 9054
GenerateOrdererMSP $ORDERER orderer2 9054
GenerateOrdererMSP $ORDERER orderer3 9054
GenerateOrdererMSP $ORDERER orderer4 9054
GenerateOrdererMSP $ORDERER orderer5 9054
 

function GenerateOrdererAdminMSP(){
  echo "=================================================="
  echo "Generating orderer Admin MSP"
  echo "=================================================="

  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:$2 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/xfarm.com/users/Admin@xfarm.com/msp --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/xfarm.com/users/Admin@xfarm.com/msp/config.yaml
}

GenerateOrdererAdminMSP $ORDERER 9054

# =============================== GENERATE ORDERER TLS ===============================

function GenerateOrdererTLS(){
  echo "=================================================="
  echo "Generate orderer TLS for "$2
  echo "=================================================="

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/xfarm.com/

  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:$3 --caname ca-$1 -M ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls --enrollment.profile tls --csr.hosts $2.xfarm.com --csr.hosts localhost --tls.certfiles ${PWD}/../docker-compose-ca/$1/fabric-ca/tls-cert.pem
  { set +x; } 2>/dev/null


  
  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/ca.crt
  
  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/server.crt

  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/server.key

  mkdir -p ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/msp/tlscacerts/tlsca.xfarm.com-cert.pem

  mkdir -p ${PWD}/../organizations/ordererOrganizations/xfarm.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/xfarm.com/orderers/$2.xfarm.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/xfarm.com/msp/tlscacerts/tlsca.xfarm.com-cert.pem

}

GenerateOrdererTLS $ORDERER orderer 9054
GenerateOrdererTLS $ORDERER orderer2 9054
GenerateOrdererTLS $ORDERER orderer3 9054
GenerateOrdererTLS $ORDERER orderer4 9054
GenerateOrdererTLS $ORDERER orderer5 9054


# . ccp-generate.sh