# Imports
#
tag = React.DOM

People = require('components/people')


# Main
#
module.exports = React.createClass


  displayName: 'CompanyApp'
  
  
  render: ->
    (tag.article {
      className: 'editor'
    },
      
      (tag.section {
        className: 'people'
      },
      
        (People null)
      
      )
      
    )
