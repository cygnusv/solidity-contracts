require("@keep-network/hardhat-helpers")
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-waffle")
require('@openzeppelin/hardhat-upgrades');
require("hardhat-gas-reporter")

module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
    },
  },

  networks: {
    hardhat: {
      forking: {
        // forking is enabled only if FORKING_URL env is provided
        enabled: !!process.env.FORKING_URL,
        // URL should point to a node with archival data (Alchemy recommended)
        url: process.env.FORKING_URL || "",
        // latest block is taken if FORKING_BLOCK env is not provided
        blockNumber: process.env.FORKING_BLOCK
          ? parseInt(process.env.FORKING_BLOCK)
          : undefined,
      },
      tags: ["local"],
    },
  },

  mocha: {
    timeout: 60000,
  },
}
