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

  __data[name]?[date]
  

# Store
#
Store =
  
  
  getFullState: ->
    __data
  
  
  getState: (date = @date) ->
    date = moment(date).format('YYYY-MM')

    _.reduce __data, (memo, values, name) ->
      memo[name] = lastValueFor(name, date)
      memo
    , {}
  
  
  getValue: (name, date = @date) ->
    lastValueFor(name, moment(date).format('YYYY-MM'))
  
  
  set: (name, value, date = @date) ->
    __data[name] ||= {} ; value = value.trim() ; date = moment(date).format('YYYY-MM')

    __data[name][date] = value
    
    dates = _.reduce Object.keys(__data[name]).sort(), (memo, date, index, dates) ->
      # Do not keep value if it is the same as previous
      return memo if index > 0 and __data[name][dates[index - 1]] == __data[name][date]
      
      # Do not keep value if it is empty
      return memo if _.isEmpty(__data[name][date])
      
      memo.push(date) ; memo
    , []
    
    __data[name] = _.pick(__data[name], dates)
    
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
