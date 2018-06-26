pragma solidity ^0.4.0;

contract FileExchangeContract {
    
    uint128 filesInbox;
    mapping (address => uint64) public usermsgcnt ;
    
    event ReceiveMessage(
        uint128 msgid,
        address indexed from,
        address indexed to,
        string msgtext
    );

    function FileExchangeContract() public {
        filesInbox = 0;
    }
    
    function sendMessage(address to, string msgtext) public {
        usermsgcnt[to]++;
        ReceiveMessage(filesInbox++, msg.sender, to, msgtext);
    }
}
