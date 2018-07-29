#!/usr/bin/env python
# coding: utf-8

import unittest
import xmlrunner
import os
import re

def runner(output='python_tests_xml'):
    return xmlrunner.XMLTestRunner(
        output=output
    )

def find_tests():
    return unittest.TestLoader().discover('.')

if __name__ == '__main__':
    runner().run(find_tests())
