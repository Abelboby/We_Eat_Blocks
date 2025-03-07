// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Company} from "./Company.sol";
import "./Ownable.sol";

contract CompanyFactory {
     struct RegistrationRequest {
        string companyName;
        string companyType;
        string registrationNumber;
        string country;
        string city;
        string contactEmail;
        string contactNumber;
        address applicant;
        bool approved;
    }

    struct ApprovedCompany {
        string companyName;
        string companyType;
        string registrationNumber;
        string country;
        string city;
        string contactEmail;
        string contactNumber;
        address companyAddress;
        address companyContract;
    }
