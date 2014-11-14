# @cjsx React.DOM


# Fields
#
Fields = [
  {
    key:          'name'
    placeholder:  'Name Surname'
  }
  {
    key:          'occupation'
    title:        'Occupation'
    placeholder:  'Occupation'
  }
  {
    key:          'salary'
    title:        'Salary'
    placeholder:  'Salary'
  }
  {
    key:          'stock'
    title:        'Stock'
    placeholder:  'Stock'
  }
  {
    key:          'hired_on'
    title:        'Hired'
    placeholder:  'Hired on'
  }
  {
    key:          'fired_on'
    title:        'Fired'
    placeholder:  'Fired on'
  }
  {
    key:          'previous_occupations'
    title:        'Previous'
    placeholder:  'Previous Occupations'
  }
]


# Functions
#
createField = (props) ->
  value = props.getValue.call(null, props.key)
  title = <span>{props.title}</span> if props.title

  <label key={props.key} className={props.className}>
    {title}
    <input
      ref         = {props.ref}
      autoFocus   = {props.autoFocus == props.key}
      className   = { if props.errors then 'error' else null}
      placeholder = {props.placeholder}
      value       = {value}
      onBlur      = {props.onUpdate.bind(null, props.key)}
      onFocus     = {props.onFocus.bind(null, props.key)}
      onChange    = {props.onChange.bind(null, props.key)}
    />
  </label>


# Exports
#
module.exports = React.createClass


  contextTypes: { cloudflux: -> }


  displayName: 'Person Form'
  

  getStateForField: (name) ->
    @state.attributes.get(name) || ''
  
  
  setStateForField: (name, value) ->
    @setState
      attributes: @state.attributes.set(name, value)
  
  
  gatherFields: ->
    
    commonProps =
      autoFocus:  'name'
      onFocus:    @handleFieldFocus
      getValue:   @getStateForField
      onUpdate:   @handleFieldUpdate
      onChange:   @handleFieldChange
    
    _.map Fields, (field) =>
      createField _.extend {}, commonProps,
        key:          field.key
        ref:          field.key
        className:    field.key
        placeholder:  @props.placeholders[field.key] || field.placeholder   || ''
        title:        field.title         || ''
        errors:       @props.errors[field.key]
  
  
  handleFieldChange: (name, event) ->
    @setStateForField(name, event.target.value)
  
  
  getAttributes: ->
    @state.attributes.toJS()
  
  
  handleFieldUpdate: ->
    @props.onFieldFocus(null)
    @props.onFormUpdate(@getAttributes())
  
  
  handleFieldFocus: (name) ->
    @props.onFieldFocus(name)
  
  
  handleSubmit: (event) ->
    event.preventDefault()
    @props.onFormSubmit(@state.attributes.toJS())
  
  
  getStateFromProps: (props) ->
    attributes: Immutable.fromJS(props.attributes)
  
  
  componentWillReceiveProps: (nextProps) ->
    @setState(@getStateFromProps(nextProps))
  
  
  componentDidUpdate: (prevProps, prevState) ->
    if component = @refs[@props.focus]
      component.getDOMNode().focus()
  
  
  getDefaultProps: ->
    onFieldFocus: _.noop
    onFormUpdate: _.noop
    onFormSubmit: _.noop
  
  
  getInitialState: ->
    @getStateFromProps(@props)


  render: ->
    submit_button = <button>Create person <i className="fa fa-check" /></button>

    <form className="person" onSubmit={@handleSubmit}>
      <section>
        <aside className="avatar">
          <figure></figure>
        </aside>

        <fieldset>
          {@gatherFields()}
        </fieldset>
      </section>

      <footer>
        <div className="spacer" />
        {submit_button}
      </footer>
    </form>
