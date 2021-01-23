#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR
npm run prepare
version=$(cat package.json|jq -r '.version')
git commit -m $version
npm set unsafe-perm true
npm version patch
npm publish --access=public
sync
