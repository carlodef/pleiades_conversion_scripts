#!/bin/bash
for f in `cat to_transfer.txt`
do
    rsync -e 'ssh -ax' -av --exclude *.zip --exclude *.JP2 $f purple:~/pleiades/reunion
done
