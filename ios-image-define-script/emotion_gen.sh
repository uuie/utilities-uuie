#!/bin/sh

echo $SOURCE_ROOT
EMOTIONSDIR=$SOURCE_ROOT/Resources/emotions
TARGETFILE=$SOURCE_ROOT/emotions.plist
TEMPTARGET=$SOURCE_ROOT/emotions.plist.tmp
EMOTIONLIST=$SOURCE_ROOT/emotionlist.tmp

find $EMOTIONSDIR -name "*.gif"|awk '{print "\""$0"\""}' | xargs basename >$EMOTIONLIST

echo '<?xml version="1.0" encoding="UTF-8"?>'>$TEMPTARGET
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'>>$TEMPTARGET
echo '<plist version="1.0">'>>$TEMPTARGET
echo '<dict>'>>$TEMPTARGET
cat $EMOTIONLIST | while read line 
do
  KEY=`echo $line|sed 's/[0-9][0-9]\(.*\).gif/\1/' `
  echo '    <key>'$KEY'</key>'>>$TEMPTARGET
  echo '    <string>'$line'</string>'>>$TEMPTARGET
done
echo '</dict>'>>$TEMPTARGET
echo '</plist>'>>$TEMPTARGET

echo diff -b $TEMPTARGET $TARGETFILE
HAS_CHANGE=`diff $TEMPTARGET $TARGETFILE`
if [ -z "$HAS_CHANGE" ];then
	echo No change found since last modify
else
	cat $TEMPTARGET >$TARGETFILE
fi
echo $TARGET_FILE generated
rm -f $EMOTIONLIST $TEMPTARGET

exit 0
