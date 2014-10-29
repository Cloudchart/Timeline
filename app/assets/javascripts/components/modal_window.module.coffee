# @cjsx React.DOM


PersonForm = require('components/person_form')


# Exports
#
module.exports = React.createClass


  displayName: 'Modal Window'

  
  render: ->
    <div className="modal-window">
      <div className="modal-container">
        <PersonForm />
      </div>
    </div>
