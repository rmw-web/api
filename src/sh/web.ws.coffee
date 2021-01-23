#!/usr/bin/env coffee
import camelCase from 'lodash/camelCase'
import fs from 'fs-extra'
import path from 'path'
import klawSync from 'klaw-sync'
import get_parameter_names from '../lib/func_args.js'
import ROOT from '../const/dir/root'
import SRC from '../const/dir/src'

OUTDIR = path.join(
  path.resolve(ROOT,'../web/src')
)

outfile = (filepath, txt)=>
  fs.outputFileSync(
    filepath
    txt
  )

dump = (p)=>
  mod = await import('../ws/'+p)

  ol = []
  dev = []
  for k , v of mod
    # if typeof(v) == 'object'
    #   func = dump_mod(v)
    # else
    param = get_parameter_names(v)
    func_name = "_"+camelCase(p)
    dev.push "#{k} : (#{param}) -> console.log await #{func_name}.#{k}.apply(#{func_name}, arguments)"
    ol.push "export #{k} = WS.#{k}"

  txt = """\
import Ws from '@/coffee/ws'
WS = Ws('#{p}')
#{ol.join('\n')}
"""
  fpath = path.join(OUTDIR, "ws", p+".coffee")
  console.log fpath
  outfile(
    fpath
    txt
  )
  return dev.join("\n  ")

do =>
  dirpath = path.join(SRC, "ws")
  len = dirpath.length+1
  li = klawSync dirpath
  txt = [
    """export default {"""
  ]
  for i in li
    p = i.path
    pname =  p.slice(len,-7)
    name = camelCase(pname)
    txt.unshift "_#{name} = Ws('#{pname}')"
    txt.push "#{name}:{\n  "+await dump(pname)
    txt.push '}'
  txt.push '}'
  txt.unshift "import Ws from '@/coffee/ws'"
  outfile(
    path.join(OUTDIR,"coffee/ws/dev.coffee")
    txt.join("\n")
  )

  process.exit()
