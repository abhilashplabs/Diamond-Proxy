Banking Diamond: Modular ERC-2535 Ecosystem
An enterprise-grade implementation of the ERC-2535 Diamond Standard tailored for a banking domain. This project demonstrates how to bypass the 24KB contract size limit by utilizing modular "Facets" for Savings and Lending logic, all sharing a unified Diamond Storage.

🏗️ Architectural Overview
This project moves beyond standard UUPS proxies to a multi-facet architecture. The BankingDiamond acts as a central router, delegating calls to specialized logic modules.

Key Components:

BankingDiamond.sol: The core proxy (router) using assembly-level delegatecall for O(1) routing efficiency.

SavingsFacet.sol: Manages deposits and global bank liquidity.

LendingFacet.sol: Manages loan issuance, interacting with the same liquidity pool.

LibBankingStorage.sol: Implements Diamond Storage at a randomized keccak256 slot to prevent memory collisions.

Technical Deep Dive
1. Assembly Routing Engine

The Diamond uses a low-level fallback function to delegate calls. This ensures that any function added via a facet is immediately accessible via the Diamond address.

```
assembly {
    calldatacopy(0, 0, calldatasize())
    let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
    returndatacopy(0, 0, returndatasize())
    switch result case 0 { revert(0, returndatasize()) } default { return(0, returndatasize()) }
}
```
2. Diamond Storage

To avoid the risks of storage collisions inherent in traditional inheritance, this project utilizes hashed storage positions.

Storage Slot: keccak256("pro.abhilash.banking.storage")

Deployment & Orchestration
This project utilizes Hardhat Ignition for declarative, state-tracked deployments.

Prerequisites

Node.js (ESM enabled)

Hardhat 3

Commands
```
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Deploy to local node
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/BankingDiamond.js --network localhost
```
