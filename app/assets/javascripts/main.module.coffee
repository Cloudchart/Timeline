# Render inline components
#
_.each document.querySelectorAll('[data-react-class]'), (node) ->
  reactComponent  = require(node.dataset.reactClass)
  
  if reactComponent
    props = node.dataset.reactProps
    props = JSON.parse(props) if props
    React.render(React.createElement(reactComponent, props), node)
