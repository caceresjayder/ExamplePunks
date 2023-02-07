import { ethers } from "hardhat";

const deploy = async () => {    
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contract with the account:", deployer.address)

    const ExamplePunks = await ethers.getContractFactory("ExamplePunks")
    const deployed = await ExamplePunks.deploy(10000)

    console.log("Deployed in:", deployed.address)

}

deploy().then(() => process.exit(0)).catch(err => 
   { console.log(err);
    process.exit(1)})