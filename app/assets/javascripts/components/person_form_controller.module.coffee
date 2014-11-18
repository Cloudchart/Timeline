# @cjsx

Context         = require('stores/context')
PersonForm      = require('components/person_form')
Schema          = require('schema/person')

TimelineAttributesNames = Immutable.fromJS(_.filter(Object.keys(Schema.properties), (name) -> Schema.properties[name].timeline))


# Main
#
module.exports = React.createClass


  displayName: 'PersonFormController'


  gatherAttributes: (now = @props.cursor.date.deref()) ->
    attributes                = @props.cursor.attributes.deref({})
    timelineAttributes        = @props.cursor.timelineAttributes.deref({})
    timelineAttributesForNow  = timelineAttributes.mapEntries ([k, v]) -> [k, v.get(now, null)]
    
    attributes.merge(timelineAttributesForNow)
    
  
  
  gatherPlaceholders: ->
    now                 = @props.cursor.date.deref()
    timelineAttributes  = @props.cursor.timelineAttributes.deref({})

    timelineAttributes.mapEntries ([k, v]) -> [k, v.filter((v, k) -> k < now).maxBy((v, k) -> k)]
  
  
  handleFieldFocus: (name) ->
    cursor = Context.cursor(['timeline', 'focus'])

    clearTimeout(@_focusTimeout)

    unless name
      @_focusTimeout = setTimeout (-> cursor.clear()), 100
    else
      Context.cursor('timeline.keep-focus').clear()
      cursor.update (-> name)
  
  
  handleFormUpdate: (attributes, now = @props.cursor.date.deref()) ->
    nextAttributes          = Immutable.fromJS(attributes)
    prevAttributes          = @props.cursor.attributes.deref({})
    prevTimelineAttributes  = @props.cursor.timelineAttributes.deref({})

    
    changedAttributes = nextAttributes.filter (v, k) ->
      !Immutable.is(prevAttributes.get(k), v) and !TimelineAttributesNames.contains(k)
    
    
    changedTimelineAttributes = nextAttributes.filter (v, k) ->
      !Immutable.is(prevTimelineAttributes.getIn([k, now]), v) and TimelineAttributesNames.contains(k)
    

    changedTimelineAttributes = changedTimelineAttributes.mapEntries ([k, v]) ->
      v = if v then prevTimelineAttributes.setIn([k, now], v) else prevTimelineAttributes.removeIn([k, now])
      [k, v.get(k)]
    

    if changedAttributes.size > 0
      @props.cursor.attributes.update (attributes = new Immutable.Map) -> attributes.merge(changedAttributes)
    

    if changedTimelineAttributes.size > 0
      @props.cursor.timelineAttributes.update (attributes = new Immutable.Map) -> attributes.merge(changedTimelineAttributes)


  handleFormSubmit: (attributes) ->
    
    
  componentDidMount: ->
    Context.cursor(['timeline']).set('timeline-attributes-names', TimelineAttributesNames)
  
  
  shouldComponentUpdate: ->
    @props.cursor.date.isChanged() or
    @props.cursor.attributes.isChanged() or
    @props.cursor.timelineAttributes.isChanged() or
    !!Context.cursor('timeline.keep-focus').deref()
    
  
  getDefaultProps: ->
    timelineAttributesNames: _.filter(Object.keys(Schema.properties), (name) -> Schema.properties[name].timeline)
  
  
  render: ->
    <PersonForm
      ref           = "form"
      onFieldFocus  = {@handleFieldFocus}
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@gatherAttributes().toJS()}
      placeholders  = {@gatherPlaceholders().toJS()}
      errors        = {{}}
      focus         = {Context.cursor('timeline.keep-focus').deref()}
    />
