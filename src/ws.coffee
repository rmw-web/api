import Uws from 'uWebSockets.js'
import split_n from 'split_n'

idleTimeout = 60
PORT = 49103

send = (ws, data)=>
  ws.send JSON.stringify data

export default =>
  app = Uws.App().ws(
    "/*"
    {

      idleTimeout:idleTimeout+10
      maxPayloadLength: -1
      compression: Uws.DEDICATED_COMPRESSOR_256KB

      open: (ws) =>
        send(
          ws
          [ idleTimeout ]
        )
        console.log( "open")

      message: (ws, message, isBinary) =>
        if not isBinary
          txt = new TextDecoder("utf-8").decode message
          switch txt
            when "@"
              ws.send(txt)
            else
              [reply, mod, func, args] = split_n(txt," ",4)
              if mod.startsWith(".")
                return
              try
                args = if args then JSON.parse "[#{args}]" else []
                mod = await import("./ws/"+mod)
                r = await mod[func].apply(ws, args)
                if r != undefined
                  reply += " "+JSON.stringify(r)
              catch err
                console.trace err
                reply += " X"+JSON.stringify(err.toString())
              ws.send(reply)
            # when "?"
            #   pos = text.indexOf(" ")
            #   id = text[..pos]
            #   data = JSON.parse "["+text[pos+1..]+"]"
            #   console.log id, data
            #   ws.send(text)

      drain: (ws) =>
        # 消息积压
        console.log('WebSocket backpressure: ' + ws.getBufferedAmount())

      close: (ws, code, message) =>
        console.log('WebSocket closed')

    }
  ).listen PORT, (socket)=>
    if socket
      console.log "ws://127.0.0.1:"+PORT
