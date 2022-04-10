//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

// ETH Call Opt
/*
    设计一个看涨期权Token:
    创建期权Token 时，确认标的的价格与行权日期；
    发行方法（项目方角色）：根据转入的标的（ETH）发行期权Token；
    （可选）：可以用期权Token 与 USDT 以一个较低的价格创建交易对，模拟用户购买期权。
    行权方法（用户角色）：在到期日当天，可通过指定的价格兑换出标的资产，并销毁期权Token
    过期销毁（项目方角色）：销毁所有期权Token 赎回标的。
*/

contract CallOptToken is ERC20, Ownable {
  using SafeERC20 for IERC20;

  uint public price;    
  address public udscToken; //期权token
  uint public settlementTime; //行权时间
  uint public constant during = 1 days; // 1 day

  constructor(address usdc) ERC20("CallOptToken", "COPT") {
    udscToken = usdc;
    price = 10;
    settlementTime = block.timestamp + 100 days;
  }

  // 1 eth ： 10^18; = 10^18 COPT
  function mint() external payable onlyOwner {
    _mint(msg.sender, msg.value);
  }

  // 10 COPT - USDT/ETH  PAIR v2 v3
  // 1 COPT = 1USDT

  // amount: 0.5 COPT --> 0.5ETH

  function settlement(uint amount) external {
    require(block.timestamp >= settlementTime && block.timestamp < settlementTime + during, "invalid time");

    _burn(msg.sender, amount);

    uint needUsdcAmount = price * amount; // 5000 * 0.5 * 10^18;

    //行权资金
    IERC20(udscToken).safeTransferFrom(msg.sender, address(this), needUsdcAmount);

    //
    safeTransferETH(msg.sender, amount);
  }

  // Uniswap
  function safeTransferETH(address to, uint256 value) internal {
    (bool success, ) = to.call{value: value}(new bytes(0));
    require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
  }
   //将合约资金取走
  function burnAll() external onlyOwner {
    require(block.timestamp >= settlementTime + during, "not end");
    uint usdcAmount = IERC20(udscToken).balanceOf(address(this));
    IERC20(udscToken).safeTransfer(msg.sender, usdcAmount);


    selfdestruct(payable(msg.sender));
    // uint ethAmount = address(this).balance;
    // safeTransferETH(msg.sender, ethAmount);
  }


}