// We import Chai to use its asserting functions here.
const { BigNumber } = require("@ethersproject/bignumber");
const { expect } = require("chai");


describe("Token contract", function () {

  let Factory;
  let hardhatToken;
  let owner;
  let addr1,addr2,addr3;
  let addrs;

  before(async function () {
    // Get the ContractFactory and Signers here.
    Factory = await ethers.getContractFactory("YunGeToken",{from:owner});
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();

    // Token名称：YGToken
    // Token符号: YGT
    // Token精度: 18
    // Token总量: 10000枚
    hardhatToken = await Factory.deploy("YGToken","YGT","18",10000);
    console.log('owner:',owner.address);
    console.log('token:',hardhatToken.address);
  });

  // You can nest describe calls to create subsections.
  describe("Deployment", function () {
    it("Check name", async () => {
      expect(await hardhatToken.name()).to.equal("YGToken");
    });

    it("Check symbol", async () => {
        expect(await hardhatToken.symbol()).to.equal("YGT");
    });

    it("Check totalSupply", async () => {
      const totalSupply = await hardhatToken.balanceOf(owner.address);
      expect(await hardhatToken.totalSupply()).to.equal(totalSupply);
    });

    it("Check transfer", async () => {
      await hardhatToken.transfer(addr1.address,100);
      expect(await hardhatToken.balanceOf(addr1.address)).to.equal(100)
    })

    it("check the event of transfer",async () => {
      await expect(hardhatToken.transfer(addr1.address, 100))
        .to.emit(hardhatToken,'Transfer')
        .withArgs(owner.address,addr1.address,100);
    });

    it("check approve",async () => {
      //addr2获取200配额
      await hardhatToken.approve(addr2.address,200);
      expect(await hardhatToken.allowance(owner.address,addr2.address)).to.equal(200);
    })

    it("check increaseAllowance", async () => {
      //owner继续给addr2追加300配额，addr2现在有200+300=500配额
      await hardhatToken.increaseAllowance(addr2.address,300);
      expect(await hardhatToken.allowance(owner.address,addr2.address)).to.equal(500);
    })

    it("check transferFrom", async () => {      
       //addr2提取属owner给自己的50个配额，剩余500-50=450
      await hardhatToken.connect(addr2).transferFrom(owner.address,addr2.address,50);
      expect(await hardhatToken.allowance(owner.address,addr2.address)).to.equal(450);
    })

    it("check decreaseAllowance", async () => {
      //减少addr2的100个配额，还剩下450-100 = 350
      await hardhatToken.decreaseAllowance(addr2.address,100);
      expect(await hardhatToken.allowance(owner.address,addr2.address)).to.equal(350);
    })

    it("can not transfer above the amount", async () => {
      //addr1只有100份token，却要发送1007份，超过余额，交易会重置
      await expect(hardhatToken.connect(addr1).transfer(addr3.address, 1007)).to.be.reverted;
    })

  });
 
});