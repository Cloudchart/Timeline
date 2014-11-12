# @cjsx React.DOM

tag = React.DOM


CloudFlux     = require('cloud_flux')
TimelineStore = require('stores/timeline_store')
Context       = require('stores/context')


# Exports
#
module.exports = React.createClass


  displayName: 'Timeline'
  
  
  setCurrentDate: (date) ->
    @props.cursor.set('date', date.format('YYYY-MM-DD'))


  gatherDates: ->
    months  = Math.ceil(moment.duration(@state.till - @state.from).as('months'))
    dates   = Object.keys(@state.timeline)
    current = moment(@props.cursor.get('date')).startOf('month')
    
    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month').startOf('month')
      key   = now.format('YYYY-MM')
      title = now.format('MMM YYYY')
      
      className = React.addons.classSet
        current:    current.isSame(now)
        effective:  _.contains(dates, key)
        
      <td key={key} className={className} data-title={title} onClick={@setCurrentDate.bind(@, now)}>
        {<span className="year">{now.format('YYYY')}</span> if now.month() == 0}
        &nbsp;
      </td>
  
  
  componentDidMount: ->
    unless @props.cursor.get('date')
      @props.cursor.set('date', moment().startOf('month').format('YYYY-MM-DD'))
  
  
  getDefaultProps: ->
    cursor: Context.cursor('timeline')


  getInitialState: ->
    from  = moment(new Date(@props.from)).startOf('month')
    till  = moment(new Date(@props.till)).startOf('month')

    from:     from
    till:     till
    timeline: {}
    

  render: ->
    <table>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
