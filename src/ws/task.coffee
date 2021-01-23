import BASE64 from 'urlsafe-base64'

b64_bin = (s)=>
  BASE64.decode(s).toString('binary')

export li = =>

export add = (addr,key,url)=>
  DOWN.get(
    b64_bin key
    url
    [
      b64_bin addr
    ]
  )
