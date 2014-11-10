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


  displayName: 'Person Form Controller'


  mixins: [
    CloudFlux.mixins.StoreListener
  ]
  
  
  storesToListen: [
    TimelineStore
  ]
  
  
  handleStoreChange: ->
    @setState
      attributes: @gatherAttributes()
  
  
  gatherAttributes: ->
    timeline_properties = filterTimelineProperties(Schema.properties)
    
    timeline_attributes = _.reduce timeline_properties, (memo, name) ->
      memo[name] = TimelineStore.getValue(name) || '' ; memo
    , {}
    
    @state.attributes.merge(timeline_attributes)


  handleFormUpdate: (attributes) ->
    _.each filterChangedAttributes(@state.attributes, attributes), (value, name) =>

      if Schema.properties[name].timeline
        TimelineStore.set(name, value)
      else
        @setState({ attributes: @state.attributes.set(name, value) })
  
  
  handleFormSubmit: (attributes) ->
    @handleFormUpdate(attributes)
    console.log JSON.stringify(_.extend attributes, TimelineStore.getFullState())
  
  
  getDefaultProps: ->
    attributes: new Immutable.Map
  
  
  getInitialState: ->
    attributes: @props.attributes


  render: ->
    <PersonForm
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@state.attributes.toJS()}
    />
