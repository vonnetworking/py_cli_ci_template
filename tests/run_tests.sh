#!/bin/bash
# This file will run unit tests and lint libraries against code in the parent and all
# subdirectories excluding tests subdirectory

#GLOBALS
#TODO - these should probably be able to be specified as parameters on the jenkins job

MINIMUM_LINT_SCORE=7 #lowest lint score that will result in a successful build
LOG_DIR="tests/logs"

########################################################################################################################

#Activate virtual environments to run all the tests, insures appropriate libs available

. ./virtualenv/bin/activate

########################################################################################################################

#Cleanup any old logs (these are actually excluded from the repo, so this should be extranneous

rm -f ${LOG_DIR}/*pep8.log 
rm -f ${LOG_DIR}/*pylint.log

########################################################################################################################

#identify all code files that are not tests, or part of the embedded virtualenv and run pep and lint checks

CODE_FILES=`find . -not \( -path ./virtualenv -prune \) -not \( -path ./tests -prune \) -name "*.py"`

for FILE in ${CODE_FILES}; do
	
	CLEAN_FILENAME=`echo ${FILE} | sed 's/.\///g' | sed 's/\///g'` #file naming for logs...replaces the slashes 
	pycodestyle --max-line-length=120 ${FILE} > ${LOG_DIR}/${CLEAN_FILENAME}.pep8.log || true
        pylint ${FILE} > ${LOG_DIR}/${CLEAN_FILENAME}.pylint.log || true
done

########################################################################################################################
# LINT TESTING
########################################################################################################################

#now check the pylint reports and if anything scores under a 7 out of 10, fail the build
#and do so identifying the file or files that caused the failure

LINT_REPORTS=`find ${LOG_DIR} -name "*pylint.log"`

LINT_FAILS=() #array to capture any lint style failures

for FILE in ${LINT_REPORTS}; do
	echo "${FILE}"

	grep "Your code has been rated at" ${FILE}
	if [ "$?" -eq "0" ]; then
		SCORE=`grep "Your code has been rated at" ${FILE} | awk -F'rated at' '{print $2}' | awk -F'.' '{print $1}'`
		SCORE_INT=$((${SCORE} + 0))
	
		if [ "${SCORE_INT}" -lt "${MINIMUM_LINT_SCORE}" ]; then
			BASENAME=`basename ${FILE} | sed 's/.\///g'`
			CODE_FILE=`echo ${BASENAME} | sed 's/_/\//g' | awk -F.pylint '{print $1}'`
			ERROR_MSG="${CODE_FILE} failed lint test with a score of ${SCORE_INT} < ${MINIMUM_LINT_SCORE} 
			
			--------REPORT-------- 
			
			$(cat ${FILE})
			
			------END REPORT------"
			LINT_FAILS+=("${ERROR_MSG}")
		fi
	fi		
done	

if [ "${#LINT_FAILS[@]}" -gt "0" ]; then
	echo "---BUILD FAILED---"
	echo "${#LINT_FAILS[@]} files failed lint check:"
	for FAIL in "${LINT_FAILS[@]}"; do
		echo "    ${FAIL}"
	done

	exit -1 #FAIL build
fi

########################################################################################################################
# UNITTEST TESTING 
########################################################################################################################

#execute all available unittests in the tests directory
#this outputs junit style tests that can be read by Jenkins

PYTHONPATH="." python -m coverage run tests/unittest_runner.py

#generate coverage reports in xml and html
python -m coverage xml -o coverage.xml
python -m coverage html -d coverage

########################################################################################################################
# DOCTEST TESTING - not implemented yet
########################################################################################################################

#TODO - Add a mechanism for recursively executing doctests in the tests directory
