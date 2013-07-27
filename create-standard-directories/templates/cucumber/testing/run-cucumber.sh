#!/bin/sh
#
#	Run Cucumber tests
#
TESTING_DIR=`dirname $0`

cd ${TESTING_DIR}
./node_modules/.bin/cucumber.js  --tags ~@ignore cucumber/features \
		-r cucumber/features/step_definitions
