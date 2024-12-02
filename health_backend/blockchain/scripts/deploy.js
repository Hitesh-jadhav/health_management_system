const hre = require("hardhat");

async function main() {
  // Obtain the contract factory
  const HealthRecord = await hre.ethers.getContractFactory("HealthRecord");

  // Deploy the contract and wait for completion
  const healthRecord = await HealthRecord.deploy();
  await healthRecord.waitForDeployment();

  // Log the deployed contract address
  console.log("HealthRecord deployed to:", healthRecord.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
