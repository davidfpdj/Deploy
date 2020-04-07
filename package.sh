#! /bin/bash

DMG="$1"
APP="$2"

if [ -z "$DMG" ]; then
  echo "Missing DMG path"
  exit 1
elif [ -z "$APP" ]; then
  echo "Missing application (.app) path"
  exit 1
fi

DESTDMG=`basename "$APP" .app`
EXT=".app"
OUT=/dev/null

if [ -f "$DESTDMG.dmg" ]; then
	echo "Destination file '$DESTDMG.dmg' already exists"
	exit 1
fi

TMPDIR=`mktemp -d`

function cleanup() {
  echo "Cleaning up..."
  rm -rf $TMPDIR
}
trap cleanup ERR EXIT

TMPDMG="$TMPDIR/image.dmg"
TMPMOUNT="$TMPDIR/mount"

echo "Creating copy of DMG"
cp $DMG $TMPDMG
echo "Mounting volume..."
mkdir "$TMPMOUNT"
MOUNTROOT=`hdiutil attach $TMPDMG -mountroot $TMPMOUNT | cut -f 3`
echo "Volume attached at '$MOUNTROOT'"
cp -r "$APP" "$MOUNTROOT"
echo "File copied to volume"
hdiutil detach "$MOUNTROOT" > $OUT
echo "Volume detached"
hdiutil convert $TMPDMG -format UDBZ -o "$DESTDMG" > $OUT

echo "Done"
