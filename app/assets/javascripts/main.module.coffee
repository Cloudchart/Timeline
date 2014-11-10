# Require context for root components
#
Context = require('stores/context')


# Render root components
#
_.each document.querySelectorAll('[data-react-class]'), (node) ->

  if node.dataset.reactClass and (reactComponent = require(node.dataset.reactClass))
    props = node.dataset.reactProps
    props = JSON.parse(props) if props
    
    # Make bootstrap for root component
    #
    Bootstrap = React.createClass
      displayName: 'Bootstrap.' + reactComponent.displayName
    
      componentWillMount: ->
        Context.init(@)
    
      render: ->
        React.withContext { timeline: Context }, -> React.createElement(reactComponent, props)
      
    # Render root component
    #
    React.render(React.createElement(Bootstrap), node)
