# @cjsx

Context         = require('stores/context')
PersonForm      = require('components/person_form')
Schema          = require('schema/person')


# Main
#
module.exports = React.createClass


  displayName: 'PersonFormController'


  gatherAttributes: (now = @props.cursor.date.deref()) ->
    attributes = @props.cursor.attributes.deref({})
    
    _.extend attributes, _.reduce @props.cursor.timelineAttributes.deref({}), (memo, values, name) =>
      memo[name] = values[now] || null
      memo
    , {}
    
    attributes
  
  
  gatherPlaceholders: ->
    now                 = @props.cursor.date.deref({})
    timelineAttributes  = Immutable.fromJS(@props.cursor.timelineAttributes.deref({}))

    _.reduce @props.timelineAttributesNames, (memo, name) =>
      if values = timelineAttributes.get(name)
        memo[name] = values.get(values.filter((v, k) -> k < now).keySeq().max())
      memo
    , {}
  
  
  handleFieldFocus: (name) ->
    cursor = Context.cursor(['timeline', 'focus'])
    if name then cursor.update (-> name) else cursor.clear()
  
  
  handleFormUpdate: (attributes, now = @props.cursor.date.deref()) ->
    prevAttributes    = @gatherAttributes(now)

    changedAttributes = _.reduce attributes, (memo, value, name) ->
      memo[name] = value unless Immutable.is(prevAttributes[name], value)
      memo
    , {}
    
    return if _.size(changedAttributes) is 0
    
    changedTimelineAttributes = _.reduce changedAttributes, (memo, value, name) ->
      if Schema.properties[name].timeline is true
        memo[name] = value
      memo
    , {}
    
    
    changedAttributes = _.omit changedAttributes, Object.keys(changedTimelineAttributes)
    
    
    unless _.size(changedAttributes) is 0
      @props.cursor.attributes.update (attributes = {}) => _.extend attributes, changedAttributes
    
    
    unless _.size(changedTimelineAttributes) is 0
      
      changedTimelineAttributes = _.reduce changedTimelineAttributes, (memo, value, name) =>

        if value
          memo.setIn([name, now], value)
        else
          memo.removeIn([name, now])

      , Immutable.fromJS(@props.cursor.timelineAttributes.deref({}))
      
      @props.cursor.timelineAttributes.update (attributes = {}) => Immutable.fromJS(attributes).merge(changedTimelineAttributes).toJS()

  

  handleFormSubmit: (attributes) ->
  
  
  componentWillReceiveProps: ->
    if @props.cursor.date.isChanged()
      @handleFormUpdate(@refs['form'].getAttributes(), @props.cursor.date.derefPrev())
      
    
  
  shouldComponentUpdate: ->
    @props.cursor.date.isChanged() or
    @props.cursor.attributes.isChanged() or
    @props.cursor.timelineAttributes.isChanged()
    
  
  getDefaultProps: ->
    timelineAttributesNames: _.filter(Object.keys(Schema.properties), (name) -> Schema.properties[name].timeline)
  
  
  render: ->
    <PersonForm
      ref           = "form"
      onFieldFocus  = {@handleFieldFocus}
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@gatherAttributes()}
      placeholders  = {@gatherPlaceholders()}
      errors        = {{}}
    />
