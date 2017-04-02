#!/usr/local/bin/bash

set -x

# Need postfix with SASL and mailman with postfix support.

poudriere ports -u -p local
#poudriere options -j 10p3amd64 -p local -z mail -f mail-pkglist
poudriere bulk -j 10p3amd64 -p local -z mail -f mail-pkglist
