let { ethers } = require("hardhat");
let { writeAddr } = require('./artifact_log.js');

async function main() {
    // await run('compile');
    let [owner, second] = await ethers.getSigners();

    let Token = await ethers.getContractFactory("CallOptToken");
    let aAmount = ethers.utils.parseUnits("100000", 18);
    let atoken = await Token.deploy();

    await atoken.deployed();
    console.log("AToken:" + atoken.address);

}

const { artifacts,network } = require('hardhat');
const { writeAbiAddr } = require('./artifact_saver.js')
async function main() {
    const [deployer] = await ethers.getSigners();

    console.log(
      "Deploying contracts with the account:",
      deployer.address
    );
    console.log("Account balance:", (await deployer.getBalance()).toString());
    //学生合约
    const Token = await ethers.getContractFactory("CallOptToken");
    let Amount = ethers.utils.parseUnits("100000", 18);
    let token = await Token.deploy(
        "CallOptToken",
        "CPT",
        Amount);
    //等待部署完成
    await token.deployed();
    console.log("合约地址：", token.address);
    //储存部署信息在文件
    let artifact = await artifacts.readArtifact("CallOptToken");
    await writeAbiAddr(artifact, token.address, "CallOptToken", network.name);
}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });