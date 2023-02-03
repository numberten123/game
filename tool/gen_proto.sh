#!/bin/sh
filelist=`ls -1 proto/*.proto`
>apps/proto/proto/all.proto
for file in $filelist
do 
	cat $file >> apps/proto/proto/all.proto
done