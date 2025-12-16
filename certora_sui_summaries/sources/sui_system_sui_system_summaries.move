module certora::sui_system_sui_system_summaries;

use cvlm::manifest::{ summary, ghost };
use sui_system::sui_system::SuiSystemState;
use sui_system::sui_system_state_inner::SuiSystemStateInnerV2;

public fun cvlm_manifest() {
    summary(b"load_inner_maybe_upgrade", @sui_system, b"sui_system", b"load_inner_maybe_upgrade");
    ghost(b"the_system_state_inner_v2");
}

native fun the_system_state_inner_v2(): &mut SuiSystemStateInnerV2;

public fun load_inner_maybe_upgrade(_self: &mut SuiSystemState): &mut SuiSystemStateInnerV2 { 
    // SuiSystemState is a singleton, so we can just always return the same SuiSystemStateInnerV2 instance
    the_system_state_inner_v2() 
}
