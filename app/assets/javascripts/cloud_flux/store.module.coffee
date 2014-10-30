# Cursor
#
Cursor = require('immutable_cursor')


# Data
#
__data = new Immutable.Map


# Store
#
Store =
  
  
  getStore: (name) ->
    unless __data.has(name)
      __data = __data.set(name, new Immutable.Map)
    Cursor __data, name, (data) -> __data = data
  

# Exports
#
module.exports = Store
