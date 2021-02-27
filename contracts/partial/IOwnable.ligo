type storage is record [
  nft_token_address: address;
  owner: address;
//   callbackContract: contract(bool);
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

type balance_of_request is [@layout:comb] record [
  owner : address;
  token_id : nat;
]

type balance_of_response is [@layout:comb] record [
  request : balance_of_request;
  balance : nat;
]

type balance_params is [@layout:comb] record [
  requests : list(balance_of_request);
  callback : contract(list(balance_of_response));
]

type balance_of_type is BalanceOfType of balance_params

type balance_of_response_type is BalanceOfResponseType of contract(list(balance_of_response))

type actions is
| GetOwner of contract(address)
| IsOwner of address * contract(bool)
| IsOwnerCallback of list(balance_of_response)
| RenounceOwnership of unit
| TransferOwnership of address

[@inline] const noOperations : list(operation) = nil;
[@inline] const zeroAddress : address = ("tz1ZZZZZZZZZZZZZZZZZZZZZZZZZZZZNkiRg" : address);
