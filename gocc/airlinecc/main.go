package main

import (
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

const (
	LAYOUT_TIMESTAMP = "2006-01-02T15:04:05"
)

func GetOrg(stub shim.ChaincodeStubInterface) (string, error) {
	org, ok, err := cid.GetAttributeValue(stub, "hf.Affiliation")
	if err != nil {
		return "", err
	}
	if !ok {
		return "", fmt.Errorf("Org Not Found")
	}
	return org, nil
}

func SetupArgsArray(funcName string, args ...string) [][]byte {
	// Create an args array with 1 additional element for the funcName
	ccArgs := make([][]byte, 1+len(args))

	// Setup the function name
	ccArgs[0] = []byte(funcName)

	// Set up the args array
	for i, arg := range args {
		ccArgs[i+1] = []byte(arg)
	}

	return ccArgs
}

func main() {
	airplaneCon := new(AirplaneCC)
	airplaneCon.Name = "AirplaneContract"
	flightCon := new(FlightScheduleCC)
	flightCon.Name = "FlightContract"
	cc, err := contractapi.NewChaincode(airplaneCon, flightCon)
	if err != nil {
		panic(err.Error())
	}

	if err = cc.Start(); err != nil {
		panic(err.Error())
	}
}
