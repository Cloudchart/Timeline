# @cjsx React.DOM


# Fields
#
Fields = [
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
  

# Exports
#
module.exports = React.createClass


  displayName: 'Person Form'
  
  getStateForField: (name) ->
    @state.attributes.get(name) || ''
  
  
  setStateForField: (name, value) ->
    @setState
      attributes: @state.attributes.set(name, value)
  
  
  gatherFields: ->
    _.map Fields, (field) =>
      title = <span>{field.title}</span> if field.title

      <label key={field.key} className={field.key}>
        {title}
        <input
          placeholder   = {field.placeholder}
          value         = {@getStateForField(field.key)}
          onBlur        = {@handleFieldBlur.bind(null, field.key)}
          onChange      = {@handleFieldChange.bind(null, field.key)}
        />
      </label>
  
  
  handleFieldChange: (name, event) ->
    @setStateForField(name, event.target.value)
  
  
  handleFieldBlur: ->
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
    submit_button = <button>Create person</button>

    <form className="person" onSubmit={@handleSubmit}>
      <section>
        <aside className="avatar">
          <figure></figure>
        </aside>

        <fieldset>
          <label className="name">
            <input autoFocus="true" placeholder="Name Surname" value={@getStateForField('name')} onChange={@handleFieldChange.bind(null, 'name')} />
          </label>
          
          {@gatherFields()}
        </fieldset>
      </section>

      <footer>
        <div className="spacer" />
        {submit_button}
      </footer>
    </form>
