#! /bin/bash

SIGNATURE=$(ruby sign_update.rb "$1" dsa_priv.pem)
SIZE=$(stat -f %z "$1")
PUBDATE=$(date +"%a, %d %b %G %T %z")

echo "Sign: $SIGNATURE"
echo "Size: $SIZE"
echo "Date: $PUBDATE"
