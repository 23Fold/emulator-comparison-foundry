// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol";

contract Sepolia is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyERC20Token token = new MyERC20Token();
        console.log("Token deployed at:", address(token));

        address randomRecipient = 0x11146B226dBBa8230CF620635A1e4Ab01F6A99B2;
        uint256 amount = 1 ether;

        for (uint256 i = 0; i < 10; i++) {
            token.transfer(randomRecipient, amount);
        }

        console.log("Token transferred to random recipient:", randomRecipient);

        vm.stopBroadcast();
    }
}
