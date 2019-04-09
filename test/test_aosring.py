import unittest
import hashlib
import time
from sys import getsizeof

from altbn128 import randsn
from aosring import aosring_randkeys, aosring_check, aosring_sign
from hashlib import sha256


class AosringTests(unittest.TestCase):
    def test_aos(self):
        #msg = randsn()
        msg = 1100393337457691677892268319143073326609220895415587238255999304145558755
        #print(msg)
        msgh = hashlib.sha256(msg)
        #msgh.update(b"hello world")
        #print(msgh)
        keys = aosring_randkeys(4)
        
        #print(keys)
        #print("Guru")
        start = time.time()
        key = aosring_sign(*keys, message=msg)
        end = time.time()
        print (end - start)
        print("Guru")
        length = getsizeof(key)
        length1=len(repr(key))
        print(length)
        print(length1)
        print(key)
        print("Guru")
        #print(b)
        #print("Guru")
        #print(c)
        #print("Guru")
        #print(msg)
        #print("Guru")
        start1 = time.time()
        self.assertTrue(aosring_check(*aosring_sign(*keys, message=1100393337457691677892268319143073326609220895415587238255999304145558755), message=msg))
        end1 = time.time()
        print (end1 - start1)

if __name__ == "__main__":
    unittest.main()
