// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17 <0.9.0;

contract StakePool {
  // state variables
  address seller;
  address buyer;
  string name;
  string description;
  uint256 price;

  constructor() public {
  }

  event LogSellArticle(
    address indexed seller,
    string name,
    uint256 price
  );

  // sell an article
  function sellArticle(string memory _name, string memory _description, uint256 _price) public {
    // require(
    //   msg.sender == seller,
    //   "Only seller can call this."
    // );
    // string memory sellerStr =  string(abi.encodePacked(msg.sender));
    // _description = sellerStr;

    seller = msg.sender;
    buyer = address(0);
    name = _name;
    description = _description;
    price = _price;

    emit LogSellArticle(seller, name, price);
  }

  // get an article
  function getArticle() public view returns (
    address _seller,
    address _buyer,
    string memory _name,
    string memory _description,
    uint256 _price
  ) {
      return(seller, buyer, name, description, price);
  }
}
