pragma solidity ^0.4.20;

contract MobiliToken {
    event carRequested(address user, address driver, string location, uint amount );
    event confirmRequest(address user, address driver);
    event carArrived(address client,address driver);
    event arrivalAtDestination(address client, address driver);
    event sendToken(uint amount,address from, address to);
    
    enum StateType {Possible, InService, Free}
    
    struct Member {
        uint score;
        string location;
        StateType actualState;
        uint256 balanceToken;
        bool isDriver;
        bool isMember;
    }
    
    mapping (address => Member) public members;
    
    
    function requestCar ( uint metters, string destination, uint  aditional, address driver) public onlyMember {
        uint  cost = metters + aditional;
        require(members[msg.sender].balanceToken >= cost);
        require((members[msg.sender].actualState == StateType.Free) && (members[driver].actualState == StateType.Free));
        require(members[driver].isDriver==true);
        members[msg.sender].actualState=StateType.Possible;
        members[driver].actualState=StateType.Possible;
        emit carRequested(msg.sender,driver,members[msg.sender].location,cost);
    }
    
    function  acceptRequest (address user) public onlyMember {
        require((members[user].actualState==StateType.Possible) && (members[msg.sender].actualState == StateType.Possible));
        members[user].actualState =StateType.InService;
        members[msg.sender].actualState =StateType.InService;
        emit confirmRequest(user, msg.sender);
    }
    
    modifier onlyMember(){
        require(members[msg.sender].isMember==true);
        _;
    }
}
