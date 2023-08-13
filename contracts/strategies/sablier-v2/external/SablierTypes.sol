// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISablierV2Lockup {
    struct Broker {
        address account;
        uint256 fee;
    }

    struct Amounts {
        uint128 deposited;
        uint128 withdrawn;
        uint128 refunded;
    }

    function cancel(uint256 streamId) external;
    function nextStreamId() external view returns (uint256 streamId);
    function getEndTime(uint256 streamId) external view returns (uint40 endTime);
    function refundableAmountOf(uint256 streamId) external view returns (uint128 refundableAmount);
}

interface ISablierV2LockupDynamic is ISablierV2Lockup {
    struct Segment {
        uint128 amount;
        uint64 exponent;
        uint40 milestone;
    }

    struct SegmentWithDelta {
        uint128 amount;
        uint64 exponent;
        uint40 delta;
    }

    struct CreateWithDeltas {
        address sender;
        bool cancelable;
        address recipient;
        uint128 totalAmount;
        IERC20 asset;
        Broker broker;
        SegmentWithDelta[] segments;
    }

    struct Stream {
        address sender;
        uint40 startTime;
        uint40 endTime;
        bool isCancelable;
        bool wasCanceled;
        IERC20 asset;
        bool isDepleted;
        bool isStream;
        Amounts amounts;
        Segment[] segments;
    }

    function createWithDeltas(CreateWithDeltas calldata params) external returns (uint256 streamId);
    function getStream(uint256 streamId) external view returns (Stream memory stream);
}

interface ISablierV2LockupLinear is ISablierV2Lockup {
    struct Durations {
        uint40 cliff;
        uint40 total;
    }

    struct CreateWithDurations {
        address sender;
        address recipient;
        uint128 totalAmount;
        IERC20 asset;
        bool cancelable;
        Durations durations;
        Broker broker;
    }

    struct Stream {
        address sender;
        uint40 startTime;
        uint40 cliffTime;
        bool isCancelable;
        bool wasCanceled;
        IERC20 asset;
        uint40 endTime;
        bool isDepleted;
        bool isStream;
        Amounts amounts;
    }

    function createWithDurations(CreateWithDurations calldata params) external returns (uint256 streamId);
    function getStream(uint256 streamId) external view returns (Stream memory stream);
}
