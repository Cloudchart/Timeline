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
  
  
  filterActiveDates: ->
    if attribute = @props.cursor.get('focus')
      Immutable.fromJS(@props.cursor.get('timeline-attributes'))?.get(attribute)?.keySeq().toArray()
    else
      Immutable.fromJS(@props.cursor.get('timeline-attributes'))?.valueSeq().flatMap(-> arguments[0].keySeq()).flatten().toSet().toJS()
  
  
  filterActiveRange: (now, till) ->
    cursor = Immutable.fromJS(@props.cursor.get('timeline-attributes', {}))
    if values = cursor.get(@props.cursor.get('focus'))
      { start: now, finish: values.keySeq().filter((date) -> date > now).min() || till }
    else
      {}
    
  
  
  gatherDates: ->
    months      = Math.ceil(moment.duration(@state.till - @state.from).as('months'))
    current     = moment(@props.cursor.get('date')).startOf('month')
    
    dates       = @filterActiveDates()
    range       = @filterActiveRange(current.format('YYYY-MM-DD'), @state.till.format('YYYY-MM-DD'))
    
    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month').startOf('month')
      key   = now.format('YYYY-MM-DD')
      title = now.format('MMM YYYY')
      
      className = React.addons.classSet
        current:    current.isSame(now)
        effective:  _.contains(dates, key)
        range:      key >= range.start and key <= range.finish
      
      <td key={key} className={className} data-title={title} onClick={@setCurrentDate.bind(@, now)}>
        {<span className="year">{now.format('YYYY')}</span> if now.month() == 0}
        &nbsp;
      </td>
  
  
  handleMouseDown: (event) ->
    event.preventDefault()
  
  
  componentDidMount: ->
    unless @props.cursor.get('date')
      @props.cursor.set('date', moment().startOf('month').format('YYYY-MM-DD'))
  
  
  shouldComponentUpdate: (nextProps, nextState) ->
    nextProps.cursor.isChanged()
  
  
  getDefaultProps: ->
    cursor: Context.cursor('timeline')


  getInitialState: ->
    from  = moment(new Date(@props.from)).startOf('month')
    till  = moment(new Date(@props.till)).startOf('month')

    from:     from
    till:     till
    timeline: {}
    

  render: ->
    <table onMouseDown={@handleMouseDown}>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
