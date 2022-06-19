const { ethers } = require("hardhat")

async function main() {
  const SuperMarioWorld = await ethers.getContractFactory("SuperMarioWorld")
  const superMarioWorld = await SuperMarioWorld.deploy("SuperMarioWorld", "SPRM")
  await superMarioWorld.deployed()
  console.log("Success! Contract was deployed to: ", superMarioWorld.address)

  await superMarioWorld.mint("https://ipfs.io/ipfs/QmSW4F2Pwn8MXyiHQELCe76Sp99DAAFV6XiRQEcU18bVrZ")

  console.log("NFT successfully minted")
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
