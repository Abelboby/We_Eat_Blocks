// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Company} from "./Company.sol";

contract CompanyFactory {
    address public owner;
    mapping(address => Company) public companies;
}
