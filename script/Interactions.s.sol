// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "src/BasicNFT.sol";

contract MintBasicNFT is Script {
    string public constant WINNIE =
        "ipfs://QmUMrTuRCGwbGiAVzPgWzHzgTsXQQCuja5iyDBFSvpiQPA/?filename=winnie.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(WINNIE);
        vm.stopBroadcast();
    }
}
