tag = React.DOM


Schema =
  
  title:  'Person'
  type:   'object'

  properties:
    uuid:
      type: 'string'
    name:
      type: 'string'
    occupation:
      type: 'string'
    salary:
      type: 'integer'
    stock:
      type: 'number'
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
  
  
  handleFieldChange: (key, event) ->
    state       = {}
    state[key]  = event.target.value
    @setState(state)
  
  
  handleSubmit: (event) ->
    event.preventDefault()
  
  
  getInitialState: ->
    {
      name:         ''
      occupation:   ''
    }


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
