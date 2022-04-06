const { artifacts,network } = require('hardhat');
const { writeAbiAddr } = require('./artifact_saver.js')

async function main() {
  // await run('compile');
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );
  console.log("Account balance:", (await deployer.getBalance()).toString());
  //代币合约
  let Token = await ethers.getContractFactory("ERC721Full");
  let token = await Token.deploy(
      "My Game Token",
      "MGT",
      'https://photo.16pic.com/00/93/62/16pic_9362869_b.png');
  //等待部署完成
  await token.deployed();
  console.log("ERC721 Token Address:" + token.address);
  //储存部署信息在文件
  let artifact = await artifacts.readArtifact("ERC721Full");
  await writeAbiAddr(artifact, token.address, "ERC721Full", network.name);
}



main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
});