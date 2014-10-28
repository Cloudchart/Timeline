tag = React.DOM


CloudFlux = require('cloud_flux')


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
  ]
  
  
  
  getFluxActions: ->
    'timeline:date:set': @handleTimelineDateSet
  
  
  gatherFields: ->
    _.map Fields, (field) =>
      (tag.label {
        key:        field.key
        className:  field.key
      },
        (tag.span null, field.title) if field.title
        (tag.input {
          placeholder:  field.placeholder
          value:        @state[field.key]
          onChange:     @handleFieldChange.bind(@, field.key)
        })
      )
  
  
  handleTimelineDateSet: (date) ->
    unless date == @state.current_date
      console.log 'change date', date, @state.current_date
  
  
  handleFieldChange: (key, event) ->
    state       = {}
    state[key]  = event.target.value
    @setState(state)
  
  
  handleFieldBlur: (key) ->
    
  
  
  handleSubmit: (event) ->
    event.preventDefault()
  
  
  componentDidMount: ->
    @triggerAction('timeline:date:set', @state.current_date)
  
  
  getInitialState: ->
    name:                   ''
    occupation:             ''
    salary:                 ''
    stock:                  ''
    hired_on:               ''
    fired_on:               ''
    previous_occupations:   ''
    current_date:           moment().startOf('month')


  render: ->
    (tag.form {
      className:  'person'
      onSubmit:   @handleSubmit
    },
    
      # Form content
      #
      (tag.section null,
        
        # Avatar
        #
        (tag.aside {
          className: 'avatar'
        },
          (tag.figure null)
        )

        # Fields
        #
        (tag.fieldset null,
        
          # Name
          #
          (tag.label {
            className: 'name'
          },
            (tag.input {
              autoFocus:    true
              placeholder:  'Name Surname'
            })
          )
          
          # Other fields
          #
          @gatherFields()
          
        )
        
      )
    
      # Footer
      #
      (tag.footer null,
        (tag.div { className: 'spacer' })
        (tag.button null, 'Create person')
      )
    
    )
