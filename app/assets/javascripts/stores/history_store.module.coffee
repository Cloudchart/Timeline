# Imports
#
EventEmitter  = require('event_emitter')
uuid          = require('utils/uuid')


# Data
#
__data = new Immutable.Map


# Functions
#
validateItem = (item) ->
  # Validate presence of required fields
  #
  _.each ['owner_id', 'owner_type', 'name', 'data'], (name) ->
    throw new Error("HistoryStore.set: #{name} should be defined.") unless item.get(name)

  # Validates data field is a Immutable.Map
  #
  throw new Error("HistoryStore.set: data should be a Map.") unless item.get('data') instanceof Immutable.Map


# Store
#
# Attributes
#     id
#   * owner_id
#   * owner_type
#   * name
#   * data
#       { date: value, date: value, ..., date: value }
#
Store =


  # Get
  #
  get: (id) ->
    __data.get(id)
  
  
  # Find
  #
  find: (finder) ->
    __data.find(finder)
  
  
  # Filter
  #
  filter: (filterer) ->
    __data.filter(filterer)
  
  
  # Set
  #
  set: (id, attributes = {}, skip_emit = false) ->
    item = Immutable.fromJS(attributes)
    
    validateItem(item)

    __data = __data.set(id, item)
    
    @emitChange(id) unless skip_emit

    @get(id)
  
  
  # Remove
  #
  remove: (id, skip_emit = false) ->
    item = @get('id')

    __data = __data.remove(id)
    
    @emitChange(id) unless skip_emit
    
    item
  
  
  # Build
  #
  build: (attributes = {}) ->
    id = uuid()

    attributes = _.extend(
      id:   id
      data: {}
    , attributes)

    @set(id, attributes)
  
  
  # Update
  #
  update: (id, data = {}) ->
    item = @get(id).updateIn ['data'], (map) ->
      map.withMutations (map) ->
        _.each data, (value, date) ->
          map = if value then map.set(date, value) else map.remove(date)

    @set(item.get('id'), item.toJS())
  
  
  # Emit Change
  #
  emitChange: (id) ->
    @emit('change', @, id)


# Store as Event Emitter
#
_.extend Store, EventEmitter.prototype
  

# Exports
#
module.exports = Store
