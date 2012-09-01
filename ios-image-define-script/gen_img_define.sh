#!/bin/sh
TARGETFILE=$SOURCE_ROOT/img_resouces.h

TEMPTARGET=$TARGETFILE.tmp

TEMPFILE="`pwd`/imgres.list"

find `pwd` -name "*@2x.png"|awk '{print "\""$0"\""}' | xargs basename |sed 's/@2x.png//' >$TEMPFILE


echo "#ifndef _IMG_RESOURCE_H">$TEMPTARGET
echo "#define _IMA_RESOURCE_H">>$TEMPTARGET

echo "">>$TEMPTARGET
cat $TEMPFILE | while read line 
do
  echo "#define" `echo $line | tr [a-z] [A-Z] ` @\""$line\"" >>$TEMPTARGET
done
echo "">>$TEMPTARGET
echo "#endif" >>$TEMPTARGET
echo diff -b $TEMPTARGET $TARGETFILE
HAS_CHANGE=`diff $TEMPTARGET $TARGETFILE`

if [ -z "$HAS_CHANGE" ];then
	echo No change found since last modify
else
	cat $TEMPTARGET >$TARGETFILE
fi
echo $TARGET_FILE generated
rm -f $TEMPFILE $TEMPTARGET
