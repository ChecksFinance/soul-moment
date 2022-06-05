# SPDX-License-Identifier: MIT
# Solumoment is a subset of the ERC721 contract.
# Also a modified version of OpenZeppelin Contracts for Cairo v0.1.0 (token/erc721/library.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_not_zero, assert_not_equal
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.uint256 import Uint256, uint256_check

from openzeppelin.security.safemath import SafeUint256
from openzeppelin.introspection.ERC165 import ERC165
from openzeppelin.introspection.IERC165 import IERC165
from openzeppelin.utils.constants import (
    IERC721_ID, IERC721_METADATA_ID
)

#
# Events
#

@event
func Transfer(from_: felt, to: felt, tokenId: Uint256):
end

@event
func Vertified(from_: felt, tokenId: Uint256):
end

#
# Storage
#
@storage_var
func ERC721_name_() -> (name: felt):
end

@storage_var
func ERC721_symbol_() -> (symbol: felt):
end

@storage_var
func ERC721_owner() -> (owner: felt):
end

@storage_var
func ERC721_balance() -> (balance: Uint256):
end

@storage_var
func ERC721_token_uri(token_id: Uint256) -> (token_uri: felt):
end

namespace SoulMoment:

    #
    # Initializer
    #

    func initializer{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }(
        name: felt, 
        symbol: felt,
        owner: felt
    ):
        ERC721_name_.write(name)
        ERC721_symbol_.write(symbol)
        ERC721_owner.write(owner)
        ERC165.register_interface(IERC721_ID)
        ERC165.register_interface(IERC721_METADATA_ID)
        return ()
    end

    #
    # Public functions
    #

    func name{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }() -> (name: felt):
        let (name) = ERC721_name_.read()
        return (name)
    end

    func symbol{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }() -> (symbol: felt):
        let (symbol) = ERC721_symbol_.read()
        return (symbol)
    end

    func balance{
        syscall_ptr : felt*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr
    }() -> (balance: Uint256):
        let (balance: Uint256) = ERC721_balance.read()
        return (balance)
    end

    func owner{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }() -> (owner: felt):
        let (owner) = ERC721_owner.read()
        return (owner)
    end

    func tokenURI{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(token_id: Uint256) -> (token_uri: felt):
        # if tokenURI is not set, it will throw error
        let (exists) = _exists(token_id)
        with_attr error_message("SoulMoment: URI query for nonexistent token"):
            assert exists = TRUE
        end

        let (token_uri) = ERC721_token_uri.read(token_id)
        return (token_uri)
    end

    func mint{
            pedersen_ptr: HashBuiltin*,
            syscall_ptr: felt*,
            range_check_ptr
        }(content: felt):
        with_attr error_message("SoulMoment: cannot mint with blank content"):
            assert_not_zero(content)
        end

        let (balance: Uint256) = ERC721_balance.read()
        let (token_id: Uint256) = SafeUint256.add(balance, Uint256(1, 0))
        let (owner) = ERC721_owner.read()

        ERC721_balance.write(token_id)
        ERC721_token_uri.write(token_id, content)
        Transfer.emit(0, owner, token_id)

        return ()
    end

    func burn{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(token_id: Uint256):
        alloc_locals
        with_attr error_message("SoulMoment: token_id is not a valid Uint256"):
            uint256_check(token_id)
        end
        let (owner) = ERC721_owner.read()

        # Clear approvals
        # _approve(0, token_id)

        # Decrease owner balance
        let (balance: Uint256) = ERC721_balance.read()
        let (new_balance: Uint256) = SafeUint256.sub_le(balance, Uint256(1, 0))
        ERC721_balance.write(new_balance)

        # Emit event
        Transfer.emit(owner, 0, token_id)
        return ()
    end

    func only_token_owner{
        pedersen_ptr: HashBuiltin*,
        syscall_ptr: felt*,
        range_check_ptr
    }(token_id: Uint256):
        uint256_check(token_id)
        let (caller) = get_caller_address()
        let (owner) = ERC721_owner.read()

        with_attr error_message("SoulMoment: caller is not the token owner"):
            assert caller = owner
        end

        return ()
    end

    #
    # Internal functions
    #

    func _exists{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(token_id: Uint256) -> (res: felt):
        let (res) = ERC721_token_uri.read(token_id)

        if res == 0:
            return (FALSE)
        else:
            return (TRUE)
        end
    end
end