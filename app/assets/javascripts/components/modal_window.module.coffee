# @cjsx React.DOM


PersonFormController = require('components/person_form_controller')


# Exports
#
module.exports = React.createClass


  displayName: 'ModalWindow'

  
  render: ->
    <div className="modal-window">
      <div className="modal-container">
        <PersonFormController />
      </div>
    </div>
