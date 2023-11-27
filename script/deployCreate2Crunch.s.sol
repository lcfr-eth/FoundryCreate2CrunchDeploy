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

    function run() public returns(address created) {
        
        uint256 number   = vm.envUint("NUMBER");
        bytes32 salt     = vm.envBytes32("SALT");      // salt from create2crunch
        address deployTo = vm.envAddress("DEPLOY_TO"); // the should-be deploy address derived from the provided salt

        Counter counter = new Counter{salt: salt}(number);
        address created = address(counter);
        if(created != deployTo) {
            revert("deployed address does not match expected address");
        }
    }
}

