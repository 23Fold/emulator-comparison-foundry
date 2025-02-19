// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {ERC20UpgradeableV1} from "../src/ERC20UpgradeableV1.sol";
import {ERC20UpgradeableV2} from "../src/ERC20UpgradeableV2.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract BeaconUpgrades is Script {
    UpgradeableBeacon public beacon;
    address public tokenProxy1;
    address public tokenProxy2;
    address randomRecipient = 0x11146B226dBBa8230CF620635A1e4Ab01F6A99B2;
    uint256 amount = 1 ether;

    function setUp() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.envAddress("DEPLOYER");
        vm.startBroadcast(deployerPrivateKey);

        address beaconAddress = Upgrades.deployBeacon("ERC20UpgradeableV1.sol", deployer);
        beacon = UpgradeableBeacon(beaconAddress);
        console.log("Beacon deployed at:", address(beacon));

        tokenProxy1 = Upgrades.deployBeaconProxy(beaconAddress, abi.encodeCall(ERC20UpgradeableV1.initialize, ()));
        console.log("Proxy deployed at:", address(tokenProxy1));

        tokenProxy2 = Upgrades.deployBeaconProxy(beaconAddress, abi.encodeCall(ERC20UpgradeableV1.initialize, ()));
        console.log("Proxy deployed at:", address(tokenProxy2));

        vm.stopBroadcast();
    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console.log("====== Makes 10 transfers with the initial token ======");
        for (uint256 i = 0; i < 10; i++) {
            ERC20UpgradeableV1(tokenProxy1).transfer(randomRecipient, amount);
        }

        console.log("====== Upgrades the proxies ======");
        Upgrades.upgradeBeacon(address(beacon), "ERC20UpgradeableV2.sol");

        console.log("===== Calling the new function on the proxies ======");
        ERC20UpgradeableV2(tokenProxy1).mintMore(amount);
        ERC20UpgradeableV2(tokenProxy2).mintMore(amount);

        vm.stopBroadcast();
    }
}
