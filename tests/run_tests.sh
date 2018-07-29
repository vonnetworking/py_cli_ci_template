#!/bin/bash

# This file will run unit tests and lint libraries against code in the parent and all
# subdirectories excluding tests

. ./virtualenv/bin/activate

rm -f pep8.log pyflakes.log

PYTHONPATH="." python -m coverage run ..

done

python -m coverage xml -o coverage.xml
python -m coverage html -d coverage

pep8 --max-line-length=120 ../calc > pep8.log || true
pylint calc > pyflakes.log || true
