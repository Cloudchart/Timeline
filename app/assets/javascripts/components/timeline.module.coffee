# @cjsx React.DOM

tag = React.DOM


CloudFlux     = require('cloud_flux')
TimelineStore = require('stores/timeline_store')
Context       = require('stores/context')


uniqueValues = (sequence) ->
  sequence.valueSeq().flatMap((v, k) -> v.keySeq()).flatten().toSet()


# Exports
#
module.exports = React.createClass


  displayName: 'Timeline'
  
  
  setCurrentDate: (date) ->
    @props.cursor.set('date', date.format('YYYY-MM-DD'))
  
  
  filterActiveDates: ->
    key       = @props.cursor.get('focus')
    sequence  = Immutable.fromJS(@props.cursor.get('timeline-attributes', {})).toSeq()
    sequence  = sequence.filter(-> arguments[1] == key) if sequence.has(key)

    uniqueValues(sequence)
  
  
  filterActiveRange: (now, till) ->
    timelineAttributesNames = @props.cursor.get('timeline-attributes-names', [])
    focusedAttributeName    = @props.cursor.get('focus')
    
    if timelineAttributesNames.contains(focusedAttributeName)
      valuesForAttribute  = @props.cursor.getIn(['timeline-attributes', focusedAttributeName], {}).toSeq()
      nextDate            = valuesForAttribute.keySeq().filter((date) -> date > now).min()

      { start: now, finish: nextDate || till }
    else
      {}
  
  
  gatherHints: ->
    @_hints ||= do =>
      attributes = Immutable.fromJS(@props.cursor.get('timeline-attributes', {}))
      attributes = attributes.reduce (memo, values, name) ->
        memo.withMutations (mutableMemo) ->
          
          values.keySeq().sort().forEach (date, index, dates) ->
            fromValue = if index > 0 then values.get(dates.get(index - 1))
            mutableMemo = mutableMemo.setIn([date, name], { from: fromValue, to: values.get(date) })

      , new Immutable.Map
  
  
  gatherDates: ->
    months      = Math.ceil(moment.duration(@state.till - @state.from).as('months'))
    current     = moment(@props.cursor.get('date')).startOf('month')
    
    dates       = @filterActiveDates()
    range       = @filterActiveRange(current.format('YYYY-MM-DD'), @state.till.format('YYYY-MM-DD'))
    
    @gatherHints()
      
    _.map [0..months], (i) =>
      now   = moment(@state.from).add(i, 'month').startOf('month')
      key   = now.format('YYYY-MM-DD')
      title = now.format('MMM YYYY')
      
      hints = @_hints.get(key)?.map (value, name) ->
        <li>
          {name}: {"#{value.from} → " if value.from} {value.to}
        </li>
      
      className = React.addons.classSet
        current:    current.isSame(now)
        effective:  dates and dates.has(key)#_.contains(dates, key)
        range:      key >= range.start and key <= range.finish
      
      <td key={key} className={className} data-title={title} onMouseDown={@setCurrentDate.bind(@, now)}>
        {<span className="year">{now.format('YYYY')}</span> if now.month() == 0}
        <div className="hint">
          <header>{title}</header>
          <ul>{hints?.toJS()}</ul>
        </div>
        &nbsp;
      </td>
  
  
  handleMouseDown: (event) ->
    @props.cursor.set('keep-focus', @props.cursor.get('focus'))
  
  
  componentDidMount: ->
    unless @props.cursor.get('date')
      @props.cursor.set('date', moment().startOf('month').format('YYYY-MM-DD'))
  
  
  shouldComponentUpdate: (nextProps, nextState) ->
    @props.cursor.isChanged()
  
  
  componentWillReceiveProps: ->
    if @props.cursor.cursor('timeline-attributes').isChanged()
      @_hints     = null
      @_ranges    = null
      @_keyframes = null
  
  
  getDefaultProps: ->
    cursor: Context.cursor('timeline')


  getInitialState: ->
    from: moment(new Date(@props.from)).startOf('month')
    till: moment(new Date(@props.till)).startOf('month')
    

  render: ->
    <table onMouseDown={@handleMouseDown}>
      <tbody>
        <tr>
          {@gatherDates()}
        </tr>
      </tbody>
    </table>
