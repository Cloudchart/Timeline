# @cjsx React.DOM


Context = require('stores/context')
PersonFormController = require('components/person_form_controller')


# Exports
#
module.exports = React.createClass


  displayName: 'ModalWindow'

  
  render: ->
    cursor =
      date:                 Context.cursor(['timeline', 'date'])
      keepFocus:            Context.cursor(['timeline', 'keep-focus'])
      attributes:           Context.cursor(['timeline', 'attributes'])
      timelineAttributes:   Context.cursor(['timeline', 'timeline-attributes'])
    
    <div className="modal-window">
      <div className="modal-container">
        <PersonFormController cursor={ cursor } />
      </div>
    </div>
