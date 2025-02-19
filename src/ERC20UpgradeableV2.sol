// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20UpgradeableV1.sol";

/**
 * @title MyERC20Token
 * @dev This is a basic ERC20 token using the OpenZeppelin's preset.
 * You can edit the default values as needed.
 */
/// @custom:oz-upgrades-from ERC20UpgradeableV1
contract ERC20UpgradeableV2 is ERC20UpgradeableV1 {
    function mintMore(uint256 howMuch) public {
        _mint(msg.sender, howMuch);
    }
}
