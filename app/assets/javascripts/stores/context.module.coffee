Cursor = require('immutable_cursor')


__data  = new Immutable.Map
__clbk  = {}
__crsr  = null

cursorUpdater = (next_data, prev_data, path) ->
  return if Immutable.is(next_data.getIn(path), prev_data.getIn(path))
  
  __data = next_data
  __crsr = Cursor __data, cursorUpdater

  path_as_string = path.join('.')
  
  _.chain(Object.keys(__clbk))
    .filter (path) -> path_as_string.slice(0, path.length) == path
    .sortBy (path) -> path
    .each   (path) -> _.invoke __clbk[path], 'call'

__crsr = Cursor __data, cursorUpdater


Context =
  
  get: (path) ->
    path = path.split('.') if _.isString(path)
    path = [path] unless _.isArray(path)
    
    __crsr.cursor(path)
  

  on: (path, callback) ->
    path = path.split('.') if _.isString(path)
    path = [path] unless _.isArray(path)

    path = path.join('.')
    
    (__clbk[path] ||= []).push(callback) if _.isFunction(callback)

    null
  

  off: (path, callback) ->
    path = path.split('.') if _.isString(path)
    path = [path] unless _.isArray(path)
    
    path = path.join('.')

    if __clbk[path]
      __clbk[path] = _.without(__clbk[path], callback)
    
    null


# Exports
#
module.exports = Context
