const Ownable = artifacts.require("Ownable");

contract("Ownable", async () => {
  var instance;

  before("setup", async () => {
    const ownableStorage = {
      nft_token_address: "KT1P9DW7Z4zFsBV67AqP28JhnwttrVgc8i1Z",
      owner: "tz1ZZZZZZZZZZZZZZZZZZZZZZZZZZZZNkiRg",
    };

    instance = await Ownable.new(ownableStorage);
  });
});
