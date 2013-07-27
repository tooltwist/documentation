#!/bin/sh
#
#	This command is used to prepare the template tarballs used by the create-standard-directories script.
#

# restapi
rm -f restapi.tar.gz
(
	cd templates/restapi
	tar cvf ../../restapi.tar *
)
gzip restapi.tar

# cucumber
rm -f cucumber.tar.gz
(
	cd templates/cucumber
	tar cvf ../../cucumber.tar *
)
gzip cucumber.tar
exit 0
