import onExit from 'async-exit-hook'
export default (func)=>
  onExit (callback)=>
    try
      await func()
    catch err
      console.trace err
    finally
      callback()


