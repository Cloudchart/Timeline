module.exports =
  title:  'Person'
  type:   'object'

  properties:

    id:
      type: 'integer'

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
