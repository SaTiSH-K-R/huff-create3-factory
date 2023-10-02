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

    bytes SimpleStoreBytecode = hex"602d8060093d393df35f3560e01c8063552410771461001e5780632096525514610024575f5ffd5b6004355f555b5f545f5260205ff3";

    /// @dev Setup the testing environment.
    function setUp() public {
        factory = Create3Factory(HuffDeployer.deploy("Create3Factory"));
    }

    /// @dev Ensure getDeterministicAddress() returns address
    function testGetDeterministicAddress(bytes32 salt) public {
        address addr = factory.getDeterministicAddress(salt);
        console.log(string(abi.encodePacked(salt)));
        console.log(addr);
    }

    /// @dev Ensure given contract deploys to the deterministic address
    function testDeploy() public {
        address addr = factory.getDeterministicAddress(hex"02");
        require(addr.code.length == 0);
        factory.deploy(hex"01", SimpleStoreBytecode);
        console.log(addr);
    }
    
}