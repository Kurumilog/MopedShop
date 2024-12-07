// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

contract MopedShop {
    mapping (address => bool) buyers;
    uint public price = 2 ether;
    address public owner;
    address public ShopAddress;
    bool fullyPaid;

    event ItemFullyPaid(uint price, address _shopAddress);

    constructor() {
        owner = msg.sender;
        ShopAddress = address(this);
    }

    function getBuyer(address _addr) public view returns(bool) {
        require(owner == msg.sender, "You are not an owner");
        return buyers[_addr];
    }

    function addBuyer(address _addr) public {
        require(owner == msg.sender, "You are not an owner");
        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return ShopAddress.balance;
    }

    function withdrawAll() public  {
        require(owner == msg.sender && fullyPaid && ShopAddress.balance > 0 , "Rejected");

        address payable reciver = payable(msg.sender);

        reciver.transfer(ShopAddress.balance);
    }

    receive() external payable {
        require(buyers[msg.sender] && msg.value <= price && !fullyPaid, "Rejected");

        if(ShopAddress.balance == price) {
            fullyPaid = true;

            emit ItemFullyPaid(price, ShopAddress);
        }
}
}