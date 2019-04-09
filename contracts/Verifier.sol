pragma solidity ^0.4.14;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() internal returns (G1Point) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() internal returns (G2Point) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.add(p.negate()) should be zero.
    function negate(G1Point p) internal returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function add(G1Point p1, G1Point p2) internal returns (G1Point r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.mul(1) and p.add(p) == p.mul(2) for all points p.
    function mul(G1Point p, uint s) internal returns (G1Point r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point a1, G2Point a2, G1Point b1, G2Point b2) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point a1, G2Point a2,
            G1Point b1, G2Point b2,
            G1Point c1, G2Point c2,
            G1Point d1, G2Point d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() internal returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point([0x11cdfdd85c8506e01b1013980776315a6d861d5505fe3b2d70ca66646f08adea, 0x1d831f34d31e8094f09b7fd8249f545073ef3f8d1038bf71248529a143fdebf3], [0x17ec9e42908c8624c32dcdb7b76c64acf53b6d4ee72444d3a7c1fe8e00f5d7fa, 0x2fbea9b20d6443c407819f819e0ade7a07c030e9f62894dbf92dad1a55a1614d]);
        vk.B = Pairing.G1Point(0x10cf27740851709989f00203df5525ecc3577bf044eadef05037453b95c35f40, 0x224686b18747c89d9bef1039e945efb497ee7ff669011c14c6ca3a7778578324);
        vk.C = Pairing.G2Point([0xd02131a4f3d1f61e40b25666540d93b7db79f76fa35f0f9d7a75ac2a4e23856, 0x4fb6e315e432313cdb9fbce5660354dd6fb56432b7efa72f8bf9c38cd750ef1], [0x1ae71edad4c83cda00b5a545e3f530f15fff83863d2db70b47f1a640c3c4f154, 0x224004ca2456ac33a7f1c9594b9b30f31370f432907ac4b5e72664b74254b9a7]);
        vk.gamma = Pairing.G2Point([0x16375cb516444080a3d506e3ccda9f36a9b533d32732600125fe23b95d424719, 0x14b036bf21e18810e6b3549f868b9897c1bc0a5a50b17a3b2a0db67215795254], [0x261fbb7c90d8f47bb64b866d8be09b66d5b074f1ca7329310473dc7eaf167eb3, 0x2c05775885afcb722cd4d7c832a6d00b08d108697b044d2ac05ab595dfcf6f1a]);
        vk.gammaBeta1 = Pairing.G1Point(0x1b86641088fe2985bd3c4b1195e7792ae61314561a20bd28622a3b10716d5b79, 0x272f35e571a9c28f54c969a0e093f3e2d92962857f67bdf6122e98b14389153);
        vk.gammaBeta2 = Pairing.G2Point([0x961ab4f5fd50c437b4aace5efda67eb910235662a3e1d4f4c07073361ad8c14, 0x16585be5bc76e6fb26750d0361efc293ff7ce6fe63d40efa936dcda52e89d88a], [0x12d8cc318710026ebdd483d4a8e26951e7728682195488aa8231d33ce55a7211, 0x1babe275048dbabbda7200de77538ba582abc0857030ddeef52ea64c31406d8a]);
        vk.Z = Pairing.G2Point([0x1532128acd3ae189f8cac212620f6e93a47da24350534a5383804e18b7ec4497, 0x2014cf88774f460a6f003dd1a4d6e40db890de1ca4694219ea1245041f73be03], [0xd368d63297b3ee0e42219e1b938555a3d7d2249937bc683f195043803590583, 0x1278c675d5eecfde121e1d95ac0b1f8c8a6fa920f176f016893acebecdf478e5]);
        vk.IC = new Pairing.G1Point[](3);
        vk.IC[0] = Pairing.G1Point(0x10682c32b1cbdd9d48d08ba6397853ae73ee82dfc2441dd345922460cc78d508, 0x2fc117c0cdb41a93bdf87416122359c6d065f689c02f08d9d86924e8d0328d77);
        vk.IC[1] = Pairing.G1Point(0x2188a0de08297f728150224fe8a0796a17d7499d5f774b9b765b324cfbbb2ea9, 0x2ceb95f152b45bd36d8662e0d211d1b3fc912fe6935ec400d7e2fb5d7c27e3da);
        vk.IC[2] = Pairing.G1Point(0x13c07e1ab1bd0dc50a121c54b1774d758c9eebb83673f728678a92528253832c, 0xe38e2d5cfc5c4e6b4f63e5e4e1496b86fd8b627c78af3e130cda3ad5c6f328d);
    }
    function verify(uint[] input, Proof proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.add(vk_x, Pairing.mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.add(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.add(vk_x, Pairing.add(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.add(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    event Verified(string);
    function verifyTx(
            uint[2] a,
            uint[2] a_p,
            uint[2][2] b,
            uint[2] b_p,
            uint[2] c,
            uint[2] c_p,
            uint[2] h,
            uint[2] k,
            uint[2] input
        ) returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}