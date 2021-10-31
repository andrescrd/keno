// SPDX-License-Identifier: MIT 
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {    
    uint public ethToPay = 0.01 ether;
    address payable[] public players;
    address public manager;


    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.01 ether);
        players.push(payable(msg.sender));
    }

    function setEthToPay(uint _ethToPay) external onlyManager {
        require(_ethToPay > 0);
        ethToPay = _ethToPay;
    }

    function getBalance() public view onlyManager returns (uint) {    
        return address(this).balance;
    }

    modifier onlyManager {
        require(msg.sender == manager);
        _;
    }
}
