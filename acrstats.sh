#!/bin/bash

if [ -z "$1" ]
  then
    echo "usage: acrstats.sh acrname"
    exit 0
fi
echo "=========================================="
echo "= Checking ACR ...                       ="
echo "=========================================="

images="$(az acr repository list -n $1 --output tsv)"

for image in $images
do 
	echo -n $image:
	az acr repository show-manifests --repository $image --name $1 --detail --output json | grep "\"imageSize\"" | sed -e 's/"imageSize"://g' | sed -e 's/ //g' | sed -e 's/,//g' | paste -sd+ - | bc | numfmt --to=iec-i --suffix=B
done
