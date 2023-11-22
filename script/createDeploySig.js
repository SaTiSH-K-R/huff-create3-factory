// If Create3Factory.huff is modified, run 'huffc -a ./src/Create3Factory.huff' to save bytecode of the contract


const ethers = require("ethers")
const fs = require("fs")

async function main() {
    const bytecode = JSON.parse(fs.readFileSync("artifacts/SRC/CREATE3FACTORY.HUFF.json", 'utf-8')).bytecode
    const gasLimit = 90000
    const gasPrice = 100000000000

    const txData = {
        type: 0,
        data: `0x${bytecode}`,     // bytecode with constructor arguments
        nonce: 0,
        gasLimit,
        gasPrice,
        value: 0,
        chainId: 0,
        signature: {               // manually created
            r: "0x8888888888888888888888888888888888888888888888888888888888888888",
            s: "0x3333333333333333333333333333333333333333333333333333333333333333",
            v: 27
        }
    }
    
    const txSigned = ethers.Transaction.from(txData)
    const txSignedSerialized = txSigned.serialized
    const derivedAddressOfSigner = txSigned.from
    const txSignedSerializedHash = ethers.keccak256(txSignedSerialized)
    const contractAddress = ethers.getCreateAddress({ from: derivedAddressOfSigner, nonce: txData.nonce })
    console.log("Signer Address:: ", derivedAddressOfSigner)
    console.log("Expected Contract Address:: ", contractAddress)
    console.log("Expected tx hash:: ", txSignedSerializedHash)    
    console.log("Made up transaction signature:: ", txSignedSerialized)

}

main().catch(err => console.log(err))