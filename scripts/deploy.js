const hre = require("hardhat");

async function main() {
  await hre.run('compile');

  const App = await hre.ethers.getContractFactory('App');
  const app = await App.deploy();

  await app.deployed();
  
  await app.resetPolls();

  console.log('Contract deployed to address:', app.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
