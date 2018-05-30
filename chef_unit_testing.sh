#!/bin/bash
set -e

#Check cookbooks for common style/correctness rules
fc=`foodcritic --version | awk '{print $1, $2}'`
echo ""
echo ""
echo "   ###Running cookbooks against $fc###"
echo ""
#FC007: Ensure recipe dependencies are reflected in cookbook metadata
foodcritic -t correctness,deprecated,files,metadata,readme cookbooks


#Lint .json files under roles/ directory
echo ""
echo ""
echo "   ###Running roles/ against python -m json.tool###"
echo ""
for FILE in $(find roles -type f -name "*.json")
do
  echo "Linting $FILE"
  cat $FILE | python -m json.tool >/dev/null || exit 1
done

#Lint .json files under jsons/ directory
echo ""
echo ""
echo "   ###Running jsons/ against python -m json.tool###"
echo ""
for FILE in $(find jsons -type f -name "*.json")
do
  echo "Linting $FILE"
  cat $FILE | python -m json.tool >/dev/null || exit 1
done

#Lint .json files under nodes/ directory
echo ""
echo ""
echo "   ###Running nodes against python -m json.tool###"
echo ""
for FILE in $(find nodes -type f -name "*.json")
do
  echo "Linting $FILE"
  cat $FILE | python -m json.tool >/dev/null || exit 1
done