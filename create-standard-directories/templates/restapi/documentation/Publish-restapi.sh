#!/bin/sh
#
#	Install files to the Gihub Pages directory (<projectname>.pages) and push to the remote repository
#
DOCUMENTATION_DIR=`dirname $0`
#echo ${DOCUMENTATION_DIR}

PROJECT_NAME=tea

# Generate stuff
(
	echo Generating API pages
	cd ${DOCUMENTATION_DIR}/restapi
	jekyll build --destination ${DOCUMENTATION_DIR}/site/restapi/
)

# push the github pages
(
	cd ${DOCUMENTATION_DIR}/site
	echo Committing to git on gh-pages branch
	git add .
	git commit -m "Generated from documentation/restapi"
	echo Pushing to Github.
	git push origin gh-pages
)

# Display a warning
echo "Complete"
echo ""
echo "  Note that changes to github pages usualy take several minutes to be reflected on the website."
echo ""
exit 0
