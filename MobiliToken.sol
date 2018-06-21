pragma solidity ^0.4.16;

contract MobiliTokenERC20 {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    // Store the adrress of the owner
    address public owner = msg.sender;
    
    //States of a member 
    enum StateType {Possible, Waiting, InService, Free}

    
    struct Member {
        string location;
        StateType actualState;
        bool isDriver;
        bool isMember;
    }
    
    struct Service {
        uint Totalmetters;
        string origin;
        string destination;
        uint actualMetters;
        uint aditional;
    }
    
    mapping (address => Member) public members;
    mapping (address => mapping(address => Service)) public services;
    
    
    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);


    // Events 
    event carRequested(address user, address driver, string location, uint amount );
    event confirmRequest(address user, address driver);
    event carArrived(address user,address driver);
    event serviceFinished(address user, address driver);
    event memberJoin(address member);
    event memberUpdated(address member);
    event serviceUpdated(address user, address driver);
    
    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function MobiliTokenERC20(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    
    function join (string location,bool isDriver) public {
        require(members[msg.sender].isMember == false);
        Member memory newMember = Member(location, StateType.Free,isDriver,true);
        members[msg.sender] = newMember;
        emit memberJoin(msg.sender);
    }
    
    function requestCar ( uint metters, string destination, uint  aditional, address driver) public onlyMember {
        require(members[msg.sender].isDriver==false);
        uint  cost = metters + aditional;
        require(balanceOf[msg.sender] >= cost);
        require((members[msg.sender].actualState == StateType.Free) && (members[driver].actualState == StateType.Free));
        require(members[driver].isDriver==true);
        members[msg.sender].actualState=StateType.Possible;
        members[driver].actualState=StateType.Possible;
        Service memory newService = Service(metters,members[msg.sender].location,destination,0,aditional);
        services[msg.sender][driver]=newService;
        emit carRequested(msg.sender,driver,members[msg.sender].location,cost);
    }
    
    function  acceptRequest (address user) public onlyMember {
        require((members[user].actualState==StateType.Possible) && (members[msg.sender].actualState == StateType.Possible));
        members[user].actualState =StateType.Waiting;
        members[msg.sender].actualState =StateType.Waiting;
        emit confirmRequest(user, msg.sender);
    }
    
    function confirmArrival(address driver) public onlyMember {
        require(members[msg.sender].isDriver==false);
        require ((members[msg.sender].actualState==StateType.Waiting)&&(members[driver].actualState==StateType.Waiting));
        members[msg.sender].actualState=StateType.InService;
        members[driver].actualState=StateType.InService;
        emit carArrived(msg.sender,driver);
    }
    
    
    function cancelService(address user,address driver) public onlyMember{
        require((members[driver].actualState!=StateType.Free)||(members[user].actualState!=StateType.Free));
        if (members[driver].actualState == StateType.InService){
            _finishService(user,driver);        
        }else {
            members[driver].actualState=StateType.Free;
            members[user].actualState=StateType.Free;  
        }
        emit serviceFinished(user,driver);
    }
    
    
    function _finishService(address user,address driver) internal{
        require ((members[user].actualState==StateType.InService)&&(members[driver].actualState==StateType.InService));
        members[driver].actualState=StateType.Free;
        members[user].actualState=StateType.Free;
        if (services[user][driver].actualMetters+services[user][driver].aditional>1){
            _transfer(user, owner,(services[user][driver].actualMetters+services[user][driver].aditional)/4);
            _transfer(user, owner,((services[user][driver].actualMetters+services[user][driver].aditional)/4)*3);
        }
        Service memory emptyService = Service(0,"","",0,0);
        services[user][driver]=emptyService;
        emit serviceFinished(user,driver);
    }
    
    function finishService(address driver) public onlyMember{
        require(members[msg.sender].isDriver==false);
        _finishService(msg.sender,driver);
    }
    
    function updateMember(string newLocation,bool _isDriver) public onlyMember{
        require(members[msg.sender].actualState==StateType.Free);
        members[msg.sender].location=newLocation;
        members[msg.sender].isDriver=_isDriver;
        emit memberUpdated(msg.sender);
    }
    
    function updateService(address user,address driver,uint _metters){
        require((members[user].actualState==StateType.InService)&&(members[driver].actualState==StateType.InService));
        services[user][driver].actualMetters+=_metters;
        emit serviceUpdated(user,driver);
    }
    
    modifier onlyMember(){
        require(members[msg.sender].isMember==true);
        _;
    }
}


