# @cjsx React.DOM


# Exports
#
module.exports = React.createClass


  setCurrentDate: (date) ->
    @setState
      current: date


  gatherDates: ->
    months  = Math.ceil(moment.duration(@state.till - @state.from).as('months'))

    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month')
      key   = now.format('YYYY-MM-DD')
      title = now.format('MMM YYYY')
      
      className = React.addons.classSet({ current: @state.current == key })

      <td key={key} className={className} data-title={title} onClick={@setCurrentDate.bind(@, key)}>&nbsp;</td>


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
