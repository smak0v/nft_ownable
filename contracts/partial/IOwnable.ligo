type storage is record [
  nft_token_address: address;
  owner: address;
]

type return is list(operation) * storage

type transfer_destination is [@layout:comb] record [
  to_ : address;
  token_id : nat;
  amount : nat;
]

type transfer_param is [@layout:comb] record [
  from_ : address;
  txs : list(transfer_destination);
]

type transfer_params is list(transfer_param)
type transfer_type is TransferType of transfer_params

type actions is
| GetOwner of contract(address)
| IsOwner of address * contract(bool)
| RenounceOwnership of unit
| TransferOwnership of address

[@inline] const noOperations : list(operation) = nil;
[@inline] const zeroAddress : address = ("tz1ZZZZZZZZZZZZZZZZZZZZZZZZZZZZNkiRg" : address);
