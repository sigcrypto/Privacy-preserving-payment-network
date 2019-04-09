compilers = require('solc')

compilers.version()

const fs = require("fs");

web3 = require('web3');
web3.setProvider(new web3.providers.HttpProvider('http://localhost:9545'));

var input = { 'Curve.sol': fs.readFileSync('./contracts/Curve.sol').tostring(), 'Schnorr.sol': fs.readFileSync('./contracts/Schnorr.sol').tostring(), 'AOSRing.sol': fs.readFileSync('./contracts/AOSRing.sol').tostring() };

input = { 'altbn128.sol': fs.readFileSync('./contracts/altbn128.sol', 'utf8'), 'Curve.sol': fs.readFileSync('./contracts/Curve.sol', 'utf8'), 'Schnorr.sol': fs.readFileSync('./contracts/Schnorr.sol', 'utf8'), 'AOSRing.sol': fs.readFileSync('./contracts/AOSRing.sol', 'utf8') };

let compiledContract2 = compilers.compile({sources: input}, 1);
let abih = compiledContract2.contracts['AOSRing.sol:AOSRing'].interface;
let bytecode = '0x'+compiledContract2.contracts['AOSRing.sol:AOSRing'].bytecode;
let gasEstimate = web3.eth.estimateGas({data: bytecode});
VerificationContract = new web3.eth.Contract(JSON.parse(abih))

web3.eth.getAccounts().then(function(result) { accounts = result; });

VerificationContract.deploy({data:bytecode}).send({from:accounts[0],gas:4700000}).then(function(result){myContractv = result;});
VerificationContract.deploy({data:bytecode}).then(function(result){myContractv = result;});



var verified = myContractv.methods.Verify(pkeys,tees,seed,msg)

var verified = myContractv.methods.Verify(*key,msg)

key = ([(4736769376155797712790673386202513653242350772987735164122825588099447398720, 6381299869457137488110544368508253655313149514188860174440461865153312835407), (4135328692215136174585373128063994502952603785903138429077701997456471706946, 16837962373275107269390455899924496768800132085354724418944343671144115904346), (14045749198703946344211431427975666609074108092475518973003779253561116158572, 13182570889509744345824770188883564179335769880771315395606918547172963141788), (2127187442018842279363958124464851507582714631876375171710302877118335097887, 16245594568875398236627563959396103645246995344105700536232972962289072938328), (21259485517641597974148494057743563424874766954140166401432425347752847422540, 20743641836018910617709735079406110109783417611680609200675760315451278275639), (64192186744068120715981321732273963657940628308220657854617005134943990968, 10914481490116845121250742584816142297567092032837125367035418218606651159875), (1429244781638223298156172170314907740420369862935444321467837507223552511499, 10475944322227429732857550982302233560948806790785405732924775484030598302206), (9403651049211545609088896316219375127784905728551541220567721659689706636555, 17848610728902168610523772491266221720094577035249331180082162095999348128027), (4252605998537064129856801442786266708851271147467751761783208312846261829909, 7561943824917268385591042903930650194100995328083522590891742665994161218486), (12032831243960336493764624015068368753294578076007207933534731822135048790861, 4176220418619251715090568252697779106118569660379299134113868625940938059674)], ((12032831243960336493764624015068368753294578076007207933534731822135048790861, 4176220418619251715090568252697779106118569660379299134113868625940938059674), 9030773793851258311292858667442402831104863641366339817515617129760268751094))

SimpleStorage.deployed().then(function(instance){return instance.get.call();}).then(function(value){return value.toNumber()});


pkeys = [(15919178465658284791290614567045026072316117586171176959910955408305630424814, 20862240179941779579952403671011897721832795631590648515968155808823259599359), (12263681347099655438905381100874856608645004721148503214489577061302920241506, 19847418829839668139028052447354841445468725407574645029312521576458369504224), (10813593301238155074370015960266495291194768653192891104644416180358171551658, 2396391678565753908766409405486513608858690095163171311619037898198909283772), (11467812021688226569640975574185263272722758635594130332901253463924659152079, 7147190656755148275384304935125620163848660649281526857193204566651355475061)]

tees = [17295219026706455106440559988891500946081186893255795447711890744632941394756, 1701351690902391602549866201781550532531561118495125202308740376773027632256, 16693310973546042934786846426226545885775998743202786943306615944646085536673, 18462848855395219983947516677795782727531118148163022396154641934573798914863]

seed = 84048209158915971368649555460915598033817761664360986662798415771607281050685

msg = 110039333745769167789226831914307332660922089541558723825599930414555874