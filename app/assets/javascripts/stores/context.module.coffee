__currData  = new Immutable.Map
__prevData  = null
__callbacks = {}


CURSOR_PATH_SEPARATOR = '.'


pathAsString = (path) ->
  switch typeof path
    when 'string' then path
    when 'number' then path.toString()
    else
      if path? then path.join(CURSOR_PATH_SEPARATOR) else ''


pathAsArray = (path) ->
  pathAsString(path).split(CURSOR_PATH_SEPARATOR).filter (part) -> !!part


ensureImmutable = (value) ->
  if Immutable.Iterable.isIterable(value) then value else Immutable.fromJS(value)


# Cursor Factory
#
CursorFactory = (path, callback) ->
  path      = pathAsArray(path)
  callback  = _.noop unless _.isFunction(callback)
  
  
  updater = (fn) -> callback(fn(), __currData, path)
  

  Cursor =
    cursor: (subPath) ->
      CursorFactory(path.concat(subPath), callback)
  
  
    deref: ->
      ensureImmutable(__currData.getIn(path))
  
  
    get: (key) ->
      absolutePath = path.concat(key.toString())
      ensureImmutable(__currData.getIn(absolutePath))
  
  
    set: (key, value) ->
      absolutePath = path.concat(key.toString())
      updater -> __currData.setIn(absolutePath, value)
      @
  

    update: (fn) ->
      updater -> __currData.updateIn(path, fn)
      @
  
  
    remove: (key) ->
      absolutePath = path.concat(key.toString())
      updater -> __currData.removeIn(absolutePath)
      @
  


GlobalDataUpdater = (next_data, prev_data, path) ->
  __currData  = next_data
  __prevData  = prev_data
  
  _.invoke (__callbacks[''] || []), 'call'
  
  __currData


addListener = (path, callback) ->
  stringPath  = pathAsString(path)
  callbacks   = __callbacks[stringPath] || []
  
  callbacks.push(callback) unless _.contains(callbacks, callback)
  
  __callbacks[stringPath] = callbacks
  
  

addGlobalListener = (callback) ->
  addListener([], callback)


# Context
#
Context =
  
  
  init: (root) ->
    
    render = -> root.forceUpdate()
    
    addGlobalListener ->
      return unless root.isMounted()
      requestAnimationFrame render
  

  cursor: (path) ->
    CursorFactory path, GlobalDataUpdater
  
  
# Exports
#
module.exports = Context
