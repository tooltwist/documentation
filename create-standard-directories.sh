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
echo ""
echo "#################################################################################"
echo "#"
echo "#  Checking we have the required commands available on this machine"
echo "#"
echo "#################################################################################"
echo " - git"
if ! which git > /dev/null ; then
	echo ""
	echo "ERROR: the 'git' command does not appear to be installed."
	if uname | grep Darwin > /dev/null ; then
		echo ""
		echo "	The easiest way to install git on OSX is to install 'Github For Mac' (https://contral.github.com/mac/latest)"
		echo "	and then select 'Install Command Line Tools' from it's Preferences dialog."
		echo ""
	else
		echo ""
		echo "	See http://git-scm.com/book/en/Getting-Started-Installing-Git for instructions."
		echo ""
	fi
	exit 1
fi
echo " - ruby"
if ! which ruby > /dev/null ; then
	echo ""
	echo "ERROR: the 'ruby' command does not appear to be installed."
	if uname | grep Darwin > /dev/null ; then
		echo ""
		echo "	Ruby shoud be installed by default on OSX. Please check your system configuration."
	else
		echo ""
		echo "	See http://www.ruby-lang.org for instructions."
		echo ""
	fi
	exit 1
fi
echo " - jekyll"
if ! which jekyll > /dev/null ; then
	echo ""
	echo "ERROR: the 'jekyll' command does not appear to be installed."
	echo ""
	echo "	See http://jekyllrb.com for instructions."
	echo ""
	exit 1
fi
echo " - node"
if ! which node > /dev/null ; then
	echo ""
	echo "ERROR: Nodejs does not appear to be installed on this machine."
	echo ""
	echo "	See http://nodejs.org for instructions."
	echo ""
	exit 1
fi
echo " - npm"
if ! which npm > /dev/null ; then
	echo ""
	echo "ERROR: npm does not appear to be installed on this machine."
	echo ""
	echo "  It is normally installed when nodejs is installed."
	echo ""
	echo "	See https://npmjs.org for details."
	echo ""
	exit 1
fi

