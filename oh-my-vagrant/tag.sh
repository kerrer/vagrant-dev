#!/bin/bash
# TODO: don't run if current HEAD is already tagged (ensure this is idempotent)
# take current HEAD with new version
v=`git describe --match '[0-9]*\.[0-9]*\.[0-9]*' --tags --abbrev=0`
t=`echo "${v%.*}.$((${v##*.}+1))"`	# increment version
echo "Version $t is now tagged!"
echo "Pushing $t to origin..."
echo "Press ^C within 3s to abort."
sleep 3s
git tag $t
git push origin $t
