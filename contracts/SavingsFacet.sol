// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./LibBankingStorage.sol";

contract SavingsFacet {
    event Deposit(address indexed user, uint256 amount);

    function deposit() external payable {
        LibBankingStorage.BankingStorage storage ds = LibBankingStorage.diamondStorage();
        ds.savingsBalance[msg.sender] += msg.value;
        ds.totalBankLiquidity += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function getSavingsBalance(address _user) external view returns (uint256) {
        return LibBankingStorage.diamondStorage().savingsBalance[_user];
    }
}