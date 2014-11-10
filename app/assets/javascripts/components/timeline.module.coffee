# @cjsx React.DOM

tag = React.DOM


CloudFlux     = require('cloud_flux')
TimelineStore = require('stores/timeline_store')
Context       = require('stores/context')


# Exports
#
module.exports = React.createClass


  displayName: 'Timeline'
  
  
  mixins: [Context.mixin]


  handleDateSet: (date) ->
    @setState({ current: moment(date).startOf('month') })


  setCurrentDate: (date) ->
    #@triggerAction('timeline:date:set', date)
    Context.get('timeline').set('date', date.format('YYYY-MM-DD'))


  gatherDates: ->
    months  = Math.ceil(moment.duration(@state.till - @state.from).as('months'))
    dates   = Object.keys(@state.timeline)
    current = moment(Context.get(['timeline', 'date']).deref()).startOf('month')
    
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
  

  getInitialState: ->
    from  = moment(new Date(@props.from)).startOf('month')
    till  = moment(new Date(@props.till)).startOf('month')

    from:     from
    till:     till
    timeline: {}
      


  render: ->
    console.log 'render timeline'
    <table>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
