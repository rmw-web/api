#!/usr/bin/env coffee

import sleep from 'await-sleep'
import onExit from './lib/onExit'
import pm2List from './pm2/pm2.list'
import pm2 from './pm2/pm2'
import stop from './pm2/pm2.stop'

if process.env.NODE_ENV != "development"
  onExit stop

export default =>
  await pm2.connect()
  app = [
    "pg"
    "redis"
  ]
  app = new Set(app)
  todo = []
  for i from app
    console.log "start",i
    todo.push (await import('./pm2/'+i)).default()
  await Promise.all todo
  n = 0
  while ++n < 99
    count = 0
    for await {name, status} from pm2List()
      if status != "online"
        console.log name, status
        ++count
    if not count
      break
    await sleep 1000


  await pm2.disconnect()
  return
