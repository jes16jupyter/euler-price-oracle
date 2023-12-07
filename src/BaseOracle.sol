// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {IEOracle} from "src/interfaces/IEOracle.sol";
import {IFactoryInitializable} from "src/interfaces/IFactoryInitializable.sol";
import {OracleDescription} from "src/lib/OracleDescription.sol";

abstract contract BaseOracle is IEOracle, IFactoryInitializable {
    address public governor;
    bool public initialized;

    event GovernorSet(address indexed oldGovernor, address indexed newGovernor);

    function initialize(address _governor) external {
        if (initialized) revert AlreadyInitialized();
        initialized = true;
        _setGovernor(_governor);
    }

    function transferGovernance(address newGovernor) external onlyGovernor {
        _setGovernor(newGovernor);
    }

    function renounceGovernance() external onlyGovernor {
        _setGovernor(address(0));
    }

    function finalized() external view returns (bool) {
        return initialized && governor == address(0);
    }

    function governed() external view returns (bool) {
        return initialized && governor != address(0);
    }

    function _setGovernor(address newGovernor) private {
        address oldGovernor = governor;
        governor = newGovernor;
        emit GovernorSet(oldGovernor, newGovernor);
    }

    modifier onlyGovernor() {
        if (msg.sender != governor) {
            revert CallerNotGovernor();
        }
        _;
    }
}
