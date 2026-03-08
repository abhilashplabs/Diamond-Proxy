// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./LibBankingStorage.sol";

contract LendingFacet {
    error InsufficientLiquidity();
    event Borrow(address indexed user, uint256 amount);

    function borrow(uint256 _amount) external {
        LibBankingStorage.BankingStorage storage ds = LibBankingStorage.diamondStorage();
        
        // Check if the bank has enough cash on hand
        if (_amount > ds.totalBankLiquidity) revert InsufficientLiquidity();

        ds.loanAmount[msg.sender] += _amount;
        ds.totalBankLiquidity -= _amount;

        payable(msg.sender).transfer(_amount);
        emit Borrow(msg.sender, _amount);
    }

    function getLoanBalance(address _user) external view returns (uint256) {
        return LibBankingStorage.diamondStorage().loanAmount[_user];
    }
}