#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp/tlscacerts/tlsca.boeing.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/ca.crt
# export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt


if [ -z "$2" ]; then
  USER="Admin"
else 
  USER=$2
fi

if [ $1 = "boeing" ]; then
  export CORE_PEER_LOCALMSPID="BoeingMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/boeing.com/users/${USER}@boeing.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
elif [ $1 = "airbus" ]; then
  export CORE_PEER_LOCALMSPID="AirbusMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/airbus.com/users/${USER}@airbus.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
elif [$1 = "orderer"]; then 
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp/tlscacerts/tlsca.boeing.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/boeing.com/users/${USER}@boeing.com/msp
fi

# elif [ $USING_ORG -eq "airbus" ]; then
#   export CORE_PEER_LOCALMSPID="AirbusMSP"
#   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
#   export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
#   export CORE_PEER_ADDRESS=localhost:11051

