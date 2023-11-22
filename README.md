# Huff Create3 Project

Some web3 projects want to deploy smart contracts to the same address on multiple EVM blockchains.

A few ways to achieve this are:
### Syncing nonce of EOA
Syncing the nonce of EOA to get the same contract address is unreliable because if the transaction fails it is impossible to get the same address as the nonce increments even though the transaction fails.

### Create2 Factory
Create2 Factory uses `create2` opcode to deploy the contracts to get the same addresses. `create2` opcode uses the address that is deploying, a salt, and the bytecode of the contract to calculate the contract address. So if the bytecode changes a bit that would give a completely different address.

### Create3 Factory
Create3 Factory uses both `create` and `create2` opcodes.
- This factory first deploys a proxy contract using `create2` opcode. Proxy contract address is calculated using:
  - address of the factory contract
  - salt
  - bytecode of the proxy contract (always stays same)
- Then proxy contract deploys the target contract using `create` opcode. Target contract address is calculated using:
  - address of the proxy contract
  - nonce (it is always 0 as proxy contract is one time use)

It is impossible to frontrun as the `salt` is hashed with the `msg.sender`, so malicious actors can not deploy a malicious contract to your contract address unless they have your private key.

Same salt should be provided for all blockchains when deploying.

## Deploying Factory contract
In order to get the same addresses for the contracts, the factory contract itself should be at the same address on multiple blockchains. There is a method called keyless deployment to achieve the same address for factory contract on multiple blockchains.
### Keyless Deployment
In this method, the deployment transaction signature is modified with arbitrary `v`, `r`, and `s`, thereby causing the transaction to be signed by an account whose private key remains unknown and can't be determined. Some native tokens have to be sent to that unauthorizable account to cover the deployment transaction fee. Then anyone can broadcast the already signed transaction to the blockchain.

Gas used for the Create3Factory deployment transaction is around **73250**. So the gas limit has been set to **90000** in the transaction to accommodate potential future rises in opcode costs. And the gas fee has been set to **100 Gwei**. This is high for some blockchains but it is to ensure the contract is deployable on most blockchains.

The signed deployment transactions of the Create3Factory is:
```
0xf8b88085174876e80083015f908080b866605d8060093d393df3756d363d3d37363d34f03d5260203df33d52600e6012f33d52336020526004356040526060602c206016600a3df58061003b5760013d5260203dfd5b60203d6044358060643d373d34855af16100585760025f5260205ffd5b60205ff31ba08888888888888888888888888888888888888888888888888888888888888888a03333333333333333333333333333333333333333333333333333333333333333
```

The Create3Factory will be deployed to this address:
```
0x749b753DA5168F9d10a30Eb3394a3B852B4ec6c9
```

The signer address that signed the deployment transaction and we need to pay the transaction fee for:
```
0x77a9D56476897C82560f097fea5B2F965D58bE15
```


To deploy this contract to a blockchain if it isn't already deployed by someone, check [./script/deployFactory.js](https://github.com/SaTiSH-K-R/huff-create3-factory/blob/main/script/deployFactory.js) and replace the `rpcUrl` with the RPC URL of your preferred blockchain, and run the following command
```
node ./script/deployFactory.js
```

Once it is deployed to a blockchain, anyone can use it to deploy their contracts.

## Create3Factory usage

To deploy your contract with this Create3Factory, call the contract as following:
```
deploy(bytes32 salt, bytes creationCode)
```
`salt` - It needs to be same on all blockchains to deploy your contract at the same address.
`creationCode` - it is the bytecode of your contract along with the arguments.




<img align="right" width="150" height="150" top="100" src="./assets/blueprint.png">

# huff-project-template • [![ci](https://github.com/huff-language/huff-project-template/actions/workflows/ci.yaml/badge.svg)](https://github.com/huff-language/huff-project-template/actions/workflows/ci.yaml) ![license](https://img.shields.io/github/license/huff-language/huff-project-template.svg) ![solidity](https://img.shields.io/badge/solidity-^0.8.15-lightgrey)

Versatile Huff Project Template using Foundry.


## Getting Started

### Requirements

The following will need to be installed in order to use this template. Please follow the links and instructions.

-   [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)  
    -   You'll know you've done it right if you can run `git --version`
-   [Foundry / Foundryup](https://github.com/gakonst/foundry)
    -   This will install `forge`, `cast`, and `anvil`
    -   You can test you've installed them right by running `forge --version` and get an output like: `forge 0.2.0 (92f8951 2022-08-06T00:09:32.96582Z)`
    -   To get the latest of each, just run `foundryup`
-   [Huff Compiler](https://docs.huff.sh/get-started/installing/)
    -   You'll know you've done it right if you can run `huffc --version` and get an output like: `huffc 0.3.0`

### Quickstart

1. Clone this repo or use template

Click "Use this template" on [GitHub](https://github.com/huff-language/huff-project-template) to create a new repository with this repo as the initial state.

Or run:

```
git clone https://github.com/huff-language/huff-project-template
cd huff-project-template
```

2. Install dependencies

Once you've cloned and entered into your repository, you need to install the necessary dependencies. In order to do so, simply run:

```shell
forge install
```

3. Build & Test

To build and test your contracts, you can run:

```shell
forge build
forge test
```

For more information on how to use Foundry, check out the [Foundry Github Repository](https://github.com/foundry-rs/foundry/tree/master/forge) and the [foundry-huff library repository](https://github.com/huff-language/foundry-huff).


## Blueprint

```ml
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
├─ foundry-huff — https://github.com/huff-language/foundry-huff
scripts
├─ Deploy.s.sol — Deployment Script
src
├─ SimpleStore — A Simple Storage Contract in Huff
test
└─ SimpleStore.t — SimpleStoreTests
```


## License

[The Unlicense](https://github.com/huff-language/huff-project-template/blob/master/LICENSE)


## Acknowledgements

- [forge-template](https://github.com/foundry-rs/forge-template)
- [femplate](https://github.com/abigger87/femplate)


## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._