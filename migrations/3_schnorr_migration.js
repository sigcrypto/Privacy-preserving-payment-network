var Schnorr = artifacts.require('./Schnorr.sol')

module.exports = function(deployer) {
  deployer.deploy(Schnorr)
}