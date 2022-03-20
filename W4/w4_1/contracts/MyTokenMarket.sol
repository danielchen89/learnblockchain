//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IUniswapV2Router01.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MyTokenMarket {
    using SafeERC20 for IERC20;

    address public myToken;
    address public router;
    address public weth;

    constructor(address _token, address _router,address _weth) {
        myToken = _token;
        router = _router;
        weth = _weth;
    }

    // Token & ETH coin -> token(erc20)
    function AddLiquidity(uint tokenAmount) public payable {
        //IERC20 表示将方法转化为接口
        // IERC20(myToken).transferFrom(msg.sender, address(this),tokenAmount);
        // IERC20(myToken).approve(router,tokenAmount);
        IERC20(myToken).safeTransferFrom(msg.sender, address(this),tokenAmount);
        IERC20(myToken).safeApprove(router,tokenAmount);

        IUniswapV2Router01(router).addLiquidityETH{value:msg.value}(myToken,
            tokenAmount,0,0,msg.sender,block.timestamp);
    }

    function buyToken(uint minTokenAmount) public payable {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = myToken;

        IUniswapV2Router01(router).swapExactETHForTokens{value:msg.value}(minTokenAmount,path,msg.sender, block.timestamp);
    }


} 