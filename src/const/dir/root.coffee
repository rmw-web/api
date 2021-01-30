import {thisdir} from "@rmw/thisfile"
import {dirname,join} from 'path'

export default ROOT = dirname dirname dirname thisdir(`import.meta`)
if not process.env.rmw
  process.env.rmw = join(dirname(ROOT),"data")
