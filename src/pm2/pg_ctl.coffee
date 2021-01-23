#!/usr/bin/env coffee
import DIR from "@rmw/dir"
import DIR_OS from '../const/dir/os'
import EXE from './exe'
import PG_CONFIG from '@rmw/pg/config'
import { fileURLToPath } from "url"
import {execFile} from 'child_process'
import fs from 'fs'
import {join} from 'path'
import util from 'util'
import killpid from "./killpid"

exec = util.promisify(execFile)

export connection = PG_CONFIG.connection
export DIR_PG = join DIR.rmw, "pg"
export postgres = "postgres"
export postgres_bin = join DIR_OS, postgres, "bin"

if process.argv[1] == fileURLToPath(`import.meta.url`)
  do =>
    exe = join postgres_bin, postgres+EXE
    pidfile = join(DIR_PG,"pg.pid")
    {user,port,host} = connection
    await killpid pidfile,exe

    p = execFile exe, ["-D", DIR_PG, "-p", port, "-h",host]
    p.stdout.pipe process.stdout
    p.stderr.on 'data', (msg)=>
      process.stdout.write msg
      if msg.indexOf("could not locate a valid checkpoint record") + 1
        await exec join(DIR_OS,"pg_resetwal"+EXE),["-f",DIR_PG]
      return
    p.on 'close',(code)=>
      if code != 0
        console.error "postgres exit #{code}"
      process.exit()
      return

    fs.writeFileSync(
      pidfile
      ""+p.pid
    )
    return
