import Koa from 'koa'
import {join, resolve} from 'path'
# import walkdir from "@rmw/api/lib/walkdir"
# import SRC from "./const/dir/src"

app = new Koa()

app.use (ctx, next) =>
  {origin} = ctx.headers
  if origin
    ctx.set('Access-Control-Allow-Origin', "*")
    # ctx.set('Access-Control-Allow-Credentials', true)
    # ctx.set('Access-Control-Allow-Origin', origin)
    # if ctx.request.method == 'OPTIONS'
        # header =
    ctx.set('Access-Control-Allow-Headers','Content-Type,I')
  await next()

app.use (ctx) =>
  {url} = ctx
  url = resolve(url)[1..]
  pos = url.lastIndexOf('/')+1
  if pos
    mpath = url[...pos-1]
    func = url[pos..]
  else
    mpath = url
    func = "default"

  mod = await import("./url/"+mpath)
  ctx.body = await mod[func]()

export default =>
  # init = []
  # for await file from walkdir resolve(dir,"../lib/init")
  #   if file.endsWith(".js")
  #     init.push (await import(file)).default()
  #
  # await Promise.all init

  port = 49101

  console.log "http://127.0.0.1:#{port}"

  app.listen(port)
