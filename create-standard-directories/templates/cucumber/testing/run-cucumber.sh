#!/bin/sh
#
#	Run Cucumber tests
#
dir=`dirname $0`
cd $dir
TESTING_DIR=`pwd`
echo TESTING_DIR=${TESTING_DIR}

cd ${TESTING_DIR}
./node_modules/.bin/cucumber.js  --tags ~@ignore cucumber/features \
		-r cucumber/features/step_definitions
