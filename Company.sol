// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Company{
    string public companyName;
    string public companyType;
    string public registrationNumber;
    string public country;
    string public city;
    string public contactEmail;
    string public contactNumber;
    uint256 public tokenBalance;
    address public factory; // Stores the factory contract address

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
    )Ownable(_owner) {
        companyName = _companyName;
        companyType = _companyType;
        registrationNumber = _registrationNumber;
        country = _country;
        city = _city;
        contactEmail = _contactEmail;
        contactNumber = _contactNumber;
        factory = _factory;
    }
}
