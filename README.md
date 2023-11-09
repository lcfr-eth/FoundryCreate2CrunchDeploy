## Foundry Create2Crunch deployment

#### script/getInitHash.s.sol
```
$ forge script script/getInitHash.s.sol --private-key $PK
[⠢] Compiling...
No files changed, compilation skipped
Script ran successfully.
Gas used: 30951

== Logs ==
  Init Hash:
  0x2d6082c39da9176ae2d130ec5a76e2b6d22e9e6711cdadc540c4d40b67c5fd3a
  Factory Address: 0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519

```

#### create2crunch
```
export INIT_HASH=0x2d6082c39da9176ae2d130ec5a76e2b6d22e9e6711cdadc540c4d40b67c5fd3a
export FACTORY=0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
export PK=0xAAAA
export DEPLOYER=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 <- address of $PK

git clone https://github.com/0age/create2crunch.git
cd create2crunch

cargo run --release $FACTORY $DEPLOYER $INIT_HASH 0 6 7
0xf39fd6e51aad88f6f4ce6ab8827279cfffb922668f53e4e4a7b52f0128c2261a => 0x00000000F3552BB63542D1E03253Dc24AE4F1918 => 256 (4 / 4)
```

#### script/deployCreate2Crunch.s.sol
```
export PK=0xAAAA
export DEPLOY_TO=0x00000000F3552BB63542D1E03253Dc24AE4F1918
export SALT=0xf39fd6e51aad88f6f4ce6ab8827279cfffb922668f53e4e4a7b52f0128c2261a

forge script script/deployCreate2.s.sol -vv --private-key $PK
...
== Return ==
created: address 0x00000000F3552BB63542D1E03253Dc24AE4F1918
```

