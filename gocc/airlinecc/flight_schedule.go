package main

import (
	"encoding/json"
	"strings"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

const (
	APPROVAL  = 1
	SCHEDULED = 2
	DEPARTED  = 3
	ARRIVED   = 4
	CANCELED  = 5
	DELAYED   = 6
)

type FlightScheduleCC struct {
	contractapi.Contract
}

type FlightSchedule struct {
	OperatorOrg            string    `json:"operatorOrg"`
	Airplane               string    `json:"airplane"`
	FlightRegistration     string    `json:"flightRegistration"`
	State                  uint      `json:"state"`
	DateDepartureScheduled time.Time `json:"dateDepartureScheduled"`
	DateArrivalScheduled   time.Time `json:"dateArrivalScheduled"`
	DateDeparted           time.Time `json:"dateDeparted"`
	DateArrived            time.Time `json:"dateArrived"`
	AirportDepartID        string    `json:"airportDepartID"`
	AirportDepartOrg       string    `json:"airportDepartOrg"`
	AirportArrivalID       string    `json:"airportArrivalID"`
	AirportArrivalOrg      string    `json:"airportArrivalOrg"`
}

// func (fscc *FlightScheduleCC) Init(stub shim.ChaincodeStubInterface) peer.Response {
// 	return shim.Success([]byte("Flight Schedule CC Initiated"))
// }

// func (fscc *FlightScheduleCC) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
// 	function, args := stub.GetFunctionAndParameters()

// 	switch function {
// 	case "CreateSchedule":
// 		return fscc.createSchedule(stub, args)
// 	case "QueryByID":
// 		return fscc.querryByID(stub, args)
// 	case "ApproveSchedule":
// 		return fscc.approveSchedule(stub, args)
// 	case "DelaySchedule":
// 		return fscc.delaySchedule(stub, args)
// 	case "CancelSchedule":
// 		return fscc.cancelSchedule(stub, args)
// 	case "SetDeparted":
// 		return fscc.setDeparted(stub, args)
// 	case "SetArrived":
// 		return fscc.setArrived(stub, args)
// 	}
// 	return shim.Error("Invalid function call")
// }

func (fscc *FlightScheduleCC) GetEvaluateTransactions() []string {
	return []string{"QueryByID"}
}

func (fscc *FlightScheduleCC) CreateSchedule(ctx contractapi.TransactionContextInterface,
	airplane, departSchedule, arrivalSchedule,
	airportDepartID, airportDepartOrg,
	airportArrivalID, airportArrivalOrg string) (string, error) {
	stub := ctx.GetStub()

	airplanCon := new(AirplaneCC)

	_, err := airplanCon.QueryBySN(ctx, airplane)
	if err != nil {
		return "", err
	}
	// ccArgs := SetupArgsArray("AirplaneContract:QueryBySN", airplane)
	// resp := stub.InvokeChaincode("airline", ccArgs, "airlinechannel")
	// fmt.Println(resp.Status)
	// fmt.Println(resp.Message)
	// if resp.Status != shim.OK {
	// 	fmt.Println("error " + resp.Message)
	// 	return "", fmt.Errorf("Airplane SN not found")
	// }

	operatorOrg, err := GetOrg(stub)
	if err != nil {
		return "", err
	}

	dateDepartureScheduled, err := time.Parse(LAYOUT_TIMESTAMP, departSchedule)
	if err != nil {
		return "", err
	}

	dateArrivalScheduled, err := time.Parse(LAYOUT_TIMESTAMP, arrivalSchedule)
	if err != nil {
		return "", err
	}

	fs := FlightSchedule{
		OperatorOrg:            operatorOrg,
		Airplane:               airplane,
		FlightRegistration:     "",
		State:                  APPROVAL,
		DateDepartureScheduled: dateDepartureScheduled,
		DateArrivalScheduled:   dateArrivalScheduled,
		DateDeparted:           dateDepartureScheduled,
		DateArrived:            dateArrivalScheduled,
		AirportDepartID:        airportDepartID,
		AirportDepartOrg:       airportDepartOrg,
		AirportArrivalID:       airportArrivalID,
		AirportArrivalOrg:      airportArrivalOrg,
	}

	data, err := json.Marshal(fs)
	if err != nil {
		return "", err
	}

	// key := strings.ToUpper(airportDepartID) +
	// 	strings.ToUpper(airportArrivalID) +
	// 	strings.ToUpper(operatorOrg) + "-" + guuid.New().String()
	compositeKeys := "depart~arrival~airline"
	key, err := stub.CreateCompositeKey(compositeKeys, []string{strings.ToUpper(airportDepartID),
		strings.ToUpper(airportArrivalID), strings.ToUpper(operatorOrg), stub.GetTxID()})
	if err != nil {
		return "", err
	}

	err = stub.PutState(key, data)
	if err != nil {
		return "", err
	}

	return key, nil
}

func (fscc *FlightScheduleCC) QueryByID(ctx contractapi.TransactionContextInterface, key string) (*FlightSchedule, error) {
	stub := ctx.GetStub()

	data, err := stub.GetState(key)
	if err != nil {
		return nil, err
	}

	flight := new(FlightSchedule)
	err = json.Unmarshal(data, flight)

	return flight, nil
}

// func (fscc *FlightScheduleCC) approveSchedule(stub shim.ChaincodeStubInterface, args []string) peer.Response {
// 	return shim.Success(nil)
// }

// func (fscc *FlightScheduleCC) delaySchedule(stub shim.ChaincodeStubInterface, args []string) peer.Response {
// 	return shim.Success(nil)
// }

// func (fscc *FlightScheduleCC) cancelSchedule(stub shim.ChaincodeStubInterface, args []string) peer.Response {
// 	return shim.Success(nil)
// }

// func (fscc *FlightScheduleCC) setDeparted(stub shim.ChaincodeStubInterface, args []string) peer.Response {
// 	return shim.Success(nil)
// }

// func (fscc *FlightScheduleCC) setArrived(stub shim.ChaincodeStubInterface, args []string) peer.Response {
// 	return shim.Success(nil)
// }

// func GetOrg(stub shim.ChaincodeStubInterface) (string, error) {
// 	org, ok, err := cid.GetAttributeValue(stub, "hf.Affiliation")
// 	if err != nil {
// 		return "", err
// 	}
// 	if !ok {
// 		return "", fmt.Errorf("Org Not Found")
// 	}
// 	return org, nil
// }

// func SetupArgsArray(funcName string, args ...string) [][]byte {
// 	// Create an args array with 1 additional element for the funcName
// 	ccArgs := make([][]byte, 1+len(args))

// 	// Setup the function name
// 	ccArgs[0] = []byte(funcName)

// 	// Set up the args array
// 	for i, arg := range args {
// 		ccArgs[i+1] = []byte(arg)
// 	}

// 	return ccArgs
// }

// func main() {
// 	flightScheduleCC := new(FlightScheduleCC)
// 	err := shim.Start(flightScheduleCC)
// 	if err != nil {
// 		panic(err.Error())
// 	}
// }
