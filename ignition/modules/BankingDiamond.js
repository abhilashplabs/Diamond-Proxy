import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("BankingDiamondModule", (m) => {
  const owner = m.getAccount(0);

  // 1. Deploy Diamond and Facets
  const diamond = m.contract("BankingDiamond", [owner]);
  const savings = m.contract("SavingsFacet");
  const lending = m.contract("LendingFacet");

  // 2. Link Selectors with Unique IDs
  // Savings: deposit()
  m.call(diamond, "setFacet", ["0xd0e30db0", savings], { id: "setDepositFacet" }); 
  
  // Savings: getSavingsBalance(address)
  m.call(diamond, "setFacet", ["0x61664188", savings], { id: "setGetBalanceFacet" });

  // Lending: borrow(uint256)
  m.call(diamond, "setFacet", ["0xdb445494", lending], { id: "setBorrowFacet" });

  // Lending: getLoanBalance(address)
  m.call(diamond, "setFacet", ["0x9924f331", lending], { id: "setGetLoanFacet" });

  return { diamond };
});