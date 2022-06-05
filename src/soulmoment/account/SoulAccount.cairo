# SPDX-License-Identifier: MIT
# A modified version of OpenZeppelin Contracts for Cairo v0.1.0 (account/Account.cairo)
# The purpose is to issue SBT in the account contract

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.starknet.common.syscalls import get_contract_address
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.account.library import Account, AccountCallArray
from openzeppelin.introspection.ERC165 import ERC165

from src.soulmoment.library import SoulMoment

#
# Constructor
#

@constructor
func constructor{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(public_key: felt):
    let (self) = get_contract_address()
    Account.initializer(public_key)
    SoulMoment.initializer(public_key, 'SOULMOMENT', self)
    return ()
end

#
# Getters
#

@view
func get_public_key{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (res: felt):
    let (res) = Account.get_public_key()
    return (res=res)
end

@view
func get_nonce{
        syscall_ptr : felt*, 
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (res: felt):
    let (res) = Account.get_nonce()
    return (res=res)
end

@view
func supportsInterface{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    } (interfaceId: felt) -> (success: felt):
    let (success) = ERC165.supports_interface(interfaceId)
    return (success)
end

@view
func soul_moment{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    } (token_id: Uint256) -> (uri: felt):
    let (uri) = SoulMoment.tokenURI(token_id)
    return (uri)
end

@view
func count_soul_moment{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    } () -> (balance: Uint256):
    let (balance) = SoulMoment.balance()
    return (balance)
end

#
# Setters
#

@external
func set_public_key{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(new_public_key: felt):
    Account.set_public_key(new_public_key)
    return ()
end

@external
func mint_soul_moment{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(content: felt):
    Account.assert_only_self()
    SoulMoment.mint(content)
    return ()
end

@external
func burn_soul_moment{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(token_id: Uint256):
    Account.assert_only_self()
    SoulMoment.burn(token_id)
    return ()
end

#
# Business logic
#

@view
func is_valid_signature{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr,
        ecdsa_ptr: SignatureBuiltin*
    }(
        hash: felt,
        signature_len: felt,
        signature: felt*
    ) -> (is_valid: felt):
    let (is_valid) = Account.is_valid_signature(hash, signature_len, signature)
    return (is_valid=is_valid)
end

@external
func __execute__{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr,
        ecdsa_ptr: SignatureBuiltin*
    }(
        call_array_len: felt,
        call_array: AccountCallArray*,
        calldata_len: felt,
        calldata: felt*,
        nonce: felt
    ) -> (response_len: felt, response: felt*):
    let (response_len, response) = Account.execute(
        call_array_len,
        call_array,
        calldata_len,
        calldata,
        nonce
    )
    return (response_len=response_len, response=response)
end
