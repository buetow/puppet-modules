#!/bin/sh

# This creates all needed parent directories in the RSYNC_MODULE 
#
# Author(s): rene.engelhard@1und1.de
# Maintainer: rene.engelhard@1und1.de

OWNER=$1

for f in $RSYNC_REQUEST; do
 i=`echo $f | sed -e s,$RSYNC_MODULE_NAME/,,`
 dir="$RSYNC_MODULE_PATH/`dirname $i`"
 if [ ! -d "$dir" ]; then
   mkdir -p "$dir"
   if [ ! -z "$OWNER" ]; then
     chown $OWNER "$dir"
   fi
   logger "Created parent dir $dir" &
 fi
done

