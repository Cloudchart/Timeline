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
      autoFocus   = {props.autoFocus == props.key}
      placeholder = {props.placeholder}
      value       = {value}
      onBlur      = {props.onUpdate.bind(null, props.key)}
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
      getValue:   @getStateForField
      onUpdate:   @handleFieldUpdate
      onChange:   @handleFieldChange
    
    _.map Fields, (field) =>
      createField _.extend {}, commonProps,
        key:          field.key
        className:    field.key
        placeholder:  field.placeholder   || ''
        title:        field.title         || ''
  
  
  handleFieldChange: (name, event) ->
    @setStateForField(name, event.target.value)
  
  
  handleFieldUpdate: ->
    @props.onFormUpdate(@state.attributes.toJS())
  
  
  handleSubmit: (event) ->
    event.preventDefault()
    @props.onFormSubmit(@state.attributes.toJS())
  
  
  getStateFromProps: (props) ->
    attributes: Immutable.fromJS(props.attributes)
  
  
  componentWillReceiveProps: (nextProps) ->
    @setState(@getStateFromProps(nextProps))
  
  
  getDefaultProps: ->
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
