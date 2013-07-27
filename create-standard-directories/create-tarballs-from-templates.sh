#!/bin/sh
#
#	This command is used to prepare the template tarballs used by the create-standard-directories script.
#
(
	cd templates
	tar cvf ../restapi.tar restapi
	gzip ../restapi.tar
)
exit 0
