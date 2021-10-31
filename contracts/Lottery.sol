// SPDX-License-Identifier: MIT 
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {    
    uint public ethToPay = 0.01 ether;
    uint public minNumberPlayers = 10;

    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.01 ether);
        players.push(payable(msg.sender));
    }

    function transferManager(address newManager) external onlyManager {
        manager = newManager;
    }   

    function setEthToPay(uint _ethToPay) external onlyManager {
        require(_ethToPay > 0);
        ethToPay = _ethToPay;
    }

    function setMinNumberPlayers(uint _minNumberPlayers) external onlyManager {
        require(_minNumberPlayers > 0);
        minNumberPlayers = _minNumberPlayers;
    }

    function getBalance() public view onlyManager returns (uint) {    
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(
            block.difficulty, 
            block.timestamp, 
            players.length)));
    }

    function pickWinner() public onlyManager  {
        require(players.length >= minNumberPlayers);
        uint winnerIndex = random() % players.length;
        players[winnerIndex].transfer(getBalance());
        players = new address payable[](0);
    }

    function numberOfPlayers() public view returns (uint) {
        return players.length;
    }

    modifier onlyManager {
        require(msg.sender == manager);
        _;
    }
}
