// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {GoldV1} from "../src/GoldV1.sol";
import {GoldV2} from "../src/GoldV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployGold} from "../script/DeployGold.s.sol";
import {UpgradeGold} from "../script//UpgradeGold.s.sol";

contract DeployAndUpgradeTest is Test {
    DeployGold public deployer;
    UpgradeGold public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function setUp() public {
        deployer = new DeployGold();
        upgrader = new UpgradeGold();
        proxy = deployer.run();
        vm.deal(OWNER, 1 ether);
    }

    function testProxyStakingV1() public {
        vm.startPrank(OWNER);
        GoldV1(proxy).staking{value: 0.01 ether}();
        uint256 stakingAmount = GoldV1(proxy).getStakerAmount(OWNER);
        console.log(stakingAmount);
        assertEq(stakingAmount, 0.01 ether);
    }

    function testProxyGoldV1() public view {
        uint256 version = GoldV1(proxy).version();
        console.log(version);
        uint256 expectedVersion = 1;
        assertEq(version, expectedVersion);
    }

    function testProxyStartsAGoldV1() public {
        vm.expectRevert();
        GoldV2(proxy).setNumber(7);
    }

    function testUprade() public {
        GoldV2 goldV2 = new GoldV2();

        upgrader.upgradeGold(proxy, address(goldV2));

        uint256 expectedValue = 2;

        assertEq(expectedValue, GoldV2(proxy).version());

        GoldV2(proxy).setNumber(50 ether);

        console.log(GoldV1(proxy).getNumber());

        assertEq(50 ether, GoldV1(proxy).getNumber());
    }
}
