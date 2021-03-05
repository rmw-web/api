#!/usr/bin/env bash
set -e
DIR=$( dirname $(realpath "$0") )

cd $DIR
. .direnv/bin/pid.sh

if [ ! -n "$1" ] ;then
exe=src/index.coffee
else
exe=${@:1}
fi


ctrl_c() {
  echo -e "\nkill pm2\n"
  ./src/pm2/pm2.stop.coffee
  [[ -z "$(jobs -p)" ]] || kill $(jobs -p)
}

trap ctrl_c INT TERM EXIT

npx nodemon --watch 'test/**/*' --watch 'src/**/*' -e coffee,js,mjs,json,wasm,txt,yaml --exec ".direnv/bin/dev.sh $exe"



