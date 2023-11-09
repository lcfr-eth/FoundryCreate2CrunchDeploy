pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "src/Counter.sol";

/*

using --private-key finds the next would be contract address deployed from the 
key to use as the Factory address for create2crunch

export NUMBER=1337
export PK=0xAAAA

$ forge script script/getInitHash.s.sol --private-key $PK
[⠢] Compiling...
No files changed, compilation skipped
Script ran successfully.
Gas used: 30951

== Logs ==
  Init Hash:
  0x2d6082c39da9176ae2d130ec5a76e2b6d22e9e6711cdadc540c4d40b67c5fd3a
  Factory Address: 0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519

*/

contract getInitHash is Script {

    function run() public view {

        uint256 number = vm.envUint("NUMBER");

        bytes memory initCode = type(Counter).creationCode;

        // constructor arguments are abi encoded and appended to the initCode
        bytes memory createCode = abi.encodePacked(initCode, abi.encode(number));

        bytes32 init = keccak256(abi.encodePacked(createCode));

        console.log("Init Hash:");
        console.logBytes32(init);
        console.log("Factory Address:", address(this));
    }
}
