pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

interface Create3Factory {
    function getDeterministicAddress(bytes32) external returns (address);
    function deploy(bytes32,bytes memory) external;
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

    /// @dev Ensure getDeterministicAddress() returns address
    function testGetDeterministicAddress(bytes32 salt) public {
        address predeterminedAddress = factory.getDeterministicAddress(salt);
        address proxyAddress = address(uint160(uint256(
            keccak256(
                abi.encodePacked(
                    hex'ff',
                    address(factory),
                    salt,
                    PROXY_CONTRACT_BYTECODE_HASH
                )
            )
        )));
        address targetContractAddress = address(uint160(uint256(
            keccak256(
                abi.encodePacked(
                    hex"d6_94",
                    proxyAddress,
                    hex"01"
                )
            )
        )));
        require(predeterminedAddress == targetContractAddress);
    }
    
    /// @dev Ensure given contract deploys to the deterministic address
    function testDeploy(bytes32 salt) public {
        address addr = factory.getDeterministicAddress(salt);
        require(addr.code.length == 0);
        factory.deploy(salt, SIMPLE_STORE_BYTECODE);
        require(addr.code.length > 0);
        SimpleStore store = SimpleStore(addr);
        require(store.getValue() == 0);
        store.setValue(20);
        require(store.getValue() == 20);
    }
    
}