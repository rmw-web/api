#!/usr/bin/env coffee

import stunIp from './stun.ip'
import stun from 'stun'
import {promisify} from 'util'

request = promisify stun.request

stunPing = (hostIp)=>
  new Promise (resolve)=>
    setTimeout(
      resolve
      60000
    )
    n = 0
    while ++n < 10
      try
        r = await request(hostIp)
      catch err
        continue
      r = r.getAddress()
      if r
        console.log hostIp, r
        resolve hostIp
    resolve()

do =>
  todo = []
  exist = new Set()
  for [host, port] from stunIp
    hostIp = host+":"+port
    if not exist.has hostIp
      exist.add hostIp
      todo.push stunPing(hostIp)

  await Promise.all(todo)

  process.exit()
