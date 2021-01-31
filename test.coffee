#!/usr/bin/env coffee

import stun from 'stun'
import {promisify} from 'util'

request = promisify stun.request

do =>
  host = "stun.counterpath.com:3478"
  r = await request(host)
  console.log r.getXorAddress()
  console.log r.getAddress()


