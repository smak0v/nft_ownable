const Ownable = artifacts.require("Ownable");

module.exports = async (deployer, _network, accounts) => {
  deployer.deploy(Ownable, "KT1P9DW7Z4zFsBV67AqP28JhnwttrVgc8i1Z");
};
