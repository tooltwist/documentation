#!/bin/sh
#
#	Install files to the Gihub Pages directory (<projectname>.pages) and push to the remote repository
#
bin=`dirname $0`

PROJECT_NAME=tea

# Generate stuff
(
	cd $bin
	jekyll build --destination ../github-pages/restapi/
)

# push the github pages
(
	cd $bin/../github-pages
	git add .
	git commit -m "Generated from documentation/restapi"
	git push origin gh-pages
)
exit 0
