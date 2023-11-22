// Don't modify these values while deploying unless you are deploying a new modified contract.

const ethers = require("ethers")

const signedTransaction = "0xf8b88085174876e80083015f908080b866605d8060093d393df3756d363d3d37363d34f03d5260203df33d52600e6012f33d52336020526004356040526060602c206016600a3df58061003b5760013d5260203dfd5b60203d6044358060643d373d34855af16100585760025f5260205ffd5b60205ff31ba08888888888888888888888888888888888888888888888888888888888888888a03333333333333333333333333333333333333333333333333333333333333333"

const signerAddress = "0x77a9D56476897C82560f097fea5B2F965D58bE15"

const expectedContractAddress = "0x749b753DA5168F9d10a30Eb3394a3B852B4ec6c9"

const gasLimit = ethers.toBigInt(90000)
const gasPrice = ethers.toBigInt(100000000000)

// Change RPC url with respective blockchain RPC url
const rpcUrl = "https://goerli.blockpi.network/v1/rpc/public"
const provider = ethers.getDefaultProvider(rpcUrl)

async function main() {

    if(await provider.getCode(expectedContractAddress) != '0x') {
        console.log("Contract already exists at address: ", expectedContractAddress)
        return
    }
    const signerBalance = await provider.getBalance(signerAddress)
    const minRequiredBalance = gasLimit * gasPrice
    const neededBalance = minRequiredBalance - signerBalance
    if(signerBalance < minRequiredBalance) {
        console.log(`Insufficient signer balance. Need more ${neededBalance} wei or ${ethers.formatEther(neededBalance)} Ether`)
        console.log(`Send required amount of native token of your chosen blockchain to ${signerAddress}`)
        return
    }
    
    const txReceipt = await provider.broadcastTransaction(signedTransaction)
    console.log("Deploying...")
    await txReceipt.wait()
    if(await provider.getCode(expectedContractAddress) == '0x') {
        console.log("Contract failed to deploy")
        return
    }
    console.log(`Factory contract successfully deployed to ${expectedContractAddress}.\n`)
    console.log(txReceipt)
    console.log(`\nSearch this hash in the respective blockchain explorer for more transaction details: ${txReceipt.hash}`)
}

main().catch(err => console.log(err))