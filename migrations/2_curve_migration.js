var Curve = artifacts.require('./Curve.sol')

module.exports = function(deployer) {
  deployer.deploy(Curve)
}