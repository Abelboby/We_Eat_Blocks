// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Ownable.sol";

contract Company is Ownable {
    string public companyName;
    string public companyType;
    string public registrationNumber;
    string public country;
    string public city;
    string public contactEmail;
    string public contactNumber;
    uint256 public tokenBalance;

    address public factory; // Stores the factory contract address

    event TokensAdded(uint256 amount);

    constructor(
        string memory _companyName,
        string memory _companyType,
        string memory _registrationNumber,
        string memory _country,
        string memory _city,
        string memory _contactEmail,
        string memory _contactNumber,
        address _owner,
        address _factory
    ) Ownable(_owner) {
        companyName = _companyName;
        companyType = _companyType;
        registrationNumber = _registrationNumber;
        country = _country;
        city = _city;
        contactEmail = _contactEmail;
        contactNumber = _contactNumber;
        factory = _factory;
    }

    // Function to allow only the factory to update token balance
    function addTokens(uint256 amount) external {
        require(msg.sender == factory, "Only factory can add tokens");
        require(amount > 0, "Amount must be greater than zero");
        tokenBalance += amount;
        emit TokensAdded(amount);
    }
}
