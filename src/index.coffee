#!/usr/bin/env coffee

import "@rmw/console/global"
import pm2 from './pm2'

do =>
  await pm2()
  await (await import('./api')).default()
