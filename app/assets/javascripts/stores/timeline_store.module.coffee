# Imports
#
Dispatcher    = require('cloud_flux/dispatcher')
EventEmitter  = require('event_emitter')


# Variables
#
__date    = moment().startOf('month')
__data    = {}


# Functions
#
lastValueFor = (name, now) ->
  date = _.chain(__data[name])
    .keys()
    .sort()
    .filter (date) -> date <= now
    .last()
    .value()
  
  result = {}

  if date
    result[date] = __data[name][date]
  else
    result
  
  result


# Store
#
Store =
  
  
  getState: (date = @date) ->
    date = date.format('YYYY-MM')

    _.reduce __data, (memo, values, name) ->
      memo[name] = lastValueFor(name, date)
      memo
    , {}
  
  
  set: (name, value, date = @date) ->
    __data[name] ||= {} ; value = value.trim() ; date = moment(date).format('YYYY-MM')

    __data[name][date] = value
    
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
