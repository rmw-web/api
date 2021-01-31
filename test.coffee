#!/usr/bin/env coffee

import stunIp from './stun.ip'
import stun from 'stun'
import {promisify} from 'util'

request = promisify stun.request

stunPing = (hostIp)=>
  new Promise (resolve)=>
    setTimeout(
      resolve
      9000
    )
    while 1
      try
        r = await request(hostIp)
      catch err
        resolve()
        continue
      address = r.getAddress()
      if address
        resolve [hostIp, address]
        return

do =>
  todo = []
  exist = new Set()
  for [host, port] from stunIp
    hostIp = host+":"+port
    if not exist.has hostIp
      exist.add hostIp
      todo.push stunPing(hostIp)

  for i from await Promise.all(todo)
    if i
      console.log JSON.stringify(i)

  process.exit()
