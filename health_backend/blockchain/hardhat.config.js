// require("@nomicfoundation/hardhat-toolbox");

// /** @type import('hardhat/config').HardhatUserConfig */
// module.exports = {
//   solidity: "0.8.27",
// };


require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */

require('dotenv').config();

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.27",
  networks: {
    hardhat: {},
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: [process.env.PRIVATE_KEY], // You can also omit this; it uses the accounts from npx hardhat node by default.
    },
    // volta: {
    //    url: API_URL,
    //    accounts: [`0x${PRIVATE_KEY}`],
    //    gas: 210000000,
    //    gasPrice: 800000000000,
    // }
 },
};
