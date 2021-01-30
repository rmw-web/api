#!/usr/bin/env coffee
import ROOT from './const/dir/root'
import {dirname,join} from 'path'

if not process.env.rmw
  process.env.rmw = join(dirname(ROOT),"data")

import "@rmw/console/global"
import pm2 from './pm2'

do =>
  await pm2()
  await (await import('./api')).default()
