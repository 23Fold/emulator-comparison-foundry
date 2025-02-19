// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";

/**
 * @title MyERC20Token
 * @dev This is a basic ERC20 token using the OpenZeppelin's ERC20PresetFixedSupply preset.
 * You can edit the default values as needed.
 */
contract ERC20UpgradeableV1 is ERC20BurnableUpgradeable {
    function initialize() public initializer {
        __ERC20_init("DefaultTokenName", "DTN");
        __ERC20Burnable_init();

        // Default initial supply of 1 million tokens (with 18 decimals)
        uint256 initialSupply = 1_000_000 ether;

        // The initial supply is minted to the deployer's address
        _mint(msg.sender, initialSupply);
    }
}
