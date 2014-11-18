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


# Cursor Factory
#
CursorFactory = (path, callback) ->
  path      = pathAsArray(path)
  callback  = _.noop unless _.isFunction(callback)
  
  
  Cursor =
    
    isChanged: ->
      !Immutable.is(__currData.getIn(path), __prevData.getIn(path))
    

    cursor: (subPath) ->
      CursorFactory(path.concat(subPath), callback)
  
  
    deref: (notSetValue) ->
      __currData.getIn(path, ensureImmutable(notSetValue))


    derefPrev: (notSetValue) ->
      __prevData.getIn(path, ensureImmutable(notSetValue))
    
    
    get: (key, notSetValue) ->
      absolutePath = path.concat(key.toString())
      __currData.getIn(absolutePath, ensureImmutable(notSetValue))
  
  
    getPrev: (key, notSetValue) ->
      absolutePath = path.concat(key.toString())
      __prevData.getIn(absolutePath, ensureImmutable(notSetValue))
  
  
  
    set: (key, value) ->
      absolutePath = path.concat(key.toString())
      callback 'setIn', absolutePath, value
      @
  

    update: (fn) ->
      callback 'updateIn', path, fn
      @
    

    remove: (key) ->
      absolutePath = path.concat(key.toString())
      callback 'removeIn', absolutePath
      @
    

    clear: ->
      callback 'removeIn', path
      @
  

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
          console.warn 'UNKNOWN!!!'
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
  
  
# Exports
#
module.exports = Context
