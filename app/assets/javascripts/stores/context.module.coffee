CURSOR_PATH_SEPARATOR = '.'


pathAsString = (path) ->
  switch typeof path
    when 'string' then path
    when 'number' then path.toString()
    else
      if path? then path.join('.') else ''

pathAsArray = (path) ->
  pathAsString(path).split(CURSOR_PATH_SEPARATOR).filter (part) -> !!part


# My Cursor
#
class Cursor
  
  constructor: (data, path, callback) ->
    @__data     = data
    @__path     = pathAsArray(path)
    @__callback = if _.isFunction(callback) then callback else _.noop
  
  
  cursor: (path) ->
    new Cursor(@__data, @__path.concat(pathAsArray(path)), @__callback)
  

  deref: ->
    Immutable.fromJS(@__data.getIn(@__path))
  

  get: (key) ->
    newData = @__data.getIn(@__path.concat(key))
    @__callback.call(@, newData, @__data, @__path)
  
  
  set: (key, value) ->
    newData = @__data.setIn(@__path.concat(key), value)
    @__callback.call(@, newData, @__data, @__path)
  

  update: (updater) ->
    newData = @__data.updateIn(@__path, updater)
    @__callback.call(@, newData, @__data, @__path)
  
  
  remove: (key) ->
    newData = @__data.removeIn(@__path)
    @__callback.call(@, newData, @__data, @__path)



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
  __crsr      = new Cursor __data, [], cursorUpdater
  
  _.invoke (__callbacks[''] || []), 'call'

__crsr = new Cursor __data, [], cursorUpdater


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
    __crsr.cursor(path)
  

  cursor: (path) ->
    __crsr.cursor(path)
  
  
  mixin:
    
    shouldComponentUpdate: (prevProps, prevState) ->
      !Immutable.is(__prev_data.getIn(['timeline', 'date']), __data.getIn(['timeline', 'date']))
    
    
    getCursor: ->
      Context.cursor(['timeline', 'date'])


# Exports
#
module.exports = Context
