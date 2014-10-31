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
    attributes = _.reduce TimelineStore.getState(), (memo, value, name) ->
      unless _.isEmpty(value)
        memo[name]            = _.values(value)[0]
        memo["#{name}_date"]  = _.keys(value)[0]
      memo
    , {}
    
    @setState
      date:       TimelineStore.date
      attributes: attributes


  handleFormUpdate: (attributes) ->
    _.each filterChangedAttributes(@state.attributes, attributes), (value, name) =>
      TimelineStore.set(name, value)
    
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
