from __future__ import print_function
// https://github.com/HarryR/solcrypto

from altbn128 import *
from schnorr import *
from utils import *

def aosring_randkeys(n=4):
	skeys = [randsn() for _ in range(0, n)]
	pkeys = [sbmul(sk) for sk in skeys]
	#print(pkeys)
	i = randint(0, n-1)
	return pkeys, (pkeys[i], skeys[i])


def aosring_sign(pkeys, mypair, tees=None, alpha=None, message=None):
	assert len(pkeys) > 0
	message = message or hashpn(*pkeys)
	mypk, mysk = mypair
	myidx = pkeys.index(mypk)

	tees = tees or [randsn() for _ in range(0, len(pkeys))]
	cees = [0 for _ in range(0, len(pkeys))]
	alpha = alpha or randsn()

	i = myidx
	n = 0
	while n < len(pkeys):
		idx = i % len(pkeys)
		c = alpha if n == 0 else cees[idx-1]
		cees[idx] = schnorr_calc(pkeys[idx], tees[idx], c, message)
		n += 1
		i += 1

	# Then close the ring, which proves we know the secret for one ring item
	# TODO: split into schnorr_alter
	alpha_gap = submodn(alpha, cees[myidx-1])
	tees[myidx] = addmodn(tees[myidx], mulmodn(mysk, alpha_gap))

	return pkeys, tees, cees[-1]


def aosring_check(pkeys, tees, seed, message=None):
	assert len(pkeys) > 0
	assert len(tees) == len(pkeys)
	message = message or hashpn(*pkeys)
	c = seed
	for i, pkey in enumerate(pkeys):
		c = schnorr_calc(pkey, tees[i], c, message)
	return c == seed


if __name__ == "__main__":
	#msg = randsn()
	msg = 1100393337457691677892268319143073326609220895415587238255999304145558755
	keys = aosring_randkeys(4)

	print(aosring_check(*aosring_sign(*keys, message=msg), message=msg))
	print ("Guru")
	proof = aosring_sign(*keys, message=msg)
	print(proof)
	print ("Guru")
	print(quotelist([item.n for sublist in proof[0] for item in sublist]) + ',' + quotelist(proof[1]) + ',' + quote(proof[2]) + ',' + quote(msg))
