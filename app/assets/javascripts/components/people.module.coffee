# @cjsx React.DOM



# Exports
#
module.exports = React.createClass


  displayName: 'People'
  
  
  handleNewPersonClick: ->


  render: ->
    <ul>
      <li className="new">
        <button onClick={@handleNewPersonClick}>Add person</button>
      </li>
    </ul>
