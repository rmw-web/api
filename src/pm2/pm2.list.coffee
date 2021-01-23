#!/usr/bin/env coffee


import pm2 from './pm2'

export default ->
  li = await pm2.list()
  for i from li
    {name} = i.pm2_env
    if name.startsWith "rmw-"
      yield i.pm2_env
