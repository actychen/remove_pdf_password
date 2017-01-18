#!/bin/bash
APP_NAME=`echo $(basename $(readlink -nf $0))`

printUsage() {
    echo
    echo "Remove password from pdf file"
    echo
    echo "Syntax: $APP_NAME -f FILE -p PASSWORD"
    echo
}

checkFile() {
if [ ! -f "$FILENAME" ]; then
    echo "File not found"
    exit
fi
}

if [ $# == 0 ] ; then
    printUsage
    exit 1;
fi

while getopts "f:p:" OPTNAME
do
    case $OPTNAME in
        f)
            FILENAME="$OPTARG";;
        p)
            PASSWD="$OPTARG";;
        *)
            printUsage
            exit;;
    esac
done

#
MOGRIFY=`which mogrify`
if [ ! -f "$MOGRIFY" ]; then
    echo
    echo "Warn : mogrify not found"
    echo "Please install Imagemagick"
    echo
    echo "On Ubuntu : apt-get install imagemagick"
    exit
fi

checkFile

echo "==== Remove password of pdf files ===="
echo
echo "Please backup your file, it will be re-write your file" 
read -p "Press any key to continue, or press ctrl+c to exit"
echo 
if [ -z "$PASSWD" ]; then
    read -p "Please enter the password for this file ==> " $PASSWD
fi

$MOGRIFY -authenticate $PASSWD $FILENAME

echo "done"
