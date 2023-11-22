// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

interface Create3Factory {
    function deploy(bytes32,bytes memory) external returns(address);
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}

contract Create3FactoryTest is Test {

    /// @dev Address of the Create3Factory contract.
    Create3Factory public factory;

    bytes SIMPLE_STORE_BYTECODE = hex"602d8060093d393df35f3560e01c8063552410771461001e5780632096525514610024575f5ffd5b6004355f555b5f545f5260205ff3";
    bytes PROXY_CONTRACT_BYTECODE_HASH = hex"21c35dbe1b344a2488cf3321d6ce542f8e9f305544ff09e4993a62319a497c1f";

    /// @dev Setup the testing environment.
    function setUp() public {
        factory = Create3Factory(HuffDeployer.deploy("Create3Factory"));
    }
    
    /// @dev Ensure given contract deploys correctly
    function test_Deploy() public {
        address addr = factory.deploy(hex"02", SIMPLE_STORE_BYTECODE);
        console.log("Address::::", addr);
        require(addr.code.length > 0);
    }
    
    /// @dev Ensure deployed contract works as expected
    function test_DeployedContract() public {
        address addr = factory.deploy(hex"02", SIMPLE_STORE_BYTECODE);
        SimpleStore store = SimpleStore(addr);
        require(store.getValue() == 0);
        store.setValue(20);
        require(store.getValue() == 20);
    }
    
}