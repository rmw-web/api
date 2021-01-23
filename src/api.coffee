import PG from "@rmw/pg"
import initPG from "@rmw/pg/init"

export default =>
  redis = (await import('@rmw/redis')).default

  await initPG(
    PG
    (pg)=>
      console.log "! init pg"
      # console.log "pg", pg
      # throw "test drop"
  )
  for mod in ['ws','koa']
    (await import('./'+mod)).default()



