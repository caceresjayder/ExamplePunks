import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomiclabs/hardhat-ethers";
require('dotenv').config()
const { API_URL, PRIVATE_KEY } = process.env

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: API_URL,
      accounts: [
       `${PRIVATE_KEY}`,
      ]
    }
  }
};

export default config;
