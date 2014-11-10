Cursor = require('immutable_cursor')


# Callbacks
#
__callbacks = {}

__data      = new Immutable.Map
__prev_data = new Immutable.Map
__clbk      = {}
__crsr      = null

cursorUpdater = (next_data, prev_data, path) ->
  __data      = next_data
  __prev_data = prev_data
  __crsr      = Cursor __data, cursorUpdater
  
  _.invoke (__callbacks[''] || []), 'call'

__crsr = Cursor __data, cursorUpdater


pathAsString = (path) ->
  switch typeof path
    when 'string' then path
    when 'number' then path.toString()
    else
      if path? then path.join('.') else ''


addListener = (path, callback) ->
  stringPath  = pathAsString(path)
  callbacks   = __callbacks[stringPath] || []
  
  callbacks.push(callback) unless _.contains(callbacks, callback)
  
  __callbacks[stringPath] = callbacks
  
  

addGlobalListener = (callback) ->
  addListener([], callback)


Context =
  
  
  init: (root) ->
    
    render = -> root.forceUpdate()
    
    addGlobalListener ->
      return unless root.isMounted()
      render()
  

  get: (path) ->
    __crsr.cursor(pathAsString(path).split('.'))
  
  
  mixin:
    
    shouldComponentUpdate: (prevProps, prevState) ->
      !Immutable.is(__prev_data.getIn(['timeline', 'date']), __data.getIn(['timeline', 'date']))


# Exports
#
module.exports = Context
