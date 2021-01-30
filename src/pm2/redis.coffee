#!/usr/bin/env coffee
import DIR_ROOT from '../const/dir/root'
import {writeFile, readFile} from 'fs/promises'
import fs from 'fs'
# import onExit from 'async-exit-hook'
import {join} from 'path'
import Art from 'art-template'
import killpid from "./killpid"
import pm2 from './pm2'
import DIR_OS from '../const/dir/os'
import DIR_SRC from '../const/dir/src'
import DIR from "@rmw/dir"

DIR_RMW = DIR.rmw

redis = "redis"
name = "rmw-"+redis
redis_conf = redis+".conf"
REDIS_CONFIG = join(DIR_RMW,redis_conf)
script = join DIR_OS, redis+"-server.exe"

do =>
  if not fs.existsSync(REDIS_CONFIG)
    fp = join DIR_SRC,"pm2",redis_conf+".art"
    await writeFile REDIS_CONFIG, Art(fp, {
      dir:DIR_RMW
      ...(await import('@rmw/redis/config')).default
    })

export default =>
  await killpid(
    join(DIR_RMW,redis+".pid")
    script
  )
  pm2.start {
    name
    script
    # pid_file: join(DIR_RMW,redis+".pid")
    args:REDIS_CONFIG
  }



# import {dirname} from 'path'
# import redis_exe from './exe'
#
# import fs from 'fs'
# import {join} from 'path'
#
#
# _N = 0
# pm2 = new Proxy(
#   _pm2
#   {
#     get:(self, attr)=>
#       (args, func)->
#         new Promise (resolve, reject)=>
#           ++_N
#           self.connect (err)=>
#             err and reject err
#             self[attr] args, (err)=>
#               err and reject err
#               if func
#                 try
#                   await func.apply @,arguments
#                 catch err
#                   reject err
#                   return
#               setTimeout resolve
#               if not --_N
#                 self.disconnect()
#   }
# )
#
# pm2_redis = (action)=>
#   script = undefined
#   =>
#     script = script or await redis_exe()
#     if not fs.existsSync(config)
#
#       txt = tenjin.render(
#         await readFile join(ROOT, redis_conf), "utf8"
#         {
#           dir:rmw
#           ...(await import('./config')).default
#         }
#       )
#       await writeFile config, txt
#     await pm2[action] {
#       name
#       script
#       pid_file: join(rmw,"redis.pid")
#       args:config
#     }
#
# onExit (resolve)=>
#   pm2.stop name, (err, proc)=>
#     resolve()
#
# export restart = pm2_redis 'restart'
# export default pm2_redis 'start'
#
#
