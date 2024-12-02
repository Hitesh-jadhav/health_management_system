const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const HealthRecord = await hre.ethers.getContractFactory("HealthRecord");
  
  const healthRecord = await HealthRecord.deploy();
console.log("Deploying contract...");

await healthRecord.deployed()
  .then(() => {
    console.log("HealthRecord deployed to:", healthRecord.address);
  })
  .catch((err) => {
    console.error("Error during deployment:", err);
  });

  // Log the address
  console.log("HealthRecord deployed to:", healthRecord.address);
}

// Handle errors and exit the process
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment failed:", error);
    process.exit(1);
  });
