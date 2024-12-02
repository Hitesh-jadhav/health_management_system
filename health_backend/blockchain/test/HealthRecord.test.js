const { expect } = require("chai");

describe("HealthRecord", function () {
  let HealthRecord, healthRecord, owner;

  beforeEach(async function () {
    HealthRecord = await ethers.getContractFactory("HealthRecord");
    [owner] = await ethers.getSigners();
    healthRecord = await HealthRecord.deploy();
    await healthRecord.waitForDeployment();
  });

    it("Should add a record successfully", async function () {
      await healthRecord.addRecord("Health data");
      const record = await healthRecord.getRecord(1);
      expect(record.id).to.equal(1);
      expect(record.user).to.equal(owner.address);
      expect(record.data).to.equal("Health data");
    });

  it("Should retrieve the record by ID", async function () {
    await healthRecord.addRecord("Test health data");
    const record = await healthRecord.getRecord(1);
    expect(record.data).to.equal("Test health data");
  });

  it("Should fail when retrieving a non-existent record", async function () {
    await expect(healthRecord.getRecord(999)).to.be.revertedWith(
      "Record does not exist"
    );
  });
});
