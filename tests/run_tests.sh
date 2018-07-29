#!/bin/bash

# This file will run unit tests and lint libraries against code in the parent and all
# subdirectories excluding tests

. ./virtualenv/bin/activate

rm -f pep8.log pylint.log

PYTHONPATH="." python -m coverage run calc.py

python -m coverage xml -o coverage.xml
python -m coverage html -d coverage

pycodestyle --max-line-length=120 calc.py > pep8.log || true
pylint calc > pylint.log || true
