#!/bin/sh
#
#	Create the standard documentation and testing directories used for a ToolTwist project.
#
#	This script is usually run like this:
#
#		curl -s <hostname>/create-standard-directories/script.sh | sh
#

#
#	Check we have the commands we need
#
if ! which git > /dev/null ; then
	echo ""
	echo "ERROR: the 'git' command does not appear to be installed."
	if uname | grep Darwin > /dev/null ; then
		echo ""
		echo "	The easiest way to install git on OSX is to install 'Github For Mac' (https://contral.github.com/mac/latest)"
		echo "	and then select 'Install Command Line Tools' from it's Preferences dialog."
	else
		echo ""
		echo "	See http://git-scm.com/book/en/Getting-Started-Installing-Git for instructions."
	fi
	exit 1
fi
if ! which ruby > /dev/null ; then
	echo ""
	echo "ERROR: the 'ruby' command does not appear to be installed."
	if uname | grep Darwin > /dev/null ; then
		echo ""
		echo "	Ruby shoud be installed by default on OSX. Please check your system configuration."
	else
		echo ""
		echo "	See http://www.ruby-lang.org for instructions."
	fi
	exit 1
fi
if ! which jekyll > /dev/null ; then
	echo ""
	echo "ERROR: the 'jekyll' command does not appear to be installed."
	echo ""
	echo "	See http://jekyllrb.com for instructions."
	exit 1
fi

#
# Get the github repo
#
echo "Checking git repo"
if [ ! -d .git ] ; then
	echo "This directory is not a git repository"
	exit 1
fi

if remote=`git remote -v` ; then
	true
else
	echo Error running git remote -v
	exit 1
fi

if echo ${remote} | grep origin > /dev/null ; then
	remote=`echo $remote | sed "s/.*origin \\(.*\\) (fetch).*/\\1/"`
else
	echo "No remote origin is defined for this repository"
	exit 1
fi
echo repo = ${remote}

#
#	Check the repo is for github
#
#remote=https://github.com/tooltwist/tea.git
if echo ${remote} | grep "https://github.com/" > /dev/null ; then
	user=`echo ${remote} | sed "s/https:\/\/github.com\/\\(.*\\)\/\\(.*\\)\\.git/\\1/"`
	echo user = ${user}
	repo=`echo ${remote} | sed "s/https:\/\/github.com\/\\(.*\\)\/\\(.*\\)\\.git/\\2/"`
	echo repo = ${repo}
elif echo ${remote} | grep "git@github.com:" > /dev/null ; then
	user=`echo ${remote} | sed "s/git@github.com:\\(.*\\)\/\\(.*\\)\\.git/\\1/"`
	echo user = ${user}
	repo=`echo ${remote} | sed "s/git@github.com:\\(.*\\)\/\\(.*\\)\\.git/\\2/"`
	echo repo = ${repo}
else
	echo ""
	echo "ERROR: The remote for this repository does not appear to be at github.com"
	exit 1
fi

#
# Check we have github-pages
#
if [ ! -d documentation/github-pages ] ; then
	echo "####################################################################"
	echo "#"
	echo "#    Settig up documentation/github-pages."
	echo "#"
	echo "####################################################################"
	mkdir -p documentation

	# See if there is already a gh-pages branch
	if git ls-remote origin | grep gh-pages ; then

		# Clone the existing branch
		echo "# Cloning the existing gh-pages branch."
		(
			echo "$ cd documentation"
			cd documentation
			echo "$ git -b gp-pages clone ${remote} github-pages"
			git clone -b gp-pages ${remote} github-pages
		)
	else
		# Create a new branch
		# (https://help.github.com/articles/creating-project-pages-manually)
		echo "# Creating a new gh-pages branch in the repo."
		(
			echo "$ cd documentation"
			cd documentation
			echo "$ git clone ${remote} github-pages"
			git clone ${remote} github-pages
			echo "$ cd github-pages"
			cd github-pages
			echo "$ git checkout --orphan gh-pages"
			git checkout --orphan gh-pages
			echo "$ git rm -rf ."
			git rm -rf .
			echo "$ echo \"My GitHub Page\" > index.html"
			echo "My GitHub Page" > index.html
			echo "$ git add index.html"
			git add index.html
			echo "$ git commit -a -m \"First pages commit\""
			git commit -a -m "First pages commit"
			echo "$ git push origin gh-pages"
			git push origin gh-pages
		)
	fi
fi

#
# Check we have documentation/github-wiki
#
if [ ! -d documentation/github-wiki ] ; then
	echo ""
	echo "####################################################################"
	echo "#"
	echo "#    Cloning wiki into directory doumentation/github-wiki"
	echo "#"
	echo "####################################################################"
	mkdir -p documentation
	(
		cd documentation
		wiki_repo=`echo ${remote} | sed "s/\\.git$/.wiki.git/"`
		echo wiki = ${wiki_repo}
		echo "$ git clone ${wiki_repo} github-wiki"
		git clone ${wiki_repo} github-wiki
	)
fi


#
#	Check we have documentation/restapi
#
if [ ! -d documentation/restapi ] ; then
	echo ""
	echo "####################################################################"
	echo "#"
	echo "#    Creating REST API documentation into documentation/restapi"
	echo "#"
	echo "####################################################################"
	mkdir -p documentation
	(
		cd documentation
		RESTAPI_TAR=https://github.com/tooltwist/documentation/raw/master/create-standard-directories/restapi.tar.gz
		curl -s -S -L ${RESTAPI} | tar xzvf -
		# Remove any weird OSX files
		find restapi -name '._*' -ls -exec rm {} \;
		find restapi -name '.DS_Store' -ls -exec rm {} \;
	)
fi


#
#	Display a nice message
#
wiki_url=http://github.com/${user}/${repo}/wiki
pages_url=http://${user}.github.io/${repo}
restapi_url=http://${user}.github.io/${repo}/restapi

echo ""
echo ""
echo "Project checks complete."
echo "  Wiki url = ${wiki_url}"
echo "  Project website = ${pages_url}"
echo "  REST API = ${restapi_url}"
exit 0
