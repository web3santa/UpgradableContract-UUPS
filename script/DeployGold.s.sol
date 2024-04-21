// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GoldV1} from "../src/GoldV1.sol";
import {GoldV2} from "../src/GoldV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployGold is Script {
    function run() external returns (address) {
        address proxy = deployGod();

        return proxy;
    }

    function deployGod() public returns (address) {
        vm.startBroadcast();
        GoldV1 gold = new GoldV1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(gold), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
