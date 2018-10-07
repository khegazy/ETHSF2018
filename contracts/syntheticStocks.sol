pragma solidity ^0.4.24;

//import "requestStockPrices.sol";

contract RopstenConsumer2 {
    function requestEthereumPrice(string _currency, address _addr);
}


contract syntheticStocks {

  struct offer {
    address client;
    bytes32 stock;
    uint256 collateralType;
    uint256 collateralAmount;
    uint256 endBlock;
  }

  struct agreement {
    address client;
    address provider;

    uint256 providerCollateralType;
    uint256 providerCollateralAmount;

    uint256 ClientCollateralType;
    uint256 ClientCollateralAmount;

    bytes32 stock;
    uint256 startPrice;

    uint256 endBlock;
  }

  struct tempAgreement {
    uint256 offerIndex;
    address client;
    address provider;

    uint256 providerCollateralType;
    uint256 providerCollateralAmount;

    uint256 clientCollateralType;
    uint256 clientCollateralAmount;

    bytes32 stock;

    uint256 endBlock;
  }


  uint256 currentOfferIndex;
  uint256[]  _openOfferIndices;
  mapping (uint256 => offer) private _allOffers;
  mapping (address => uint256[]) private _clientOffers;

  uint256 currentTempAgrIndex;
  mapping (address => uint256[]) private _tempAgreements_clients;
  mapping (address => uint256[]) private _tempAgreements_providers;
  mapping (uint256 => tempAgreement) private _allTempAgreements;

  uint256 currentAgrIndex;
  mapping (uint256 => agreement) _allAgreements;
  mapping (address => uint256[]) _agreements_clients;
  mapping (address => uint256[]) _agreements_providers;

  constructor() public {
    currentOfferIndex   = 0;
    currentAgrIndex     = 0;
    currentTempAgrIndex = 0;
  }

  uint256 public currentPrice;
  function bytes32ToStr(bytes32 _bytes32) internal constant returns (string){

    // string memory str = string(_bytes32);
    // TypeError: Explicit type conversion not allowed from "bytes32" to "string storage pointer"
    // thus we should fist convert bytes32 to bytes (to dynamically-sized byte array)

    bytes memory bytesArray = new bytes(32);
    for (uint256 i; i < 32; i++) {
        bytesArray[i] = _bytes32[i];
        }
    return string(bytesArray);
    }

  function getPrice (string _ticker) {
      // call address-> requestEthereumPrice(_ticker, this)
      // -
      // address watch_addr;
      // watch_addr = 0x34263bf3726f1512194c3b0709e1d99472ffa583;

      RopstenConsumer2 r = RopstenConsumer2(0x34263bf3726f1512194c3b0709e1d99472ffa583);
      r.requestEthereumPrice(_ticker, this);
      // watch_addr.call(bytes4(sha3("requestEthereumPrice(string, address)")), _ticker, this);
  }

  function fulfillEthereumPrice(bytes32 _requestId, uint256 _price)
    public
  {
    currentPrice = _price;
  }

  /*
     Client creates a new offer to buy a stock.
     */
  function newOffer(
      bytes32 stock,
      uint256 collateralType,
      uint256 collateralAmount,
      uint256 endBlock) public {

    offer memory ofr;
    ofr.client            = msg.sender;
    ofr.stock             = stock;
    ofr.collateralType    = collateralType;
    ofr.collateralAmount  = collateralAmount;
    ofr.endBlock          = endBlock;

    _clientOffers[msg.sender].push(currentOfferIndex);
    //_offerByStock[stock].push(currentOfferIndex);
    _allOffers[currentOfferIndex] = ofr;
    _openOfferIndices.push(currentOfferIndex);
    currentOfferIndex++;
  }

  /*
     Get available offers.
     */
  function getOpenOffers() public view returns (
      bytes32[], 
      //bytes32[], 
      uint256[], 
      uint256[]) {

    bytes32[] memory stocks  = new bytes32[](_openOfferIndices.length);
    //bytes32[] memory clients = new bytes32[](_openOfferIndices.length);
    uint256[] memory collateral = new uint256[](_openOfferIndices.length);
    uint256[] memory endBlock   = new uint256[](_openOfferIndices.length);

    for (uint i=0; i<_openOfferIndices.length; i++) {
      stocks[i]  = _allOffers[_openOfferIndices[i]].stock;
      //clients[i] = _allOffers[_openOfferIndices[i]].client;
      collateral[i] = _allOffers[_openOfferIndices[i]].collateralAmount;
      endBlock[i]   = _allOffers[_openOfferIndices[i]].endBlock;
    }

    //return (stocks, clients, collateral, endBlock);
    return (stocks, collateral, endBlock);
  }

  /*
     Client can remove the offer.
     */
  function removeOffer(uint256 index) public {
    require (msg.sender == _allOffers[index].client);

    bool removed = false;
    require(_clientOffers[msg.sender].length > 0);
    for (uint i=0; i<_clientOffers[msg.sender].length; i++) {
      if (_clientOffers[msg.sender][i] == index) {
        delete _clientOffers[msg.sender][i];
        removed = true;
      }
      else if (removed) {
        _clientOffers[msg.sender][i-1] 
            = _clientOffers[msg.sender][i];
      }
    }
    _clientOffers[msg.sender].length--;
 
    removed = false;
    require(_openOfferIndices.length > 0);
    for (i=0; i<_openOfferIndices.length; i++) {
      if (_openOfferIndices[i] == index) {
        delete _openOfferIndices[i];
        removed = true;
      }
      else if (removed) {
        _openOfferIndices[i-1] 
            = _openOfferIndices[i];
      }
    }
    _openOfferIndices.length--;
 
    delete _allOffers[index];
  }


  /*
     Function called by provider to offer an agreement
     to the client.
     */
  function newAgreement (
      uint256 index,
      uint256 collateralType,
      uint256 collateralAmount) public payable returns(bool succuss) {

    if (collateralType == 0) {
      require(msg.value == collateralAmount);
    }
    else {
      require(1 == 0);
    }

    tempAgreement memory agr;
    agr.offerIndex  = index;
    agr.client      = _allOffers[index].client;
    agr.provider    = msg.sender;
    agr.stock       = _allOffers[index].stock;
    agr.endBlock    = _allOffers[index].endBlock;

    agr.providerCollateralType    = collateralType;
    agr.providerCollateralAmount  = collateralAmount;
    agr.clientCollateralType    = _allOffers[index].collateralType;
    agr.clientCollateralAmount  = _allOffers[index].collateralAmount;

    _tempAgreements_clients[_allOffers[index].client].push(currentTempAgrIndex);
    _tempAgreements_providers[msg.sender].push(currentTempAgrIndex);

    _allTempAgreements[currentTempAgrIndex] = agr;
    currentTempAgrIndex++;

    return true;
  }


  /*
     Client rejects agreement from provider.
     */
  function rejectAgreement(uint256 index) public {
    removeTempAgreement(index);
  }


  /*
     Client accepts agreement from provider.
     */
  function confirmAgreement(uint256 index) public payable {
    require(msg.sender == _allTempAgreements[index].client);

    agreement memory agr;

    //bytes32 memory btsStock = _allTempAgreements[index].stock;
    string memory strStock = bytes32ToStr(_allTempAgreements[index].stock); //string(btsStock);
    getPrice(strStock); 

    agr.stock       = _allTempAgreements[index].stock;
    agr.endBlock    = _allTempAgreements[index].endBlock;
    agr.startPrice  = currentPrice; //TODO: GET PRICE
    agr.providerCollateralType     =  _allTempAgreements[index].providerCollateralType;
    agr.providerCollateralAmount   =  _allTempAgreements[index].providerCollateralAmount;
    agr.providerCollateralType   =  _allTempAgreements[index].providerCollateralType;
    agr.providerCollateralAmount =  _allTempAgreements[index].providerCollateralAmount;

    _agreements_clients[msg.sender].push(currentAgrIndex);
    _agreements_providers[_allTempAgreements[index].provider].push(currentAgrIndex);

    _allAgreements[currentAgrIndex] = agr;
    currentAgrIndex++;

    removeOffer(_allTempAgreements[index].offerIndex);
    removeTempAgreement(index);
  }


  /*
     Remove temporary agreement either buy revoking or rejecting it.
     */
  function removeTempAgreement(uint256 index) public {

    require((msg.sender == _allTempAgreements[index].client)
        || (msg.sender == _allTempAgreements[index].provider));

    // Return providers collateral
    _allTempAgreements[index].provider.transfer(
        _allTempAgreements[index].clientCollateralAmount);

    // Remove indices
    bool removed      = false;
    address client    = _allTempAgreements[index].client;
    address provider  = _allTempAgreements[index].provider;

    require(_tempAgreements_clients[client].length > 0);
    for (uint i=0; i<_tempAgreements_clients[client].length; i++) {
      if (_tempAgreements_clients[client][i] == index) {
        delete _tempAgreements_clients[client][i];
        removed = true;
      }
      else if (removed) {
        _tempAgreements_clients[client][i-1] 
            = _tempAgreements_clients[client][i];
      }
    }
    _tempAgreements_clients[client].length--;
    
    removed = false;
    require(_tempAgreements_providers[provider].length > 0);
    for (i=0; i<_tempAgreements_providers[provider].length; i++) {
      if (_tempAgreements_providers[provider][i] == index) {
        delete _tempAgreements_providers[provider][i];
        removed = true;
      }
      else if (removed) {
        _tempAgreements_providers[provider][i-1] 
            = _tempAgreements_providers[provider][i];
      }
    }
    _tempAgreements_providers[provider].length--;

    delete _allTempAgreements[index];
  }

}
