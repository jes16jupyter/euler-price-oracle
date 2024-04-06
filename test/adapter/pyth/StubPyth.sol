// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.23;

import {PythStructs} from "@pyth/PythStructs.sol";

contract StubPyth {
    PythStructs.Price price;
    bool doRevert;
    string revertMsg = "oops";

    function setPrice(PythStructs.Price memory _price) external {
        price = _price;
    }

    function setRevert(bool _doRevert) external {
        doRevert = _doRevert;
    }

    function getPriceNoOlderThan(bytes32, uint256) external view returns (PythStructs.Price memory) {
        if (doRevert) revert(revertMsg);
        return price;
    }

    function updatePriceFeeds(bytes[] calldata) external payable {
        if (doRevert) revert(revertMsg);
    }
}