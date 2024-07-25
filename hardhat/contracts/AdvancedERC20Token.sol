// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AdvancedERC20Token
 * @dev This contract implements an ERC20 token with additional features:
 * - Gasless transactions (ERC20Permit)
 * - Multi-send functionality (Multicall)
 * - Burnable tokens (ERC20Burnable)
 * - Pausable transfers (ERC20Pausable)
 * - Token balance snapshots (ERC20Snapshot)
 */
contract AdvancedERC20Token is ERC20, ERC20Permit, ERC20Burnable, ERC20Pausable, ERC20Snapshot, Multicall, Ownable {
    uint256 private immutable _maxSupply;

    /**
     * @dev Constructor to initialize the token with name, symbol, and max supply
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     * @param maxSupply_ The maximum supply of the token
     */
    constructor(string memory name_, string memory symbol_, uint256 maxSupply_) 
        ERC20(name_, symbol_)
        ERC20Permit(name_)
        Ownable()
    {
        _maxSupply = maxSupply_;
        _mint(msg.sender, maxSupply_);
    }

    /**
     * @dev Creates a new snapshot and returns its snapshot id.
     * @return The id of the newly created snapshot.
     */
    function snapshot() public onlyOwner returns (uint256) {
        return _snapshot();
    }

    /**
     * @dev Pauses all token transfers.
     * @notice Can only be called by the contract owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     * @notice Can only be called by the contract owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Returns the maximum supply of tokens.
     * @return The maximum supply of tokens.
     */
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    /**
     * @dev Hook that is called before any transfer of tokens.
     * @param from The address tokens are transferred from
     * @param to The address tokens are transferred to
     * @param amount The amount of tokens to be transferred
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Pausable, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Hook that is called after any transfer of tokens.
     * @param from The address tokens are transferred from
     * @param to The address tokens are transferred to
     * @param amount The amount of tokens transferred
     */
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20)
    {
        super._afterTokenTransfer(from, to, amount);
    }
}