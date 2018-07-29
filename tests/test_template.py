#!/usr/bin/python

""" This module serves as a template for implementing unittests on commandline python programs.
    to use, simply import the modules you wish to test and define a class, inheriting unittest.TestCase,
    and define methods whose names must begin with "test_" that perform the appropriate unittests on your
    code.  For full documentation on the unittest module, see the docs page at:
        FOR PYTHON 3: https://docs.python.org/3/library/unittest.html
        FOR PYTHON 2: https://docs.python.org/2/library/unittest.html

    EXAMPLE:

    MODULE TO TEST: ../calc.py (parent directory because we're in the "tests" directory of the project

```
    from ... import calc

    class TestCalc(unittest.TestCase):

        def test_add(self):
            self.assertEqual(calc.add(10, 5), 15)
            self.assertEqual(calc.add(-1, 1), 0)
            self.assertEqual(calc.add(-1, -1), -2)
```
    

"""
import os
import sys
import inspect
import unittest

#add the parent directory to sys.path to insure we can import necessary modules
#remember the expectation in this template is that you have all tests in the tests subdir
currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir) 

#ADD IMPORTS OF MODULES TO TEST HERE

import calc

#

class TestCalc(unittest.TestCase):

    def test_add(self):
        self.assertEqual(calc.add(10, 5), 15)
        self.assertEqual(calc.add(-1, 1), 0)
        self.assertEqual(calc.add(-1, -1), -2)

    def test_subtract(self):
        self.assertEqual(calc.subtract(10, 5), 5)
        self.assertEqual(calc.subtract(1, 1), 0)
        self.assertEqual(calc.subtract(11, -1), 12)

#to use, import the module(s) from you
if __name__ == '__main__':
    unittest.main()
