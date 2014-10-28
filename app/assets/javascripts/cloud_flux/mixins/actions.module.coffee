dispatcher = require('cloud_flux/dispatcher')


module.exports =
  

  componentDidMount: ->
    if _.isFunction(@getFluxActions) and _.isPlainObject(fluxActions = @getFluxActions())
      @__dispatchToken = dispatcher.register (payload) =>
        action = payload.action
        if (handler = fluxActions[action.type]) and _.isFunction(handler)
          handler.apply(@, action.data) if @isMounted()
  
  
  componentWillUnmount: ->
    if @__dispatchToken
      dispatcher.unregister(@__dispatchToken)


  triggerAction: (type, args...) ->
    dispatcher.handleClientAction
      type: type
      data: args
