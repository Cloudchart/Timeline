# @cjsx React.DOM

tag = React.DOM

dispatcher = require('cloud_flux/dispatcher')


# Exports
#
module.exports = React.createClass


  displayName: 'Timeline'


  setCurrentDate: (date) ->
    dispatcher.handleClientAction({ type: 'timeline:set-current', date: date })


  gatherDates: ->
    months  = Math.ceil(moment.duration(@state.till - @state.from).as('months'))

    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month')
      key   = now.format('YYYY-MM-DD')
      title = now.format('MMM YYYY')
      
      className = React.addons.classSet({ current: @state.current == key })
        
      <td key={key} className={className} data-title={title} onClick={@setCurrentDate.bind(@, key)}>
        {<span className="year">{now.format('YYYY')}</span> if now.month() == 0}
        &nbsp;
      </td>
  

  componentDidMount: ->
    @dispatcherToken = dispatcher.register (payload) =>
      if payload.action.type == 'timeline:set-current'
        @setState({ current: payload.action.date })
        


  getInitialState: ->
    from  = moment(new Date(@props.from))
    till  = moment(new Date(@props.till))
    from:     from
    till:     till
    current:  till.format('YYYY-MM-DD')


  render: ->
    <table>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
