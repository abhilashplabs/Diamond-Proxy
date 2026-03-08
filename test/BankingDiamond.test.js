import { expect } from "chai";
import pkg from "hardhat";
const { ethers } = pkg;

describe("Banking Diamond Ecosystem", function () {
  let diamond;
  let savingsAsDiamond;
  let lendingAsDiamond;
  let owner, user;

  before(async function () {
    console.log("--- Initializing Diamond Test Setup ---");
    [owner, user] = await ethers.getSigners();

    // 1. Deploy Core
    const BankingDiamond = await ethers.getContractFactory("BankingDiamond");
    diamond = await BankingDiamond.deploy(owner.address);

    // 2. Deploy Facets
    const SavingsFacet = await ethers.getContractFactory("SavingsFacet");
    const savings = await SavingsFacet.deploy();
    const LendingFacet = await ethers.getContractFactory("LendingFacet");
    const lending = await LendingFacet.deploy();

    // 3. Automated Selector Registration
    const registerFacet = async (facetInstance) => {
      const facetAddress = await facetInstance.getAddress();
      const selectors = facetInstance.interface.fragments
        .filter(f => f.type === 'function')
        .map(f => f.selector);

      for (const selector of selectors) {
        await diamond.setFacet(selector, facetAddress);
      }
    };

    await registerFacet(savings);
    await registerFacet(lending);

    savingsAsDiamond = await ethers.getContractAt("SavingsFacet", await diamond.getAddress());
    lendingAsDiamond = await ethers.getContractAt("LendingFacet", await diamond.getAddress());
  });

  it("Should allow a user to deposit ETH", async function () {
    const depositAmount = ethers.parseEther("1.0");
    await savingsAsDiamond.connect(user).deposit({ value: depositAmount });
    
    const balance = await savingsAsDiamond.getSavingsBalance(user.address);
    expect(balance).to.equal(depositAmount);
  });

  it("Should allow borrowing from the shared pool", async function () {
    const borrowAmount = ethers.parseEther("0.4");
    await lendingAsDiamond.connect(user).borrow(borrowAmount);
    
    const loan = await lendingAsDiamond.getLoanBalance(user.address);
    expect(loan).to.equal(borrowAmount);
  });
});