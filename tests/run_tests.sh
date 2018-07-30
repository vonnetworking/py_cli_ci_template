#!/bin/bash

# This file will run unit tests and lint libraries against code in the parent and all
# subdirectories excluding tests

#Activate virtual environments to run all the tests, insures appropriate libs available
. ./virtualenv/bin/activate

#Pre-cleanup any old logs (these are actually excluded from the repo, so this should be extranneous
rm -f *pep8.log *pylint.log

#identify all code files that are not tests, or part of the embedded virtualenv and run pep and lint checks
CODE_FILES=`find . -not \( -path ./virtualenv -prune \) -not \( -path ./tests -prune \) -name "*.py"`

for FILE in ${CODE_FILES}; do
	
	PYTHONPATH="." python -m coverage run ${FILE}

	pycodestyle --max-line-length=120 ${FILE} > ${FILE}.pep8.log || true
        pylint ${FILE} > ${FILE}.pylint.log || true
done

#execute all available unittests in the tests directory
#this outputs junit style tests that can be read by Jenkins

#python tests/unittest_runner.py

PYTHONPATH="." python -m coverage run tests/unittest_runner.py

#generate coverage reports in xml and html
python -m coverage xml -o coverage.xml
python -m coverage html -d coverage

#TODO - Add a mechanism for recursively executing doctests in the tests directory
