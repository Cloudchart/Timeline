_.each document.querySelectorAll('[data-react-class]'), (node) ->
  reactComponent  = try require(node.dataset.reactClass)
  
  if reactComponent
    React.renderComponent(reactComponent(node.dataset.reactComponent), node)
