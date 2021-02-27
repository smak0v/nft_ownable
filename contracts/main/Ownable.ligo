#include "../partial/IOwnable.ligo"

type storage is record [
  nft_token_address: address;
]

type return is list(operation) * storage

type actions is
| IsOwner of address

[@inline] const noOperations : list(operation) = nil;

function isOwner(const addr : address; const s : storage) : return is
block {
    skip;
} with (noOperations, s)

function main(const action : actions; const s : storage) : return is
case action of
| IsOwner(v) -> isOwner(v, s)
end
