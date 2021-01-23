#!/usr/bin/env bash
set -e
DIR=$( dirname $(realpath "$0") )

cd $DIR
. .direnv/bin/pid.sh

if [ ! -e "os" ] ;then
os=$(node -e "console.log(process.platform.toLowerCase())")
giturl=git@gitee.com:rmw-link/$(basename $DIR).$os.git
set -x
git clone $giturl os.$os --depth=1
ln -s os.$os os
set +x
fi

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



