# Imports
#
Dispatcher    = require('cloud_flux/dispatcher')
EventEmitter  = require('event_emitter')


# Variables
#
__date    = moment().startOf('month')
__data    = {}


# Store
#
Store =
  
  
  getFullState: ->
    __data
  
  
  getCurrentState: ->
    


  getState: ->
    date = @date.format('YYYY-MM-DD')
    
    dates = _.chain(__data).map((value, key) -> key).filter((key) -> key <= date).sortBy((key) -> key).value()
    
    _.reduce dates, (memo, date) ->
      _.each __data[date], (value, key) -> memo[key] = value
      memo
    , {}


  update: (name, value) ->
    (__data[@date.format('YYYY-MM-DD')] ?= {})[name] = value
    @emitChange()
    


  emitChange: ->
    @emitEvent('change')


# Dispatch token
#
Store.__dispatchToken = Dispatcher.register (payload) ->
  action = payload.action
  
  switch action.type
    when 'timeline:date:set'
      Store.date = action.data[0]


# Extend Store with EventEmitter
#
_.extend Store, EventEmitter.prototype


# Store properties
#
Object.defineProperties Store,

  date:
    get: ->
      __date

    set: (date) ->
      __date = moment(date).startOf('month')
      @emitChange()


# Exports
#
module.exports = Store
