pragma solidity ^0.4.16;

contract MessagesExchanges {
    
    string message;
    mapping(address => string[]) public inbox;
    
    event messageReceived(address sender,string message);
    event messageSent(); 

    constructor(
        string _message    
    ) public {
        message=_message;
    }
    
    function  send(address receiver) public{
        inbox[receiver].push(message);
        emit messageSent();
    }
    
    function receive(address receiver) public{
        inbox[receiver]
    }
}
