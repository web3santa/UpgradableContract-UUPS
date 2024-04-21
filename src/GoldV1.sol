// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// storage is stored in the proxy, Not the implementation

// Proxy (borrowing funcs) => impmention (number =1)

// Proxy -> dpeloy implemtiation -> call some initialzer

contract GoldV1 is Initializable, ERC20Upgradeable, ERC20PermitUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal number;
    address[] internal staker;

    mapping(address staker => uint256 amount) internal s_stakingAmount;

    constructor() {
        _disableInitializers();
    }

    // proxy - implementation

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function staking() external payable {
        require(msg.value == 0.01 ether, "you need to staking 0.01ETH");
        staker.push(msg.sender);
        s_stakingAmount[msg.sender] += msg.value;
    }

    function getStakerAmount(address stakerAddress) external view returns (uint256) {
        return s_stakingAmount[stakerAddress];
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
