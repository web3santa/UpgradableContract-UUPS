// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GoldV1} from "../src/GoldV1.sol";
import {GoldV2} from "../src/GoldV2.sol";

contract DeployGold is Script {
    function run() external returns (GoldV1, GoldV2) {
        vm.startBroadcast();
        GoldV1 goldV1 = new GoldV1();
        GoldV2 goldV2 = new GoldV2();
        vm.stopBroadcast();

        return (goldV1, goldV2);
    }
}
