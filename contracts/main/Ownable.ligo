#include "../partial/IOwnable.ligo"

function getOwnableTokenTransferEntrypoint(const s : storage) : contract(transfer_type) is
case (Tezos.get_entrypoint_opt("%transfer", s.nft_token_address) : option(contract(transfer_type))) of
| Some(c) -> c
| None -> (failwith("getOwnableTokenTransferEntrypoint not found") : contract(transfer_type))
end;

function getOwnableTokenBalanceOfEntrypoint(const s : storage) : contract(balance_of_type) is
case (Tezos.get_entrypoint_opt("%balance_of", s.nft_token_address) : option(contract(balance_of_type))) of
| Some(c) -> c
| None -> (failwith("getOwnableTokenBalanceOfEntrypoint not found") : contract(balance_of_type))
end;

function transferOwnableToken(const addr : address; const s : storage) : operation is
block {
  const transferDestination : transfer_destination = record [
    to_ = addr;
    token_id = 0n;
    amount = 1n;
  ];
  const transferParam : transfer_param = record [
    from_ = Tezos.sender;
    txs = list [transferDestination];
  ];
  const operations = Tezos.transaction(
    TransferType(list [transferParam]),
    0mutez,
    getOwnableTokenTransferEntrypoint(s)
  );
} with operations

function getOwner(const contr : contract(address); const s : storage) : return is
(list [Tezos.transaction(s.owner, 0mutez, contr)], s)

function isOwner(const addr : address; const contr : contract(bool); const s : storage) : return is
block {
  var callback : contract(list(balance_of_response)) := nil;

  case (Tezos.get_entrypoint_opt("%isOwnerCallback", Tezos.self_address) : option(contract(list(balance_of_response)))) of
  | None -> failwith("Callback function not found")
  | Some(p) -> callback := p
  end;

  const balanceOfRequest : balance_of_request = record [
    owner = addr;
    token_id = 0n;
  ];
  const balanceParams : balance_params = record [
    requests = list [balanceOfRequest];
    callback = callback;
  ];
  const operations = list [Tezos.transaction(
    BalanceOfType(balanceParams),
    0mutez,
    getOwnableTokenBalanceOfEntrypoint(s)
  )];

  // s.callbackContract := contr;
} with (operations, s)

function isOwnerCallback(const response : list(balance_of_response); var s : storage) : return is
block {
  const head : option(balance_of_response) = List.head_opt(response);
  var isOwner : bool := False;

  case head of
  | None -> skip
  | Some(v) -> block {
    if v.balance = 1n then block {
      s.owner := v.request.owner;
      isOwner := True;
    } else
      skip;
  }
  end;

  // const operations = list [Tezos.transaction(
  //   isOwner,
  //   0mutez,
  //   s.callbackContract
  // )];
} with (noOperations, s)

function renounceOwnership(var s : storage) : return is
block {
  var operations := noOperations;

  if Tezos.sender =/= s.owner then
    failwith("Allowed only for owner")
  else block {
    operations := transferOwnableToken(zeroAddress, s) # operations;
    s.owner := zeroAddress;
  }
} with (operations, s)

function transferOwnership(const addr : address; var s : storage) : return is
block {
  var operations := noOperations;

  if addr = zeroAddress then
    failwith("Ownable: new owner is the zero address")
  else block {
    operations := transferOwnableToken(addr, s) # operations;
    s.owner := addr;
  }
} with (operations, s)

function main(const action : actions; const s : storage) : return is
case action of
| GetOwner(v) -> getOwner(v, s)
| IsOwner(v) -> isOwner(v.0, v.1, s)
| IsOwnerCallback(v) -> isOwnerCallback(v, s)
| RenounceOwnership(v) -> renounceOwnership(s)
| TransferOwnership(v) -> transferOwnership(v, s)
end
