// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library LibBankingStorage {
    bytes32 constant STORAGE_POSITION = keccak256("linkedinseries.abhilash.banking.storage");

    struct BankingStorage {
        address owner;
        mapping(bytes4 => address) selectorToFacet;
        // Banking State
        mapping(address => uint256) savingsBalance;
        mapping(address => uint256) loanAmount;
        uint256 totalBankLiquidity;
    }

    function diamondStorage() internal pure returns (BankingStorage storage ds) {
        bytes32 position = STORAGE_POSITION;
        assembly { ds.slot := position }
    }
}