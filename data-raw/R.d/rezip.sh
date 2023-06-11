#!/bin/sh
#
# NOTE: This script needs to be run after unzipping all of the raw
# zip files from CLUE. The file format of bz is not supported by the
# justRMA function, so we translate over to gzip format.
#
for i in *; do

  bunzip2 $i
  gzname=`basename $i .bz2`
  echo "Unzipping $i to $gzname"
  gzip ${gzname}
done
