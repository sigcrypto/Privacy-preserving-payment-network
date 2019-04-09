compile
migrate --reset  // if doesnot work do migrate --compile-all --reset
const instance = ECVerify.deployed();
web3.eth.getAccounts().then(function(result) { accounts = result; });
web3.eth.getBalance(accounts[0]).then(function(result){console.log(web3.utils.fromWei(result,"ether"))});
const BigNumber = web3.BigNumber;
const should = require('chai').use(require('chai-as-promised')).use(require('chai-bignumber')(BigNumber)).should();

const msg = Buffer.from('some data')
message = `0x${msg.toString('hex')}`
account = accounts[0]
const sig = web3.eth.sign(message, account)
const prefix = Buffer.from('\x19Ethereum Signed Message:\n');
utils = require('web3-utils')
const pmsg = web3.utils.sha3(Buffer.concat([prefix, Buffer.from(String(msg.length)), msg])).toString('hex')


//const signer = instance.methods.ecrecovery(pmsg,sig)
//const signer = instance.ecrecovery(pmsg, sig)

compiler = require('solc')
sourceCodev = fs.readFileSync('./contracts/ECVerify.sol').toString();
compilerCodev = compiler.compile(sourceCodev)

compilerCodev.contracts[':ECVerify']
VerificationInterface = JSON.parse(compilerCodev.contracts[':ECVerify'].interface)
VerificationBytecode = compilerCodev.contracts[':ECVerify'].bytecode
VerificationContract = new web3.eth.Contract(VerificationInterface)
VerificationContract.deploy({data:VerificationBytecode}).send({from:accounts[0],gas:4700000}).then(function(result){myContractv = result;});

var verified = myContractv.methods.ecrecovery(pmsg,sig)
//verified.shouldg.be.equal(account,'The recovered address should match the signing address')

var verifiedbool = myContractv.methods.ecverify(pmsg,sig,account)
const result = verifiedbool._method.constant
web3.eth.getBalance(accounts).then(function(result){console.log(web3.utils.fromWei(result,"ether"))});





PythonShell.run('Ring_Signature.py', function (err) {
    if (err) throw err;
    console.log('finished');
  });

  ps.PythonShell.run('/home/cryptoresearch/Pictures/Final_sign_and_verify/test/Ring_Signature.py',null, function (err, results))

  ps.PythonShell.run('/home/cryptoresearch/Pictures/Final_sign_and_verify/test/Ring_Signature.py', null, function (err, results){
    if (err) throw err;
    console.log('finished');
    console.log(results);
  });