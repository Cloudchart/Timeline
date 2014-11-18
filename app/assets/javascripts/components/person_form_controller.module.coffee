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
    
    attributes.update =>
      @props.cursor.timelineAttributes.deref({}).mapEntries ([k, v]) ->
        [k, v.get(now, null)]
  
  
  gatherPlaceholders: ->
    now = @props.cursor.date.deref()

    @props.cursor.timelineAttributes.deref({}).mapEntries ([k, v]) ->
      [k, v.filter((v, k) -> k < now).maxBy((v, k) -> k)]
  
  
  handleFieldFocus: (name) ->
    cursor = Context.cursor(['timeline', 'focus'])

    clearTimeout(@_focusTimeout)

    unless name
      @_focusTimeout = setTimeout (-> cursor.clear()), 100
    else
      Context.cursor('timeline.keep-focus').clear()
      cursor.update (-> name)
  
  
  handleFormUpdate: (attributes, now = @props.cursor.date.deref()) ->
    prevAttributes    = @gatherAttributes(now)

    changedAttributes = _.reduce attributes, (memo, value, name) ->
      memo[name] = value unless Immutable.is(prevAttributes.get(name), value)
      memo
    , {}
    
    return if changedAttributes.size is 0
    
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

      , @props.cursor.timelineAttributes.deref({})
      
      @props.cursor.timelineAttributes.update (attributes = {}) => Immutable.fromJS(attributes).merge(changedTimelineAttributes).toJS()

  

  handleFormSubmit: (attributes) ->
    
    
  componentDidMount: ->
    @props.cursor.timelineAttributes.update =>
      _.reduce @props.timelineAttributesNames, (memo, name) ->
        memo[name] = {} ; memo
      , {}
  
  
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
