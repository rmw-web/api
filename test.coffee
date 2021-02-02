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
  console.log address, hostIp
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
  console.log "server listening #{address.address}:#{address.port}", addr
  return addr
  # console.log socket
  # new Promise (resolve)=>
  #   n = 0
  #   while ++n < 10
  #     try
  #     catch err
  #       console.log err
  #       continue
  #     break
  #   console.log(r)
  #   # addr = r.getAddress()
  #   # resolve(addr)
  #   return

  # console.log server
  # new Promise (resolve)=>
  #   setTimeout(
  #     resolve
  #     60000
  #   )
  #   n = 0
  #   while ++n < 10
  #     try
  #       r = await stun.request(
  #         hostIp
  #         {server}
  #       )
  #     catch err
  #       console.log err
  #       continue
  #     console.dir r
  #     r = r.getAddress()
  #     if r
  #       console.log hostIp, r
  #       resolve hostIp
  #       return
  #   resolve()

do =>
  exist = new Set()
  for [host, port] from stunIp
    hostIp = host+":"+port
    if not exist.has host
      exist.add host
      await stunPing(hostIp)


  process.exit()
