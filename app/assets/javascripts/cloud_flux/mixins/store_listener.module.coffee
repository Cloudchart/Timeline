module.exports =
  
  
  componentDidMount: ->
    _.each @storesToListen, (store) =>
      if _.isFunction(@handleStoreChange)
        store.addListener('change', @handleStoreChange)
  
  
  componentWillUnmount: ->
    _.each @storesToListen, (store) =>
      if _.isFunction(@handleStoreChange)
        store.removeListener('change', @handleStoreChange)
