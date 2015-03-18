#!/bin/sh
#
#	Install files to the Gihub Pages directory (<projectname>.pages) and push to the remote repository
#
dir=`dirname $0`
cd $dir
DOCUMENTATION_DIR=`pwd`
echo DOCUMENTATION_DIR=${DOCUMENTATION_DIR}


# Pull any updates to the github pages
echo Pull updates from git on gh-pages branch
echo "$" cd ${DOCUMENTATION_DIR}/site
         cd ${DOCUMENTATION_DIR}/site
echo "$" git pull origin gh-pages
         git pull origin gh-pages
if [ "$?" != "0" ] ; then
	echo ""
	echo "Error: Not published!"
	exit 1
fi

# Generate stuff
echo Generating API pages
echo "$" cd ${DOCUMENTATION_DIR}/restapi
         cd ${DOCUMENTATION_DIR}/restapi
echo "$" jekyll build --destination ${DOCUMENTATION_DIR}/site/restapi/
         jekyll build --destination ${DOCUMENTATION_DIR}/site/restapi/
if [ "$?" != "0" ] ; then
	echo ""
	echo "Error: Not published!"
	exit 1
fi

# push the github pages
echo Push updates to git on gh-pages branch
echo "$" cd ${DOCUMENTATION_DIR}/site
         cd ${DOCUMENTATION_DIR}/site
echo "$" git add .
         git add .
echo "$" git commit -m "Generated from documentation/restapi"
         git commit -m "Generated from documentation/restapi"
echo "$" git push origin gh-pages
         git push origin gh-pages
if [ "$?" != "0" ] ; then
	echo ""
	echo "Error: Not published!"
	exit 1
fi

# Display a warning
echo "Complete"
echo ""
echo "  Note that changes to github pages usually take several minutes to be reflected on the website."
echo ""
exit 0
