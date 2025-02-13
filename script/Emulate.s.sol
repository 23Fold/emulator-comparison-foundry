// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol";
import {TestExt} from "lib/forge-zksync-std/src/TestExt.sol";

contract Emulate is Script, TestExt {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        bytes memory paymaster_encoded_input = abi.encodeWithSelector(bytes4(keccak256("general(bytes)")), bytes("0x"));
        vmExt.zkUsePaymaster(vm.envAddress("PAYMASTER_ADDRESS"), paymaster_encoded_input);
        MyERC20Token token = new MyERC20Token();
        console.log("Token deployed at:", address(token));

        address randomRecipient = 0x11146B226dBBa8230CF620635A1e4Ab01F6A99B2;
        uint256 amount = 1 ether;

        for (uint256 i = 0; i < 10; i++) {
            // Encode paymaster input

            (bool success,) = address(vm).call(
                abi.encodeWithSignature(
                    "zkUsePaymaster(address,bytes)", vm.envAddress("PAYMASTER_ADDRESS"), paymaster_encoded_input
                )
            );
            require(success, "zkUsePaymaster() call failed");
            token.transfer(randomRecipient, amount);
        }

        console.log("Token transferred to random recipient:", randomRecipient);

        vm.stopBroadcast();
    }
}
