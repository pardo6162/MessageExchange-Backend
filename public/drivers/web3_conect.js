
web3 = new Web3(web3.currentProvider);

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
				"type": "bytes32"
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
				"type": "bytes32"
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

var contract= messageContract.at('0x00AC5ed8724100B9D34CcAB0666D54Ad61Ef3590');
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
        if (err) {
        	console.log(err);
            $("#loader").hide();
        }
	});
})

