pragma solidity ^0.6.6;
import "./FlashLoanReceiverBase.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";
//FlashLoanV1合约是继承自FlashLoanReceiverBaseV1合约
contract FlashloanV1 is FlashLoanReceiverBaseV1 {
    //传递了Aave的一个借贷池提供者的地址。在这个例子中，我们提供的是DAI借贷池的地址。
    constructor(address _addressProvider) FlashLoanReceiverBaseV1(_addressProvider) public{}

 /**
   Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
   定义了一个叫做flashLoan的函数。参数是想要闪电贷的资产地址。在这种情况下，该资产是DAI。
 */
 function flashloan(address _asset) public onlyOwner {
        //由于这里不需要任何闪电贷的数据，所以我们传递一个空字符串。
        bytes memory data = "";
        //定义我们想要借出的DAI的数量（以10^18的Wei为单位）。
        uint amount = 1 ether;
        //通过Aave提供的ILendingPoolV1初始化LendingPool接口，这样我们就可以调用flashLoan函数。
        ILendingPoolV1 lendingPool = ILendingPoolV1(addressesProvider.getLendingPool());
        // 最后，调用 flashLoan函数。该函数需要4个主要参数。
        //首先，传递将接收贷款的地址。在我们的例子中，它是当前合约。
        //其次，我们传递资产的地址。在我们的例子中，它是Kovan网络中DAI的地址。
        //第三，传递资产的数量，在我们的案例中，它是1个 ether 单位（或10^18的 wei单位）的数量。
        //第四，传递额外的空数据。
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }

  
    /**
    This function is called after your contract has received the flash loaned amount
    接下来第二个函数executeOperation。这就是我们利用闪电贷的地方。它在flashLoan函数成功执行后被内部调用。它需要4个主要参数，分别是：

    ​ 1). 必须偿还贷款的储备资产地址。
    ​ 2). 资产的数额
    ​ 3). 协议书所收取的费用
    ​ 4). 额外的参数，由函数内部使用。
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        //检查我们是否收到了适当的贷款金额，否则它将抛出一个错误信息。
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");
       // 在这里，可以根据你自己的使用场景，定制自己的实现逻辑（例如去 DEX 中套利）。
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //
        //我们通过使用SafeMaths库提供的add函数，将费用和贷款金额加在一起。
        uint totalDebt = _amount.add(_fee);
        //最后，把总的债务或贷款金额还给贷款人。
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

}