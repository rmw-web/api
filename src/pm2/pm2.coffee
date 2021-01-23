#!/usr/bin/env coffee

import {promisify} from 'util'
import _pm2 from 'pm2'

export default new Proxy(
  _pm2
  get:(self,attr)=>
    promisify(self[attr].bind(self))
)
