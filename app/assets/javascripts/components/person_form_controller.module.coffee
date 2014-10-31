# @cjsx

CloudFlux       = require('cloud_flux')
PersonForm      = require('components/person_form')
TimelineStore   = require('stores/timeline_store')
Schema          = require('schema/person')



filterTimelineProperties = (properties) ->
  transducers.into(
    []
    transducers.compose(
      transducers.filter  (kv) -> kv[1].timeline
      transducers.map     (kv) -> kv[0]
    )
    properties
  )


filterChangedAttributes = (a, b) ->
  transducers.seq(
    b
    transducers.filter (x) -> x[1] isnt a.get(x[0])
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
    @setState
      date:       TimelineStore.date
      attributes: @gatherAttributes()
  
  
  gatherAttributes: ->
    timeline_properties = filterTimelineProperties(Schema.properties)
    
    timeline_attributes = _.reduce timeline_properties, (memo, name) ->
      memo[name] = TimelineStore.getValue(name) || '' ; memo
    , {}
    
    @state.attributes.merge(timeline_attributes)


  handleFormUpdate: (attributes) ->
    _.each filterChangedAttributes(@state.attributes, attributes), (value, name) =>
      TimelineStore.set(name, value) if Schema.properties[name].timeline
    
    #@setState({ attributes: @state.attributes.merge(attributes) })
  
  
  handleFormSubmit: (attributes) ->
    @setState({ attributes: attributes })
  
  
  getDefaultProps: ->
    attributes: new Immutable.Map
  
  
  getInitialState: ->
    date:       TimelineStore.date
    attributes: @props.attributes


  render: ->
    <PersonForm
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@state.attributes.toJS()}
    />
