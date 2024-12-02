const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("HealthRecord Contract", function () {
    let HealthRecord;
    let healthRecord;
    let owner;

    beforeEach(async () => {
        // Get the ContractFactory for the HealthRecord contract
        HealthRecord = await ethers.getContractFactory("HealthRecord");
        
        // Deploy the contract and get an instance
        healthRecord = await HealthRecord.deploy();
        
        // Wait for the deployment to be mined
        // await healthRecord.deployed();

        // Get the signer (the account that deploys the contract)
        [owner] = await ethers.getSigners();
    });

    it("Should add a record", async () => {
        await healthRecord.addRecord("User's health data");
        const record = await healthRecord.getRecord(1);
        expect(record.data).to.equal("User's health data");
        expect(record.user).to.equal(owner.address);
    });

    it("Should return the correct record count", async () => {
        await healthRecord.addRecord("User's health data");
        await healthRecord.addRecord("Another user's health data");
        expect(await healthRecord.recordCount()).to.equal(2);
    });

    it("Should revert when getting a non-existent record", async () => {
        await expect(healthRecord.getRecord(999)).to.be.revertedWith("Record does not exist");
    });    
});
