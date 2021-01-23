import fs from 'fs'
import ps from 'ps-node'
import {promisify} from 'util'
import sleep from 'await-sleep'
import {basename} from 'path'
# import killport from 'kill-port'
# import portping from 'is-port-available'


lookup = promisify(ps.lookup)

# export killpid = (pidfile,exe)=>
export default (pidfile,exe)=>
  if fs.existsSync pidfile
    pid = fs.readFileSync pidfile,'utf8'
    count = 0
    loop
      [p] = await lookup({pid})
      if not p
        return
      if basename(p.command) != basename(exe)
        return
      console.log "#{count} killing > ", p.command+p.arguments.join(' ')
      if count > 9
        signal = "SIGKILL"
      else
        signal = "SIGINT"
      try
        process.kill pid,signal
      catch err
        console.error(err)
      await sleep(1000)
      ++count
  return


# export default (pidfile, exe, port)=>
#   # await killpid(pidfile)
#   console.log "!!", port, await portping(port)
#   if not await portping(port)
#     console.log "kill port", port
#
#
