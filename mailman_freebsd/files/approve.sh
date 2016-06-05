#!/usr/local/bin/bash

set -x

declare -r LIST=friends
declare -i ID=$(./bin/list_requests --verbose --list=$LIST|egrep ' +[0123456789]'|tail -n 1)

cat <<END | ./bin/withlist -l $LIST
from Mailman.mm_cfg import APPROVE
m.HandleRequest($ID,APPROVE)
m.Save()
END
