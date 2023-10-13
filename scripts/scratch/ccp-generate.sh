#!/bin/bash
# . envVar.sh

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${PEERNAME1}/$6/" \
        -e "s/\${PEERNAME2}/$7/" \
        -e "s/\${P1PORT}/$8/" \
        ${PWD}/../ccp-files/ccp-xfarm.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        -e "s/\${PEERNAME1}/$6/" \
        -e "s/\${PEERNAME2}/$7/" \
        -e "s/\${P1PORT}/$8/" \
        ${PWD}/../ccp-files/ccp-xfarm.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# generating ccp for xfarm

ORG="org1"
P0PORT=7051
P1PORT=8051
CAPORT=7054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/tlsca/tlsca.${ORG}.xfarm.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/ca/ca.${ORG}.xfarm.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/$ORG.xfarm.com/connection-$ORG.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/connection-${ORG}.yaml



# generating ccp for org2

ORG="org2"
P0PORT=9051
P1PORT=10051
CAPORT=8054
PEERPEM=${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/tlsca/tlsca.${ORG}.xfarm.com-cert.pem
CAPEM=${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/ca/ca.${ORG}.xfarm.com-cert.pem
PEERNAME1=peer0
PEERNAME2=peer1

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/connection-${ORG}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $PEERNAME1 $PEERNAME2 $P1PORT)" > ${PWD}/../organizations/peerOrganizations/${ORG}.xfarm.com/connection-${ORG}.yaml



