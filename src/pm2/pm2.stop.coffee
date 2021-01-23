#!/usr/bin/env coffee

import sleep from 'await-sleep'

import pm2 from './pm2'


export default stop = =>
  await pm2.connect()
  while true
    count = 0
    other = 0
    li = await pm2.list()
    for i from li
      {name, status} = i.pm2_env
      console.log name, status
      if name.startsWith "rmw-"
        if status == "online"
          ++count
          await pm2.stop name
        else
          await pm2.delete name
      else
        ++ other
    if not count
      if not other
        await pm2.killDaemon()
      break




import { fileURLToPath } from "url"
if process.argv[1] == fileURLToPath(`import.meta`.url)
  do =>
    await stop()
    console.log "pm2 stop"
    process.exit()


