# @cjsx React.DOM

tag = React.DOM


CloudFlux     = require('cloud_flux')
TimelineStore = require('stores/timeline_store')


# Exports
#
module.exports = React.createClass


  displayName: 'Timeline'
  
  
  mixins: [
    CloudFlux.mixins.StoreListener
    CloudFlux.mixins.Actions
  ]
  
  
  storesToListen: [
    TimelineStore
  ]
  

  getFluxActions: ->
    'timeline:date:set': @handleDateSet
  
  
  handleStoreChange: ->
    @setState({ timeline: TimelineStore.getFullState() })
  
  
  handleDateSet: (date) ->
    @setState({ current: moment(date).startOf('month') })


  setCurrentDate: (date) ->
    @triggerAction('timeline:date:set', date)


  gatherDates: ->
    months  = Math.ceil(moment.duration(@state.till - @state.from).as('months'))
    dates   = Object.keys(@state.timeline)

    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month').startOf('month')
      key   = now.format('YYYY-MM-DD')
      title = now.format('MMM YYYY')
      
      className = React.addons.classSet
        current:    @state.current.isSame(now)
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
    current:  till
    timeline: {}


  render: ->
    <table>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
