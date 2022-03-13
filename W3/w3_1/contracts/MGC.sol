//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MGC is ERC20 {

    // constructor() ERC20("My Golden Coin", "MGC") {
    //     _mint(msg.sender, 1000 * 10 ** 18);
    // }
    constructor() ERC20("My Golden Coin", "MGC") {}

    //无限增发
    function mint(address _account,uint256 _amount) public returns (bool) {
        _mint(_account,_amount);
        return true;
    }
}