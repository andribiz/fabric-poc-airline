const fs = require("fs");
const yaml = require("js-yaml");
const {
  Wallets,
  FileSystemWallet,
  Gateway,
  Wallet,
} = require("fabric-network");
const { NetworkImpl } = require("fabric-network/lib/network");
const { QueryImpl } = require("fabric-network/lib/impl/query/query");

const CONN_PROFILE =
  "../network/organizations/peerOrganizations/boeing.com/connection-boeing.yaml";

const WALLET_PATH = "user-wallet";
const gateway = new Gateway();
let network, airplaneCon;

async function getNetwork() {
  const connectionProfile = yaml.safeLoad(
    fs.readFileSync(CONN_PROFILE, "utf8")
  );
  const wallet = await Wallets.newFileSystemWallet(WALLET_PATH);
  const gatewayOptions = {
    identity: "User1@boeing.com",
    wallet,
    discovery: { enabled: true, asLocalhost: true },
  };
  await gateway.connect(connectionProfile, gatewayOptions);
}

async function checkQuery(serialNumber) {
  try {
    const res = await airplaneCon.evaluateTransaction(
      "QueryBySN",
      serialNumber
    );
    const airplane = JSON.parse(res.toString());

    console.log(airplane.serialNumber);
    console.log(airplane);
  } catch (err) {
    console.log(err);
  }
}

async function checkInvoke(serialNumber) {
  try {
    const res = await airplaneCon.submitTransaction(
      "CreatePlane",
      serialNumber,
      "Batc2",
      "2019-08-01",
      "BA-737 Max",
      "2",
      "123,123",
      "200",
      "100.3",
      "89.3"
    );
    console.log(res.toString());
  } catch (err) {
    console.log(err);
  }
}

async function checkTransient() {
  try {
    const contract = await network.getContract("assets");
    const private_date = {
      object_type: "asset_properties",
      asset_id: "asset1",
      color: "blue",
      size: 32,
      salt: "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
    };
    const res = await contract
      .createTransaction("CreateAsset")
      .setTransient({
        asset_properties: Buffer.from(JSON.stringify(private_date)),
      })
      .submit("324", "Assetku");
    console.log(res.toString());
  } catch (err) {
    console.log(err);
  }
}

async function main() {
  console.log("Connecting...");
  await getNetwork();
  console.log("Connected.");
  network = await gateway.getNetwork("airlinechannel");
  airplaneCon = await network.getContract("airline", "AirplaneContract");
  network.a;
  console.log(process.argv[2]);

  if (process.argv[2] === "query") {
    await checkQuery(process.argv[3]);
  } else if (process.argv[2] === "invoke") {
    await checkInvoke(process.argv[3]);
  } else if (process.argv[2] === "transient") {
    await checkTransient();
  }
  network.
  await gateway.disconnect();
}

main()
  .catch((e) => {
    console.log("Issue program exception.");
    console.log(e);
    console.log(e.stack);
    process.exit(-1);
  })
  .finally(() => {
    console.log("Done");
  });
