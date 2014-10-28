# Imports
#
EventEmitter = require('event_emitter')


# Variables
#
__date    = moment().startOf('month')
__data    = {}
__owners  = []


# Store
#
Store =


  emitChange: ->
    @emitEvent('change')


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
