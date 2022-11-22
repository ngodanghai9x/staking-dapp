// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17 <0.9.0;

contract ScammerAdmin {
    // state variables
    address payable admin;

    modifier onlyAdmin() {
        // require(payable(msg.sender) == admin, "You are not admin payable");
        require(msg.sender == admin, "You are not admin");
        _; // this _ is the code func will exec when the func impl this modifier
    }

    constructor() {
        admin = payable(msg.sender);
        // admin = (msg.sender);
    }

    function letScamAndRun() public onlyAdmin {
        // require(msg.sender == admin, "You are not admin"); // no need because modifier onlyAdmin
        // destroy the contract, and withdraw all ETH in contract to the specified address (admin)
        selfdestruct(admin);
    }
}
