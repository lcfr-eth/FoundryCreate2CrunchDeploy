## Foundry Create2Crunch deployment

#### script/getInitHash.s.sol

```import "forge-std/Script.sol";
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
}```

#### script/deployCreate2Crunch.s.sol

```
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "src/Counter.sol";

/* 
export INIT_HASH=0x2d6082c39da9176ae2d130ec5a76e2b6d22e9e6711cdadc540c4d40b67c5fd3a
export FACTORY=0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
export PK=0xAAAA
export DEPLOYER=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 <- address of $PK

git clone https://github.com/0age/create2crunch.git
cd create2crunch

cargo run --release $FACTORY $DEPLOYER $INIT_HASH 0 6 7
0xf39fd6e51aad88f6f4ce6ab8827279cfffb922668f53e4e4a7b52f0128c2261a => 0x00000000F3552BB63542D1E03253Dc24AE4F1918 => 256 (4 / 4)

export DEPLOY_TO=0x00000000F3552BB63542D1E03253Dc24AE4F1918
export SALT=0xf39fd6e51aad88f6f4ce6ab8827279cfffb922668f53e4e4a7b52f0128c2261a

forge script script/deployCreate2.s.sol -vv --private-key $PK
...
== Return ==
created: address 0x00000000F3552BB63542D1E03253Dc24AE4F1918
*/

contract deployCreate2 is Script {

    function computeAddress(bytes32 salt, bytes32 creationCodeHash) public view returns (address addr) {
        address contractAddress = address(this);
        assembly {
            let ptr := mload(0x40)

            mstore(add(ptr, 0x40), creationCodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, contractAddress)
            let start := add(ptr, 0x0b)
            mstore8(start, 0xff)
            addr := keccak256(start, 85)
        }
    }

    function run() public returns(address created) {
        
        uint256 number   = vm.envUint("NUMBER");
        bytes32 salt     = vm.envBytes32("SALT");      // salt from create2crunch
        address deployTo = vm.envAddress("DEPLOY_TO"); // the should-be deploy address derived from the provided salt

        bytes memory initCode = type(Counter).creationCode;

        // constructor arguments are abi encoded and appended to the initCode
        bytes memory createCode = abi.encodePacked(initCode, abi.encode(number));

        // prevent deployment if addresses do not match
        address computed = computeAddress(salt, keccak256(createCode));
        require(computed == deployTo, "Computed address does not match deployTo address");

        assembly {
            created := create2(
                callvalue(),            // initial funding amount
                add(createCode, 0x20),  // pointer to init code - first 32 bytes are the length of the init code
                mload(createCode),      // size of init code
                salt                    // salt for create2 - passed in from env
            )
        }
    }
}
```

