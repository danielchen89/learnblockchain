require("@nomiclabs/hardhat-waffle");
require('hardhat-abi-exporter');

const fs = require('fs');
const mnemonic = fs.readFileSync("../.secret").toString().trim();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


module.exports = {
  solidity: {
    // 编译版本
    compilers: [
      {
        version: "0.8.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
  },

  abiExporter: {
    path: './deployments/abi',
    clear: true,
    flat: true,
    only: [],
    spacing: 2,
    pretty: true,
  },

  networks: {
    dev: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/2093930e36164936aeca180d80c41706`,
      accounts: {
        mnemonic: mnemonic,
      },
      chainId: 3,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/46dc477dacfc47b3a25a4a562730beb1`,
      accounts: {
        mnemonic: mnemonic,
      },
      chainId: 4,
    },
    bsc: {
      url: `https://speedy-nodes-nyc.moralis.io/0cf26c0a971b136efb761a7b/bsc/testnet`,
      accounts: {
        mnemonic: mnemonic,
      },
      chainId: 97,
    }
  }
};