#
# Get the github repo
#
echo "Checking git repository."
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
echo remote = ${remote}

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
# Check we have documentation/site
#
echo Checking documentation/site
if [ ! -d documentation/site ] ; then
	echo "#################################################################################"
	echo "#"
	echo "#  Setting up documentation/site."
	echo "#"
	echo "#################################################################################"
	mkdir -p documentation

	# See if there is already a gh-pages branch
	if git ls-remote origin | grep gh-pages ; then

		# Clone the existing branch
		echo "# Cloning the existing gh-pages branch."
		echo "$ cd documentation"
		cd documentation
		echo "$ git -b gp-pages clone ${remote} site"
		if ! git clone ${remote} site ; then
			echo "ERROR: Failed to clone repo."
			exit 1
		fi
		cd site
		if ! git checkout gh-pages ; then
			echo "ERROR: checkout failed."
			exit 1
		fi
		# We don't need the master branch here any more (this doesn't effect the remote repo)
		git branch -d master
		git prune
		cd ../..
	else
		# Create a new branch
		# (https://help.github.com/articles/creating-project-pages-manually)
		echo "# Creating a new gh-pages branch in the repo."
		(
			echo "$ cd documentation"
			cd documentation
			echo "$ git clone ${remote} site"
			git clone ${remote} site
			echo "$ cd site"
			cd site
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
# Check we have documentation/wiki
#
echo Checking documentation/wiki
if [ ! -d documentation/wiki ] ; then
	echo ""
	echo "#################################################################################"
	echo "#"
	echo "#  Cloning wiki into documentation/wiki."
	echo "#"
	echo "#################################################################################"
	mkdir -p documentation
	cd documentation
	wiki_repo=`echo ${remote} | sed "s/\\.git$/.wiki.git/"`
	echo wiki = ${wiki_repo}
	echo "$ git clone ${wiki_repo} wiki"
	if ! git clone ${wiki_repo} wiki ; then
		echo "ERROR: cloning wiki failed."
		echo ""
		echo "  If this is a new github repository, go to the website and click on the 'wiki'"
		echo "  button for this repo, then run this command again."
		echo ""
		exit 1
	fi
	cd ..
fi


#
#	Check we have documentation/restapi
#
echo Checking documentation/restapi
if [ ! -d documentation/restapi ] ; then
	echo ""
	echo "#################################################################################"
	echo "#"
	echo "#  Creating example API documentation in documentation/restapi."
	echo "#"
	echo "#################################################################################"
	mkdir -p documentation
	RESTAPI_TARBALL=https://github.com/tooltwist/documentation/raw/master/create-standard-directories/restapi.tar.gz
	curl -s -S -L ${RESTAPI_TARBALL} | tar xzvf -
	# Remove any weird OSX files
	find documenttion/restapi -name '._*' -ls -exec rm {} \;
	find documenttion/restapi -name '.DS_Store' -ls -exec rm {} \;
fi


#
#	Check we have testing/cucumber
#
echo Checking testing/cucumber
if [ ! -d testing/cucumber ] ; then
	echo ""
	echo "#################################################################################"
	echo "#"
	echo "#  Creating example BDD tests in testing/cucumber."
	echo "#"
	echo "#################################################################################"
	mkdir -p testing
	CUCUMBER_TARBALL=https://github.com/tooltwist/documentation/raw/master/create-standard-directories/cucumber.tar.gz
	curl -s -S -L ${CUCUMBER_TARBALL} | tar xzvf -
	# Remove any weird OSX files
	find testing/cucumber -name '._*' -ls -exec rm {} \;
	find testing/cucumber -name '.DS_Store' -ls -exec rm {} \;
	# Install any required node packages
	echo "Checking node packages used in testing"
	(
		cd testing
		npm install
	)
fi


#
#	Check .gitignore contains appropriate entries
#
echo Checking .gitignore
if [ ! -e .gitignore ] ; then
	echo "$ touch .gitignore"
	touch .gitignore
fi
f=.DS_Store
if ! grep "^${f}$" .gitignore ; then
	echo " - adding ${f}"
	echo "${f}" >> .gitignore
fi
f=/documentation/site
if ! grep "^${f}$" .gitignore ; then
	echo " - adding ${f}"
	echo "${f}" >> .gitignore
fi
f=/documentation/wiki
if ! grep "^${f}$" .gitignore ; then
	echo " - adding ${f}"
	echo "${f}" >> .gitignore
fi
f=/documentation/restapi/_site
if ! grep "^${f}$" .gitignore ; then
	echo " - adding ${f}"
	echo "${f}" >> .gitignore
fi


#
#	Check we have an README.md
#
pages_url=http://${user}.github.io/${repo}
wiki_url=http://github.com/${user}/${repo}/wiki
issues_url=http://github.com/${user}/${repo}/issues
restapi_url=http://${user}.github.io/${repo}/restapi
echo Checking README.md
haveReadme=false
if [ -e README.md ] ; then
        if [ -s README.md ] ; then
                # Check the file has content
                trimmed=`sed 's/^[ \t]*//' README.md`
                if [ "${trimmed}" != "" ] ; then
			# We have a Readme file and it is not null. See if it is the default file:
			#
			# myproject
			# =========
			#
			# Optional single line description

			lines=`wc -l README.md | sed "s/ README.md.*$//"`
			line1=`sed -n 1p README.md`
			line2=`sed -n 2p README.md`
			line3=`sed -n 3p README.md`

			required_line1="${repo}"
			required_line2=`echo ${repo} | sed "s/./=/g"`
			required_line3=""

			[ "${lines}" -ne 4 ] && haveReadme=true
			[ "${line1}" != "${required_line1}" ] && haveReadme=true
			[ "${line2}" != "${required_line2}" ] && haveReadme=true
			[ "${line3}" != "${required_line3}" ] && haveReadme=true
                fi
        fi
fi

if [ ${haveReadme} == "false" ] ; then
	echo "#################################################################################"
	echo "#"
	echo "#  Creating README.md"
	echo "#"
	echo "#################################################################################"
	cat > README.md << END

#### Project Website:  
  
  [${pages_url}]  

#### Wiki:  

  [${wiki_url}]  

#### Technical issues:  

  [${issues_url}].  

Note: this is for developers; customers use a different error reporting system.  

#### REST API:  

  [${restapi_url}]  

END
fi

#
#	Finish with a nice message
#
echo Checks complete
echo "#################################################################################"
echo ""
echo ""
echo "  Project website = ${pages_url}"
echo ""
echo "  Wiki = ${wiki_url}"
echo ""
echo "  Issues = ${issues_url}"
echo ""
echo "  REST API = ${restapi_url}"
echo ""
echo ""
echo "For information about how to use these directories go to:"
echo ""
echo "  https://github.com/tooltwist/documentation/wiki/_preview#standard-directories"
echo ""
echo "#################################################################################"
exit 0
