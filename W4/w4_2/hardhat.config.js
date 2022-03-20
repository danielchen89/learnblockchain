require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-abi-exporter');

const fs = require('fs');
const mnemonic = fs.readFileSync("../.secret").toString().trim();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",

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
    }
  }
};