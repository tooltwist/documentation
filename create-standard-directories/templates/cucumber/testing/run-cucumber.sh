#!/bin/sh
#
#	Run Cucumber tests
#

./node_modules/.bin/cucumber.js  --tags ~@ignore cucumber/features \
		-r cucumber/features/step_definitions
