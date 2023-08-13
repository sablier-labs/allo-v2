pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Test} from "forge-std/Test.sol";

import {ISablierV2Lockup} from "../../../../contracts/strategies/sablier-v2/external/SablierTypes.sol";

import {Accounts} from "../../shared/Accounts.sol";
import {EventSetup} from "../../shared/EventSetup.sol";
import {AlloSetup} from "../../shared/AlloSetup.sol";
import {RegistrySetupFull} from "../../shared/RegistrySetup.sol";

import {Allo} from "../../../../contracts/core/Allo.sol";
import {Metadata} from "../../../../contracts/core/libraries/Metadata.sol";

contract LockupBase_Test is Test, Accounts, EventSetup, RegistrySetupFull, AlloSetup {
    event PoolFunded(uint256 indexed poolId, uint256 amount, uint256 fee);

    IERC20 internal GTC = IERC20(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);

    ISablierV2Lockup.Broker internal broker = ISablierV2Lockup.Broker({account: pool_manager1(), fee: 0.01e18});
    Metadata internal poolMetadata = Metadata({protocol: 1, pointer: "PoolMetadata"});
    Metadata internal strategyMetadata = Metadata({protocol: 2, pointer: "StrategyMetadata"});
    bool internal useRegistryAnchor = false;

    function setUp() public virtual {
        vm.createSelectFork({blockNumber: 17_787_058, urlOrAlias: "mainnet"});

        __RegistrySetupFull();
        __AlloSetup(address(registry()));

        vm.label(address(allo()), "Allo");
    }

    function __StrategySetup(address strategy, bytes memory data) internal returns (uint256 poolId) {
        poolId = allo().createPoolWithCustomStrategy(
            poolProfile_id(), strategy, data, address(GTC), 0, poolMetadata, pool_managers()
        );
    }

    /// ===============================
    /// ========== Helpers ============
    /// ===============================

    function assertEq(ISablierV2Lockup.Broker memory a, ISablierV2Lockup.Broker memory b) internal {
        assertEq(a.account, b.account, "broker.account");
        assertEq(a.fee, b.fee, "broker.fee");
    }
}
