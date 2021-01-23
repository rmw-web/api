#!/usr/bin/env coffee
import EXE from './exe'
import {writeFile, readFile} from 'fs/promises'
import {join} from 'path'
import pm2 from './pm2'
import fs from 'fs'
import Pg from '@rmw/pg/pg'
import sleep from 'await-sleep'
import {postgres,postgres_bin,connection,DIR_PG} from './pg_ctl'
import DIR_ROOT from '../const/dir/root'

initdb = =>
  if not fs.existsSync DIR_PG
    { execFile } = await import('child_process')
    {user} = connection
    initdb = join postgres_bin,"initdb"+EXE
    await new Promise (resolve, reject)=>
      s = execFile(initdb,['--encoding="UTF8"',"--username=#{user}", DIR_PG])
      s.on 'close', (code)=>
        if code
          reject(code)
          return
        resolve()
      s.stdout.pipe process.stdout
      s.stdout.on 'data',(msg)=>
        msg = msg.toString("utf8")
        if msg.startsWith "Success."
          # await sleep(3000)
          resolve()
        return
      s.stderr.pipe process.stderr
    return true

pg_hba_md5 = =>
  fp = join(DIR_PG,"pg_hba.conf")
  txt = await readFile(fp,"utf8")
  r = []
  for i in txt.split("\n")
    if not i.startsWith "#"
      i = i.replace " trust", " md5"
    r.push(i)
  await writeFile fp, r.join('\n')


export default =>
  is_new = await initdb()
  name = "rmw-pg"
  pgexe = {
    name
    script:process.argv[0]
    args:'--experimental-modules --es-module-specifier-resolution=node "'+join(
      DIR_ROOT, 'lib/pm2/pg_ctl.js"'
    )
    # pid_file: join(DIR_PG,"pg.pid")
  }
  await pm2.start pgexe

  n = 0
  while ++n < 20
    await sleep 500 # 等postgresql 启动

    pg = Pg {
      connection: do =>
        config = {
          ...connection
          database:postgres
        }
        if is_new
          delete config.password
        config
    }
    if is_new
      # https://github.com/knex/knex/issues/1565
      # bindings was a DB concept , one cannot use parameter binding in that position with postgresql. There is nothing that knex can do to make it work easily
      # 所以需要先格式化
      sql = pg.$raw(
        "ALTER USER ?? WITH PASSWORD ?"
        [
          connection.user
          connection.password
        ]
      ).toString()
    else
      sql = "select 1"

    try
      await pg.$exec sql
    catch err
      console.error err.toString()
      continue

    await pg.$destroy()
    if is_new
      await pg_hba_md5()
      await pm2.restart pgexe
      is_new = false
    else
      break
  return
