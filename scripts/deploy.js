const { ethers } = require("hardhat")

async function main() {
  const SuperMarioWorld = await ethers.getContractFactory("SuperMarioWorldERC1155")
  const superMarioWorld = await SuperMarioWorld.deploy("SuperMarioWorldERC1155", "SPRME")
  await superMarioWorld.deployed()
  console.log("Success! Contract was deployed to: ", superMarioWorld.address)

  await superMarioWorld.mint(10, "https://ipfs.io/ipfs/QmR5Gtu8QykxXn4eVPcHxK3cP6BXCvmZuUVLqwnUeTHSE3")

  console.log("NFTs successfully minted")
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
