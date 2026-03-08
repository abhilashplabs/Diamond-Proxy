// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./LibBankingStorage.sol";

contract BankingDiamond {
    constructor(address _owner) {
        LibBankingStorage.diamondStorage().owner = _owner;
    }

    // This function replaces the need for a 'diamondCut' facet for initial setup
    function setFacet(bytes4 _selector, address _facet) external {
        LibBankingStorage.BankingStorage storage ds = LibBankingStorage.diamondStorage();
        require(msg.sender == ds.owner, "Only owner");
        ds.selectorToFacet[_selector] = _facet;
    }

    fallback() external payable {
        LibBankingStorage.BankingStorage storage ds = LibBankingStorage.diamondStorage();
        address facet = ds.selectorToFacet[msg.sig];
        require(facet != address(0), "Function does not exist");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result case 0 { revert(0, returndatasize()) } default { return(0, returndatasize()) }
        }
    }
    receive() external payable {}
}