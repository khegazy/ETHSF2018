var USER_BLOOM_ID = 55555;
var dummy_offers = [
    ["TSLA",  "22222", "1.000", "Nov. 5, 2018"],
    ["GOOG",  "11111", "5.000", "Nov. 19, 2018"],
    ["AAPL",  "33333", "1.430", "Dec. 2, 2018"],
    ["TSLA",  "44444", "1.000", "Nov. 5, 2018"],
    ["GOOG",  "77777", "5.000", "Nov. 19, 2018"],
    ["AAPL",  "66666", "1.430", "Dec. 2, 2018"],
];
var dummy_agreements = [
    ["AMZN", "55555", "11.045", "Nov. 6, 2018"],
    ["SPOT", "22222", "1.200", "Nov. 19, 2018"],
    ["SNAP", "88888", "0.100", "Dec. 2, 2018"],
    ["AMZN", "77777", "11.045", "Nov. 6, 2018"],
    ["SPOT", "22222", "1.200", "Nov. 19, 2018"],
    ["SNAP", "88888", "0.100", "Dec. 2, 2018"],
];
var dummy_contracts = [
    ["AMZN", "22222" ,"11.045", "10.198", "14.123", "Nov. 6, 2018",],
];
var abi =[
{
"constant": false,
"inputs": [
{
"name": "index",
"type": "uint256"
}
],
"name": "confirmAgreement",
"outputs": [],
"payable": true,
"stateMutability": "payable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "_requestId",
"type": "bytes32"
},
{
"name": "_price",
"type": "uint256"
}
],
"name": "fulfillEthereumPrice",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "_ticker",
"type": "string"
}
],
"name": "getPrice",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "index",
"type": "uint256"
},
{
"name": "collateralType",
"type": "uint256"
},
{
"name": "collateralAmount",
"type": "uint256"
}
],
"name": "newAgreement",
"outputs": [
{
"name": "succuss",
"type": "bool"
}
],
"payable": true,
"stateMutability": "payable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "stock",
"type": "bytes32"
},
{
"name": "collateralType",
"type": "uint256"
},
{
"name": "collateralAmount",
"type": "uint256"
},
{
"name": "endBlock",
"type": "uint256"
}
],
"name": "newOffer",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "index",
"type": "uint256"
}
],
"name": "rejectAgreement",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "index",
"type": "uint256"
}
],
"name": "removeOffer",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
},
{
"constant": false,
"inputs": [
{
"name": "index",
"type": "uint256"
}
],
"name": "removeTempAgreement",
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
"inputs": [],
"name": "currentPrice",
"outputs": [
{
"name": "",
"type": "uint256"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
},
{
"constant": true,
"inputs": [],
"name": "getOpenOffers",
"outputs": [
{
"name": "",
"type": "bytes32[]"
},
{
"name": "",
"type": "uint256[]"
},
{
"name": "",
"type": "uint256[]"
}
],
"payable": false,
"stateMutability": "view",
"type": "function"
}
];
var address = "0x6e2fc049bd9ff518a9ed26d744d5e747370c93d3";

function accept_buttons(index) {
    return "<button class='accept_offer' data-index=" + index + ">accept</button> ";
};


function create_row(items) {
    var result = "";
    items.forEach(function(item) {
        result += "<td>" + item + "</td>";
    });
    return result
};

function load_offers() {
    dummy_offers.forEach(function(offer_list, index) {
        offer_list.push(accept_buttons(index));
        document.getElementById("offer_table").innerHTML += create_row(offer_list);
    });
};

function refresh_offers() {
    document.getElementById("offer_table").innerHTML = "";
    dummy_offers.forEach(function(offer_list, index) {
        document.getElementById("offer_table").innerHTML += create_row(offer_list);
    });
};

function load_agreements() {
    dummy_agreements.forEach(function(agreements_list, index) {
        document.getElementById("agreements_table").innerHTML += create_row(agreements_list);
    });
};

function refresh_agreements() {
    document.getElementById("agreements_table").innerHTML = "";
    dummy_agreements.forEach(function(agreements_list, index) {
        document.getElementById("agreements_table").innerHTML += create_row(agreements_list);
    });
};

function load_contracts() {
    dummy_contracts.forEach(function(contracts_list) {
        document.getElementById("contracts_table").innerHTML += create_row(contracts_list);
    });
};

function refresh_contracts() {
    document.getElementById("contracts_table").innerHTML = "";
    dummy_contracts.forEach(function(contracts_list) {
        document.getElementById("contracts_table").innerHTML += create_row(contracts_list);
    });
};

function get_current_ticker_price(ticker) {
    return (Math.random() * 5).toFixed(3);
};

function match_trade(index) {
    var offer = dummy_offers[index];
    dummy_offers.splice(index,1);
    var collateral = document.getElementById('fcollateral').value ;
    // dummy_agreements.push([offer[0], collateral, offer[1], collateral, offer[2], offer[3]]);
    // dummy_agreements= dummy_agreements.filter( function(cur_agreement) {
    //     return cur_agreement[0] != agreement[0];
    // });
    dummy_agreements.push([offer[0], offer[1], collateral, offer[3]]);
    refresh_agreements();
    refresh_offers();
    setup_buttons();
};

function reject_trade(index){
    dummy_agreements.splice(index,1);
    refresh_agreements();
    setup_buttons();
};

function setup_buttons() {
    var accept_buttons = document.querySelectorAll('.accept_offer');
    // var reject_buttons = document.querySelectorAll('.reject_offer');

    var accept_offer = function(index) {
        return function handle_accept(event) {
            match_trade(index);
        };
    };

    for(var i=0; i<accept_buttons.length; i++) {
        accept_buttons[i].addEventListener("click", accept_offer(i), false);
    };

};

// window.addEventListener('load', function() {
//   // Checking if Web3 has been injected by the browser (Mist/MetaMask)
//
//   // console.log("Using web3 version: " + Web3.version);
//   // if (typeof web3 == 'undefined') throw 'No web3 detected. Is Metamask/Mist being used?';
//   // web3 = new Web3(web3.currentProvider); // MetaMask injected Ethereum provider
//   // Get the account of the user from metamask
//
//
//     if (typeof web3 !== 'undefined') {
//       web3 = new Web3(web3.currentProvider);
//     } else {
//       // Set the provider you want from Web3.providers
//       web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
//
//     const userAccounts = web3.eth.accounts; // resolves on an array of accounts
//     userAccount = userAccounts[0];
//
//     console.log("User account:", userAccount);
//
//     var contract = new web3.eth.contract(abi, address);
//     var ticker = 'AMZN';
//     console.log(contract);
//
//     console.log(contract.newAgreement(ticker, 0, get_current_ticker_price(ticker) * 10**8).call({from: userAccount}));
//     }
//
// });

$(document).ready(function() {
    load_offers();
    load_agreements();
    load_contracts();
    setup_buttons();
});