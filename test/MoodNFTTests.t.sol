// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "src/MoodNFT.sol";

contract MoodNFTTests is Test {
    MoodNFT moodNFT;

    address USER = makeAddr("user");

    function setUp() public {
        //moodNFT = new MoodNFT(SAD_SVG_URI, HAPPY_SVG_URI);
    }

    // function testViewTokenURI() public {
    //     vm.prank(USER);
    //     moodNFT.mintNFT();
    //     console.log(moodNFT.tokenURI(0));
    // }
}
