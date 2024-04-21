// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract GoldV2 is UUPSUpgradeable {
    uint256 internal number;
    address[] internal staker;

    mapping(address staker => uint256 amount) internal s_stakingAmount;

    function setNumber(uint256 _number) external {
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 2;
    }

    function staking() external payable {
        require(msg.value == 0.01 ether, "you need to staking 0.01ETH");
        staker.push(msg.sender);
        s_stakingAmount[msg.sender] += msg.value;
    }

    function getStakerAmount(address stakerAddress) external view returns (uint256) {
        return s_stakingAmount[stakerAddress];
    }

    function unStaking(uint256 amount) external {
        require(amount <= s_stakingAmount[msg.sender], "Need to mating staking amount of token");

        s_stakingAmount[msg.sender] -= amount;

        (bool success,) = address(msg.sender).call{value: amount}("");
        require(success, "error to unstaking");
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
