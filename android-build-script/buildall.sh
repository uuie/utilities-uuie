#!/bin/bash
if [ $# == 0 ]
then
	echo usage $0 [VERSION_NUMBER]
	exit;
fi

VERSION_NUMBER=$1
PROJ_NAME=`cat build.xml |grep project\ name |sed -e 's/.*name="\([^"]*\).*/\1/'`

rm -rf gen
rm -rf bin
cp -f AndroidManifest.xml xml.tmp

echo 123123123

cat channel.lst |while read line
do
	echo $line
   sed -e 's/INNERTEST/'''$line'''/'  xml.tmp >tmp.xml
   sed -e 's/android:debuggable="true"/android:debuggable="false"/' tmp.xml >AndroidManifest.xml 
   echo "out.release.file.name=$PROJ_NAME-$line-$VERSION_NUMBER-release.apk" >outfile.properties
   ant release
done
cp  -f xml.tmp AndroidManifest.xml
rm -f xml.tmp tmp.xml
rm -f outfile.properties

ZIPFILE=`pwd`/bin/weipai-$VERSION_NUMBER.7z

7z a  $ZIPFILE  `pwd`/bin/*release.apk

echo "Hi
FYI.
$PROJ_NAME  $VERSION_NUMBER released.
enclosed the packaged apps.


#BR!" >/tmp/msg.txt
MAILTO=`cat mail.lst`
mutt -s "$PROJ_NAME $VERSION_NUMBER release" $MAILTO -a $ZIPFILE </tmp/msg.txt


