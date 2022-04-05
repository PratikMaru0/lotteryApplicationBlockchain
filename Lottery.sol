// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.5.0 < 0.9.0;

contract Lottery {

    // creating manager (that will control whole project)
    address public manager ;
    // making array of participants (payable)
    address payable[] public participants;

    // making Manager a administrator
    constructor() {
        manager = msg.sender;  //Global variable
    }

    // We can use this function only one in the contract so that we can transfer some ammount of ether in contract
    receive() external payable {
        require(msg.value == 1 ether);
        // We must convert msg.sender to payable becoz type of array that we defined is payable (otherwise it will give u an error)
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager);
        return address(this).balance;
    }

    // generating random number
    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    // Selecting winner and transferring winning ammount in the winner wallet address 
    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        uint index = r % participants.length;
        address payable winner = participants[index];
        winner.transfer(getBalance());
        // reseting participants address 
        participants = new address payable[](0);
    }
}
