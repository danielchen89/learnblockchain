pragma solidity ^0.8.0;

contract Hello {

  uint public counter;

  constructor(uint x) {
    counter = x;
  }

  function count() public {
    counter = counter + 1;
  }


  function set(uint x) public {
      counter = counter + x;
  }

}