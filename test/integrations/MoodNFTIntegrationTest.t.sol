// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "src/MoodNFT.sol";
import {DeployMoodNFT} from "script/DeployMoodNFT.s.sol";

contract MoodNFTIntegrationTest is Test {
    MoodNFT moodNFT;
    DeployMoodNFT deployer;

    string public constant SAD_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxwYXRoIGZpbGw9IiMzMzMiCiAgICAgICAgZD0iTTUxMiA2NEMyNjQuNiA2NCA2NCAyNjQuNiA2NCA1MTJzMjAwLjYgNDQ4IDQ0OCA0NDggNDQ4LTIwMC42IDQ0OC00NDhTNzU5LjQgNjQgNTEyIDY0em0wIDgyMGMtMjA1LjQgMC0zNzItMTY2LjYtMzcyLTM3MnMxNjYuNi0zNzIgMzcyLTM3MiAzNzIgMTY2LjYgMzcyIDM3Mi0xNjYuNiAzNzItMzcyIDM3MnoiIC8+CiAgICA8cGF0aCBmaWxsPSIjRTZFNkU2IgogICAgICAgIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiIC8+CiAgICA8cGF0aCBmaWxsPSIjMzMzIgogICAgICAgIGQ9Ik0yODggNDIxYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHptMjI0IDExMmMtODUuNSAwLTE1NS42IDY3LjMtMTYwIDE1MS42YTggOCAwIDAgMCA4IDguNGg0OC4xYzQuMiAwIDcuOC0zLjIgOC4xLTcuNCAzLjctNDkuNSA0NS4zLTg4LjYgOTUuOC04OC42czkyIDM5LjEgOTUuOCA4OC42Yy4zIDQuMiAzLjkgNy40IDguMSA3LjRINjY0YTggOCAwIDAgMCA4LTguNEM2NjcuNiA2MDAuMyA1OTcuNSA1MzMgNTEyIDUzM3ptMTI4LTExMmE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6IiAvPgo8L3N2Zz4=";
    string public constant HAPPY_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHRoZSBvd25lcnMgbW9vZC4iLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibW9vZGluZXNzIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlNVEF5TkhCNElpQm9aV2xuYUhROUlqRXdNalJ3ZUNJZ2RtbGxkMEp2ZUQwaU1DQXdJREV3TWpRZ01UQXlOQ0lnZUcxc2JuTTlJbWgwZEhBNkx5OTNkM2N1ZHpNdWIzSm5Mekl3TURBdmMzWm5JajRLSUNBZ0lEeHdZWFJvSUdacGJHdzlJaU16TXpNaUNpQWdJQ0FnSUNBZ1pEMGlUVFV4TWlBMk5FTXlOalF1TmlBMk5DQTJOQ0F5TmpRdU5pQTJOQ0ExTVRKek1qQXdMallnTkRRNElEUTBPQ0EwTkRnZ05EUTRMVEl3TUM0MklEUTBPQzAwTkRoVE56VTVMalFnTmpRZ05URXlJRFkwZW0wd0lEZ3lNR010TWpBMUxqUWdNQzB6TnpJdE1UWTJMall0TXpjeUxUTTNNbk14TmpZdU5pMHpOeklnTXpjeUxUTTNNaUF6TnpJZ01UWTJMallnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUlETTNNbm9pSUM4K0NpQWdJQ0E4Y0dGMGFDQm1hV3hzUFNJalJUWkZOa1UySWdvZ0lDQWdJQ0FnSUdROUlrMDFNVElnTVRRd1l5MHlNRFV1TkNBd0xUTTNNaUF4TmpZdU5pMHpOeklnTXpjeWN6RTJOaTQySURNM01pQXpOeklnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUxURTJOaTQyTFRNM01pMHpOekl0TXpjeWVrMHlPRGdnTkRJeFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEazJJREFnTkRndU1ERWdORGd1TURFZ01DQXdJREV0T1RZZ01IcHRNemMySURJM01tZ3RORGd1TVdNdE5DNHlJREF0Tnk0NExUTXVNaTA0TGpFdE55NDBRell3TkNBMk16WXVNU0ExTmpJdU5TQTFPVGNnTlRFeUlEVTVOM010T1RJdU1TQXpPUzR4TFRrMUxqZ2dPRGd1Tm1NdExqTWdOQzR5TFRNdU9TQTNMalF0T0M0eElEY3VORWd6TmpCaE9DQTRJREFnTUNBeExUZ3RPQzQwWXpRdU5DMDROQzR6SURjMExqVXRNVFV4TGpZZ01UWXdMVEUxTVM0MmN6RTFOUzQySURZM0xqTWdNVFl3SURFMU1TNDJZVGdnT0NBd0lEQWdNUzA0SURndU5IcHRNalF0TWpJMFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEQXRPVFlnTkRndU1ERWdORGd1TURFZ01DQXdJREVnTUNBNU5ub2lJQzgrQ2lBZ0lDQThjR0YwYUNCbWFXeHNQU0lqTXpNeklnb2dJQ0FnSUNBZ0lHUTlJazB5T0RnZ05ESXhZVFE0SURRNElEQWdNU0F3SURrMklEQWdORGdnTkRnZ01DQXhJREF0T1RZZ01IcHRNakkwSURFeE1tTXRPRFV1TlNBd0xURTFOUzQySURZM0xqTXRNVFl3SURFMU1TNDJZVGdnT0NBd0lEQWdNQ0E0SURndU5HZzBPQzR4WXpRdU1pQXdJRGN1T0MwekxqSWdPQzR4TFRjdU5DQXpMamN0TkRrdU5TQTBOUzR6TFRnNExqWWdPVFV1T0MwNE9DNDJjemt5SURNNUxqRWdPVFV1T0NBNE9DNDJZeTR6SURRdU1pQXpMamtnTnk0MElEZ3VNU0EzTGpSSU5qWTBZVGdnT0NBd0lEQWdNQ0E0TFRndU5FTTJOamN1TmlBMk1EQXVNeUExT1RjdU5TQTFNek1nTlRFeUlEVXpNM3B0TVRJNExURXhNbUUwT0NBME9DQXdJREVnTUNBNU5pQXdJRFE0SURRNElEQWdNU0F3TFRrMklEQjZJaUF2UGdvOEwzTjJaejQ9In0=";

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployMoodNFT();
        moodNFT = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNFT.mintNFT();
        console.log(moodNFT.tokenURI(0));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNFT.mintNFT();

        vm.prank(USER);
        moodNFT.flipMood(0);

        assertEq(
            keccak256(abi.encodePacked(moodNFT.tokenURI(0))),
            keccak256(abi.encodePacked(SAD_SVG_URI))
        );
    }
}
