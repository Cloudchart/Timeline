# @cjsx

CloudFlux       = require('cloud_flux')
PersonForm      = require('components/person_form')
TimelineStore   = require('stores/timeline_store')
Schema          = require('schema/person')


filterChangedAttributes = (a, b) ->
  transducers.seq(
    b
    transducers.filter (kv) -> kv[1] isnt a[kv[0]]
  )


# Main
#
module.exports = React.createClass


  mixins: [
    CloudFlux.mixins.StoreListener
  ]
  
  
  storesToListen: [
    TimelineStore
  ]
  
  
  handleStoreChange: ->
    attributes = TimelineStore.getState()

    currentDate = @state.date.format('YYYY-MM')

    console.log _.reduce attributes, (memo, value, name) ->
      memo
    , {}
    
    @setState
      date: TimelineStore.date


  handleFormUpdate: (attributes) ->
    _.each filterChangedAttributes(@state.attributes, attributes), (value, name) =>
      if value.trim().length == 0
        TimelineStore.remove(name)
      else
        TimelineStore.update(name, value)
    
    @setState({ attributes: attributes })
  
  
  handleFormSubmit: (attributes) ->
    @setState({ attributes: attributes })
  
  
  getDefaultProps: ->
    attributes: {}
  
  
  getInitialState: ->
    date:       TimelineStore.date
    attributes: @props.attributes


  render: ->
    <PersonForm
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@state.attributes}
    />
