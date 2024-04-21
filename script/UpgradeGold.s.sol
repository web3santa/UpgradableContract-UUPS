// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GoldV1} from "../src/GoldV1.sol";
import {GoldV2} from "../src/GoldV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeGold is Script {
    function run() external returns (address) {
        address msgRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        GoldV2 newGold = new GoldV2();
        vm.stopBroadcast();
        address proxy = upgradeGold(msgRecentlyDeployed, address(newGold));

        return proxy;
    }

    function upgradeGold(address proxyAddress, address newGold) public returns (address) {
        vm.startBroadcast();
        GoldV1 proxy = GoldV1(proxyAddress);
        proxy.upgradeToAndCall(address(newGold), ""); // proxy contract now points new contract

        vm.stopBroadcast();
        return address(proxy);
    }
}
