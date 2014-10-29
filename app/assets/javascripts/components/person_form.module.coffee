# @cjsx React.DOM

tag = React.DOM

CloudFlux = require('cloud_flux')

TimelineStore = require('stores/timeline_store')


# Schema
#
Schema =
  
  title:  'Person'
  type:   'object'

  properties:
    uuid:
      type: 'string'
    name:
      type: 'string'
    occupation:
      type:     'string'
      timeline: true
    salary:
      type:     'integer'
      timeline: true
    stock:
      type:     'number'
      timeline: true
    hired_on:
      type: 'date'
    fired_on:
      type: 'date'
    previous_occupations:
      type: 'array'
      items:
        type: 'string'
      uniqueItems:  true

  required: ['name']


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
  
  mixins: [
    CloudFlux.mixins.Actions
    CloudFlux.mixins.StoreListener
  ]
  
  
  storesToListen: [
    TimelineStore
  ]
  
  
  handleStoreChange: ->
    defaultState = _.reduce Schema.properties, (memo, value, key) ->
      memo[key] = '' if value.timeline
      memo
    , {}

    @setState(_.extend defaultState, TimelineStore.getState())
  
  
  getStateForField: (name) ->
    @state[name]
  
  
  setStateForField: (name, value) ->
    state = {} ; state[name] = value
    @setState(state)
  
  
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
  
  
  handleFieldChange: (key, event) ->
    @setStateForField(key, event.target.value)
  
  
  handleFieldBlur: (name) ->
    if Schema.properties[name].timeline
      TimelineStore.update(name, @state[name])
  
  
  handleSubmit: (event) ->
    event.preventDefault()
  
  
  componentDidMount: ->
    @triggerAction('timeline:date:set', @state.current_date)
  
  
  getInitialState: ->
    current_date:           moment().startOf('month')
    name:                   ''
    occupation:             ''
    salary:                 ''
    stock:                  ''
    hired_on:               ''
    fired_on:               ''
    previous_occupations:   ''


  render: ->
    <form className="person" onSubmit={@handleSubmit}>
      <section>
        <aside className="avatar">
          <figure></figure>
        </aside>

        <fieldset>
          <label className="name">
            <input autoFocus="true" placeholder="Name Surname" value={@state.name} onChange={@handleFieldChange.bind(null, 'name')} />
          </label>
          
          {@gatherFields()}
        </fieldset>
      </section>

      <footer>
        <div className="spacer" />
        <button>Create person</button>
      </footer>
    </form>
