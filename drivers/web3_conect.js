if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

web3.eth.defaultAccount = web3.eth.accounts[0];
var messageContract = web3.eth.contract([
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "msgid",
				"type": "uint128"
			},
			{
				"indexed": true,
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "msgtext",
				"type": "string"
			}
		],
		"name": "ReceiveMessage",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "to",
				"type": "address"
			},
			{
				"name": "msgtext",
				"type": "string"
			}
		],
		"name": "sendMessage",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "usermsgcnt",
		"outputs": [
			{
				"name": "",
				"type": "uint64"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]);

var contract= messageContract.at('0x2269C1D8e3AC46b8B33fCfa70fcDF948994e0f44');
console.log(contract);

var messageSend = contract.ReceiveMessage({},'latest');

messageSend.watch(function(error, result){
    if (!error){
        $("#loader").hide();
        $("#Message").html('msgid '+result.args.msgid + '\n from '+result.args.from+ '\n to '+result.args.to+ '\n msgtext '+result.args.msgtext);
                } else {
                    $("#dloader").hide();
                    console.log(error);
                }
});

$("#button").click(function() {
	 $("#loader").show();
    contract.sendMessage($("#address").val(), $("#message").val(),(err, res) => {
        if (err) 
            $("#loader").hide();
	});
})

