var SumsToFifteen = artifacts.require('./SumsToFifteen.sol')

module.exports = function(deployer) {
  deployer.deploy(SumsToFifteen)
}