// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft private basicNft;
    DeployBasicNft private deployer;

    address private USER = makeAddr("user");
    string public constant tokenUri =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameISCorrect() external view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
        assertEq(actualName, expectedName, "NFT name should be Dogie");
    }

    function testCanMintandHaveBalance() external {
        vm.startPrank(USER);
        basicNft.mintNft(tokenUri);
        vm.stopPrank();

        assertEq(basicNft.balanceOf(USER), 1, "User should have 1 NFT");
        assertEq(basicNft.tokenURI(0), tokenUri, "Token URI should match the minted URI");
    }
}
