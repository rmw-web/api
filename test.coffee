#!/usr/bin/env coffee

import stunIp from './stun.ip'
import stun from 'stun'
import {promisify} from 'util'
import dgram from 'dgram'

stunPing = (hostIp)=>
  socket = dgram.createSocket('udp4')
  socket.bind()
  address = await new Promise (resolve)=>
    socket.on('listening', =>
      resolve socket.address()
    )
  socket.on('close',=>
    console.log "end", address
  )
  try
    r = await stun.request(
      hostIp
      {
        socket
        maxTimeout:3000
      }
    )
  catch err
    console.error hostIp,err
    return
  addr = r.getAddress()
  return [socket, addr]

do =>
  exist = new Set()
  for [host, port] from stunIp
    hostIp = host+":"+port
    if not exist.has host
      exist.add host
      r = await stunPing(hostIp)
      if r
        [socket,addr] = r
        # socket.close()
        console.log addr


  process.exit()
