const fs = require("fs");

const { Wallets, X509Identity } = require("fabric-network");
const WALLET_PATH = "user-wallet";
const CRYPTO_PATH = "../network/organizations/peerOrganizations";

let wallet;

async function add(org, user) {
  const label = `${user}@${org}.com`;
  const certPath = `${CRYPTO_PATH}/${org}.com/users/${label}/msp/signcerts`;
  const privPath = `${CRYPTO_PATH}/${org}.com/users/${label}/msp/keystore`;
  let privFile, certFile;
  fs.readdirSync(privPath).forEach((file) => {
    privFile = privPath + "/" + file;
    return;
  });
  fs.readdirSync(certPath).forEach((file) => {
    certFile = certPath + "/" + file;
    return;
  });

  const privateKey = fs.readFileSync(privFile).toString();
  const certificate = fs.readFileSync(certFile).toString();
  const mspId = org.charAt(0).toUpperCase() + org.slice(1) + "MSP";
  const identity = {
    credentials: {
      certificate,
      privateKey,
    },
    mspId,
    type: "X.509",
  };

  await wallet.put(label, identity);
}

async function main() {
  const command = process.argv[2];

  wallet = await Wallets.newFileSystemWallet(WALLET_PATH);

  if (command === "add") {
    return add(process.argv[3], process.argv[4]);
  } else if (command === "list") {
  } else if (command === "export") {
  }
}

main();
