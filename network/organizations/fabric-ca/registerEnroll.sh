

function createBoeing {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/boeing.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/boeing.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-boeing --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-boeing.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-boeing.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-boeing.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-boeing.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/boeing.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-boeing --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-boeing --id.name user1 --id.secret user1pw --id.type client --id.affiliation boeing --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-boeing --id.name boeingadmin --id.secret boeingadminpw --id.type admin --id.affiliation boeing --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/boeing.com/peers
  mkdir -p organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com

  echo
  echo "## Generate the Boeing msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-boeing -M ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/msp --csr.hosts peer0.boeing.com --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/boeing.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-boeing -M ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls --enrollment.profile tls --csr.hosts peer0.boeing.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/boeing.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/boeing.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/boeing.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/boeing.com/tlsca/tlsca.boeing.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/boeing.com/ca
  cp ${PWD}/organizations/peerOrganizations/boeing.com/peers/peer0.boeing.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/boeing.com/ca/ca.boeing.com-cert.pem

  mkdir -p organizations/peerOrganizations/boeing.com/users
  mkdir -p organizations/peerOrganizations/boeing.com/users/User1@boeing.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-boeing -M ${PWD}/organizations/peerOrganizations/boeing.com/users/User1@boeing.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/boeing.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/boeing.com/users/User1@boeing.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/boeing.com/users/Admin@boeing.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://boeingadmin:boeingadminpw@localhost:7054 --caname ca-boeing -M ${PWD}/organizations/peerOrganizations/boeing.com/users/Admin@boeing.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/boeing/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/boeing.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/boeing.com/users/Admin@boeing.com/msp/config.yaml

}


function createAirbus {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/airbus.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/airbus.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-airbus --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-airbus.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-airbus.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-airbus.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-airbus.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/peerOrganizations/airbus.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca-airbus --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-airbus --id.name user1 --id.secret user1pw --id.type client --id.affiliation airbus --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-airbus --id.name airbusadmin --id.secret airbusadminpw --id.type admin --id.affiliation airbus --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

	mkdir -p organizations/peerOrganizations/airbus.com/peers
  mkdir -p organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-airbus -M ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/msp --csr.hosts peer0.airbus.com --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/airbus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-airbus -M ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls --enrollment.profile tls --csr.hosts peer0.airbus.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x


  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/server.key

  mkdir ${PWD}/organizations/peerOrganizations/airbus.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/airbus.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/organizations/peerOrganizations/airbus.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/airbus.com/tlsca/tlsca.airbus.com-cert.pem

  mkdir ${PWD}/organizations/peerOrganizations/airbus.com/ca
  cp ${PWD}/organizations/peerOrganizations/airbus.com/peers/peer0.airbus.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/airbus.com/ca/ca.airbus.com-cert.pem

  mkdir -p organizations/peerOrganizations/airbus.com/users
  mkdir -p organizations/peerOrganizations/airbus.com/users/User1@airbus.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-airbus -M ${PWD}/organizations/peerOrganizations/airbus.com/users/User1@airbus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/airbus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/airbus.com/users/User1@airbus.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/airbus.com/users/Admin@airbus.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://airbusadmin:airbusadminpw@localhost:8054 --caname ca-airbus -M ${PWD}/organizations/peerOrganizations/airbus.com/users/Admin@airbus.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/airbus/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/airbus.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/airbus.com/users/Admin@airbus.com/msp/config.yaml

}

function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/boeing.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/boeing.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

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
    OrganizationalUnitIdentifier: orderer' > ${PWD}/organizations/ordererOrganizations/boeing.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

	mkdir -p organizations/ordererOrganizations/boeing.com/orderers
  mkdir -p organizations/ordererOrganizations/boeing.com/orderers/boeing.com

  mkdir -p organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp --csr.hosts orderer.boeing.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/boeing.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls --enrollment.profile tls --csr.hosts orderer.boeing.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/server.key

  mkdir ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/msp/tlscacerts/tlsca.boeing.com-cert.pem

  mkdir ${PWD}/organizations/ordererOrganizations/boeing.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/boeing.com/orderers/orderer.boeing.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/boeing.com/msp/tlscacerts/tlsca.boeing.com-cert.pem

  mkdir -p organizations/ordererOrganizations/boeing.com/users
  mkdir -p organizations/ordererOrganizations/boeing.com/users/Admin@boeing.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/boeing.com/users/Admin@boeing.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/boeing.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/boeing.com/users/Admin@boeing.com/msp/config.yaml


}
