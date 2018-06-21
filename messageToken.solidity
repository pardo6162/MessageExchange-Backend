pragma solidity ^0.4.16;

contract MessagesExchanges {
    
    mapping(address => string[]) public inbox;
    
    event messageReceived(address sender);
    event messageSent(); 

    constructor() public {
    }
    
    function  send(address receiver, string message) public{
        require(receiver!=msg.sender, "sender can't be equals to receiver");
        inbox[receiver].push(message);
        emit messageSent();
    }
    function read(uint index) public  view returns (string){
        require(inbox[msg.sender].length >=index,"index out of range");
        string message= inbox[msg.sender][index];
        inbox[msg.sender][index]="";
        return message;
    }
    
    
}
