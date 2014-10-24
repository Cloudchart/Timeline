class Dispatcher extends Flux.Dispatcher


  handleServerAction: (action) ->
    payload =
      action: action
      source: 'server'
    @dispatch(payload)
  
  
  handleClientAction: (action) ->
    payload =
      action: action
      source: 'client'
    @dispatch(payload)


module.exports = new Dispatcher
