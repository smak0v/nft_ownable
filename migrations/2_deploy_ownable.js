const Ownable = artifacts.require("Ownable");

module.exports = async (deployer, _network, accounts) => {
  deployer.deploy(Ownable, {
    nft_token_address: "KT1P9DW7Z4zFsBV67AqP28JhnwttrVgc8i1Z",
    owner: "tz1ZZZZZZZZZZZZZZZZZZZZZZZZZZZZNkiRg",
  });
};
