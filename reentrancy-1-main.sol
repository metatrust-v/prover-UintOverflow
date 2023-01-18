pragma solidity ^0.8.0;

contract ReentranceContract {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to] + msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool res, ) = msg.sender.call{value:_amount}("");
      if(res) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  fallback() external payable {

  }
}


// Main contract encoding the harness function as a constructor
contract _MAIN_ {

    ReentranceContract test;

    constructor() public {
      test = new ReentranceContract();

      uint $amount;
      require(address(this).balance >= $amount);

      uint amount_before = address(test).balance;
      test.donate{value: 10000}(address(this));
      test.withdraw(100);

      assert(address(test).balance == amount_before);
    }

    fallback() external payable {
      if (msg.value == 100) {
        test.withdraw(1000);
      }
    }
}