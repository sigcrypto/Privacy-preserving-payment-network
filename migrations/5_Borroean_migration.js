var Borromean = artifacts.require('./Borromean.sol')

module.exports = function(deployer) {
  deployer.deploy(Borromean)
}