tag = React.DOM


PersonForm = React.createFactory require('components/person_form')


# Exports
#
module.exports = React.createClass


  displayName: 'Modal Window'

  
  render: ->
    (tag.div {
      className: 'modal-window'
    },
      (tag.div {
        className: 'modal-container'
      },
        (PersonForm null)
      )
    )
