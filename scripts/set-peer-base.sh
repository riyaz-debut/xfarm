#!/bin/bash


. utils.sh

echo "inside set peer base file"

if [[ $# -lt 1 ]] ; then
  warnln "Please provide machine name"
  exit 0
fi

PEER0_ORG1=peer0.org1.xfarm.com
PEER1_ORG1=peer1.org1.xfarm.com

PEER0_ORG1_IP=127.0.0.1
PEER1_ORG1_IP=127.0.0.1


PEER0_ORG2=peer0.org2.xfarm.com
PEER1_ORG2=peer1.org2.xfarm.com

PEER0_ORG2_IP=127.0.0.1
PEER1_ORG2_IP=127.0.0.1

ORDERER=orderer.xfarm.com
ORDERER1=orderer1.xfarm.com
ORDERER2=orderer2.xfarm.com
ORDERER3=orderer3.xfarm.com
ORDERER4=orderer4.xfarm.com
ORDERER5=orderer5.xfarm.com

ORDERER_IP=127.0.0.1

LOCALHOST_IP=127.0.0.1



# For new fifth org if added

PEER0_NEW_ORG=peer0.oregon
PEER1_NEW_ORG=peer1.oregon
PEER0_NEW_ORG_IP=127.0.0.1
PEER1_NEW_ORG_IP=127.0.0.1




# FOR HLF 1


# if [[ $1 = "hlf1" ]] ; then
#   export MACHINE="HLF 1"
#   export EXTRA_HOSTS="- ${PEER0_ESP}:${PEER0_ESP_IP}  #HLF 2 instance  
#       - ${PEER1_ESP}:${PEER1_ESP_IP}   #HLF 2 instance  
#       - ${PEER0_BROKER}:${PEER0_BROKER_IP} #HLF 2 instance        
#       - ${PEER1_BROKER}:${PEER0_BROKER_IP} #HLF 2 instance
#   "


# echo "**********************************************************"
# echo "        GENERATING ETC/HOSTS FOR ${MACHINE}"
# echo "**********************************************************"

# sudo /bin/sh -c 'echo "
# '${LOCALHOST_IP}' '${ORDERER}'
# '${LOCALHOST_IP}' '${ORDERER1}' 
# '${LOCALHOST_IP}' '${ORDERER2}'
# '${LOCALHOST_IP}' '${ORDERER3}'
# '${LOCALHOST_IP}' '${ORDERER4}'
# '${LOCALHOST_IP}' '${ORDERER5}'
# '${LOCALHOST_IP}' '${PEER0_ORG1}'
# '${LOCALHOST_IP}' '${PEER1_ORG1}' 
# '${LOCALHOST_IP}' '${PEER0_ORG2}'
# '${LOCALHOST_IP}' '${PEER1_ORG2}'
# '${PEER0_BROKER_IP}' '${PEER0_BROKER}'
# '${PEER1_BROKER_IP}' '${PEER1_BROKER}'
# '${PEER0_ESP_IP}' '${PEER0_ESP}'
# '${PEER1_ESP_IP}' '${PEER1_ESP}'
# " >> /etc/hosts' 
# fi



# FOR HLF 2

if [[ $1 = "hlf1" ]] ; then
  export MACHINE="HLF 1"
  export EXTRA_HOSTS="- ${PEER0_ORG1}:${PEER0_ORG1_IP}  #HLF 1 instance
      - ${PEER1_ORG1}:${PEER1_ORG1_IP}  #HLF 1 instance 
      - ${PEER0_ORG2}:${PEER0_ORG2_IP}    #HLF 1 instance        
      - ${PEER1_ORG2}:${PEER1_ORG2_IP}   #HLF 1 instance  
      - ${ORDERER}:${ORDERER_IP}
      - ${ORDERER1}:${ORDERER_IP}
      - ${ORDERER2}:${ORDERER_IP}
      - ${ORDERER3}:${ORDERER_IP}
      - ${ORDERER4}:${ORDERER_IP}
      - ${ORDERER5}:${ORDERER_IP}
  "

sudo /bin/sh -c 'echo "
'${ORDERER_IP}' '${ORDERER}'
'${ORDERER_IP}' '${ORDERER1}' 
'${ORDERER_IP}' '${ORDERER2}'
'${ORDERER_IP}' '${ORDERER3}'
'${ORDERER_IP}' '${ORDERER4}'
'${ORDERER_IP}' '${ORDERER5}'
'${PEER0_ORG1_IP}' '${PEER0_ORG1}'
'${PEER1_ORG1_IP}' '${PEER1_ORG1}' 
'${PEER0_ORG2_IP}' '${PEER0_ORG2}'
'${PEER1_ORG2_IP}' '${PEER1_ORG2}'
" >> /etc/hosts'
fi



# FOR HLF 3

# if [[ $1 = "hlf3" ]] ; then
#   export MACHINE="HLF 3"
#   export EXTRA_HOSTS="- ${PEER0_OSQO}:${PEER0_OSQO_IP}  #HLF 1 instance
#       - ${PEER1_OSQO}:${PEER1_OSQO_IP}  #HLF 1 instance 
#       - ${PEER0_BCP}:${PEER0_BCP_IP}    #HLF 1 instance        
#       - ${PEER1_BCP}:${PEER1_BCP_IP}   #HLF 1 instance  
#       - ${ORDERER}:${ORDERER_IP}
#       - ${ORDERER1}:${ORDERER_IP}
#       - ${ORDERER2}:${ORDERER_IP}
#       - ${ORDERER3}:${ORDERER_IP}
#       - ${ORDERER4}:${ORDERER_IP}
#       - ${ORDERER5}:${ORDERER_IP}
#       - ${PEER0_ESP}:${PEER0_ESP_IP}  #HLF 2 instance  
#       - ${PEER1_ESP}:${PEER1_ESP_IP}   #HLF 2 instance  
#       - ${PEER0_BROKER}:${PEER0_BROKER_IP} #HLF 2 instance        
#       - ${PEER1_BROKER}:${PEER0_BROKER_IP} #HLF 2 instance
#   "

# sudo /bin/sh -c 'echo "
# '${ORDERER_IP}' '${ORDERER}'
# '${ORDERER_IP}' '${ORDERER1}' 
# '${ORDERER_IP}' '${ORDERER2}'
# '${ORDERER_IP}' '${ORDERER3}'
# '${ORDERER_IP}' '${ORDERER4}'
# '${ORDERER_IP}' '${ORDERER5}'
# '${PEER0_OSQO_IP}' '${PEER0_OSQO}'
# '${PEER1_OSQO_IP}' '${PEER1_OSQO}' 
# '${PEER0_BCP_IP}' '${PEER0_BCP}'
# '${PEER1_BCP_IP}' '${PEER1_BCP}'
# '${PEER0_BROKER_IP}' '${PEER0_BROKER}'
# '${PEER1_BROKER_IP}' '${PEER1_BROKER}'
# '${PEER0_ESP_IP}' '${PEER0_ESP}'
# '${PEER1_ESP_IP}' '${PEER1_ESP}'
# '${LOCALHOST_IP}' '${PEER0_NEW_ORG}' 
# '${LOCALHOST_IP}' '${PEER1_NEW_ORG}' 
# " >> /etc/hosts'
# fi

