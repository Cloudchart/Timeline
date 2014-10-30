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
  
  
  getState: ->
    __data


  update: (name, value, date = @date) ->
    (__data[name] ||= {})[moment(date).format('YYYY-DD')] = value
    @emitChange()
  
  
  remove: (name, date = @date) ->
    delete (__data[name] ||= {})[moment(date).format('YYYY-DD')]
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
