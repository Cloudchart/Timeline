# @cjsx

Context         = require('stores/context')
PersonForm      = require('components/person_form')
Schema          = require('schema/person')


# Main
#
module.exports = React.createClass


  displayName: 'PersonFormController'


  gatherAttributes: ->
    attributes = @props.cursor.attributes.deref({})
    
    now = @props.cursor.date.deref({})
    
    _.extend attributes, _.reduce @props.cursor.timelineAttributes.deref({}), (memo, values, name) =>
      memo[name] = values[now] if values[now]
      memo
    , {}
    
    attributes
  
  
  gatherPlaceholders: ->
    {}
  
  
  handleFieldFocus: (name) ->
    Context.cursor('timeline').set('focus', name)
  
  
  handleFormUpdate: (attributes) ->
    prevAttributes    = @gatherAttributes()

    changedAttributes = _.reduce attributes, (memo, value, name) ->
      memo[name] = value unless Immutable.is(prevAttributes[name], value)
      memo
    , {}
    
    return if _.size(changedAttributes) is 0
    
    changedTimelineAttributes = _.reduce changedAttributes, (memo, value, name) ->
      if Schema.properties[name].timeline is true
        memo[name] = value ; delete changedAttributes[name]
      memo
    , {}
    

    unless _.size(changedAttributes) is 0
      @props.cursor.attributes.update (attributes = {}) => _.extend attributes, changedAttributes
    
    
    unless _.size(changedTimelineAttributes) is 0
      now = @props.cursor.date.deref()

      changedTimelineAttributes = _.reduce changedTimelineAttributes, (memo, value, name) =>
        previousValues = @props.cursor.timelineAttributes.get(name, {})
        
        if value
          previousValues[now] = value
        else
          delete previousValues[now]
        
        memo[name] = previousValues ; memo
      , {}
      
      @props.cursor.timelineAttributes.update (attributes = {}) => _.extend attributes, changedTimelineAttributes

  
  handleFormSubmit: (attributes) ->
    
  
  shouldComponentUpdate: ->
    @props.cursor.date.isChanged() or
    @props.cursor.keepFocus.isChanged() or
    @props.cursor.attributes.isChanged() or
    @props.cursor.timelineAttributes.isChanged()
    
  
  
  render: ->
    console.log 'render'
    <PersonForm
      ref           = "form"
      focus         = {Context.cursor('timeline').get('keep-focus')}
      onFieldFocus  = {@handleFieldFocus}
      onFormUpdate  = {@handleFormUpdate}
      onFormSubmit  = {@handleFormSubmit}
      attributes    = {@gatherAttributes()}
      placeholders  = {@gatherPlaceholders()}
      errors        = {{}}
    />
