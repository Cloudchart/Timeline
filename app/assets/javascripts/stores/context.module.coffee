__currData  = new Immutable.Map
__prevData  = new Immutable.Map
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


__cursorCache = {}


# Cursor Factory
#
CursorFactory = (path, callback) ->
  path      = pathAsArray(path)
  callback  = _.noop unless _.isFunction(callback)
  
  
  GetIn = (path, notSetValue, data) ->
    data.getIn(path, notSetValue)
  
  
  Cursor =
    
    isChanged: ->
      !Immutable.is(__currData.getIn(path), __prevData.getIn(path))
    

    cursor: (subPath) ->
      absolutePathAsArray   = path.concat(pathAsArray(subPath))
      absolutePathAsString  = pathAsString(absolutePathAsArray)
      
      __cursorCache[absolutePathAsString] ||= CursorFactory(absolutePathAsArray, callback)
  
  
    deref: (notSetValue) ->
      @getIn([], notSetValue)


    derefPrev: (notSetValue) ->
      @getInPrev([], notSetValue)
    
    
    get: (key, notSetValue) ->
      @getIn([key.toString()], notSetValue)
    
    
    getIn: (subPath, notSetValue) ->
      GetIn(path.concat(subPath), ensureImmutable(notSetValue), __currData)
  
  
    getPrev: (key, notSetValue) ->
      @getInPrev([key.toString()], notSetValue)
    

    getInPrev: (subPath, notSetValue) ->
      GetIn(path.concat(subPath), ensureImmutable(notSetValue), __prevData)
    
    
    set: (key, value) ->
      @setIn([key.toString()], value)
    

    setIn: (subPath, value) ->
      callback 'setIn', path.concat(subPath), value
      @
  

    update: (fn) ->
      @updateIn([], fn)
    

    updateIn: (subPath, fn) ->
      callback 'updateIn', path.concat(subPath), fn
      @
    

    remove: (key) ->
      @removeIn([key.toString()])
    

    removeIn: (subPath) ->
      callback 'removeIn', path.concat(subPath)
      @
    

    clear: ->
      @removeIn([])
  

__fnStack = []

commit = ->

  __nextData = __currData.withMutations (data) ->
    
    __fnStack.forEach (args) ->
      [key, path, value] = args

      data = switch key

        when 'setIn'
          value = ensureImmutable(value)
          data.setIn(path, value)

        when 'updateIn'
          value = ensureImmutable(value(data.getIn(path)))
          data.setIn(path, value)

        when 'removeIn'
          data.removeIn(path)

        else
          console.warn 'UNKNOWN!!!', key
          data

    data
  
  __prevData  = __currData
  __currData  = __nextData
  __fnStack   = []
  
  _.invoke (__callbacks[''] || []), 'call'


__commitTimeout = null


GlobalDataUpdater = (args...) ->
  __fnStack.push(args)
  clearTimeout __commitTimeout ; __commitTimeout = setTimeout commit, 10
  

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
      render()
  

  cursor: (path) ->
    CursorFactory path, GlobalDataUpdater
  
  
  size: ->
    console.log __cursorCache
  
  
# Exports
#
module.exports = Context
