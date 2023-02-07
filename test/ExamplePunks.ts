const { expect } = require('chai');
const  { ethers } = require('hardhat')

describe('ExamplePunks testing', () => {
    const setup = async ({maxSupply = 10000}) => {
        const [owner] = await ethers.getSigners();
        const ExamplePunks = await ethers.getContractFactory("ExamplePunks")
        const deployed = await ExamplePunks.deploy(maxSupply)

        return {
            owner,
            deployed
        }

    }
    describe('Deployment', () => {
        it('Sets max supply to passed param', async () => {
            const maxSupply = 4000;

            const { deployed } = await setup({maxSupply})

            const returnedMaxSupply = await deployed.maxSupply();
            expect(maxSupply).to.equal(returnedMaxSupply)
        })
    })

    describe('minting', () =>{
        it('Mints a new token', async () => {
            const maxSupply = 3000
            const { owner, deployed } = await setup({})
            await deployed.safeMint()

            const ownerOfMinted = await deployed.ownerOf(0)

            expect(ownerOfMinted).to.equal(owner.address)
        })

        it('have a minting limit', async () => {
            const maxSupply = 2;

            const { deployed } = await setup({maxSupply})
            await deployed.safeMint()
            await deployed.safeMint()


            await expect(deployed.safeMint()).to.be.revertedWith('Not Punks Left!')

        })
    })
    describe('tokenURI', () => {
        it('returns valid metadata', async () => {
            const { deployed } = await setup({})

            await deployed.safeMint();

            const tokenURI = await deployed.tokenURI(0)
            
            const stringifiedTokenURI = await tokenURI.toString()
            
            const [,base64JSON] = stringifiedTokenURI.split(
            "data:application/json;base64,")

            const stringifiedMetaData = await Buffer.from(base64JSON, "base64").toString('ascii')
            
            const metadata = JSON.parse(stringifiedMetaData)

            expect(metadata).to.have.all.keys('name', 'description', 'image')
        })
    })
})