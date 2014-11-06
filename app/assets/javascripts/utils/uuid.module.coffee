module.exports = ->
  url = URL.createObjectURL(new Blob) ; URL.revokeObjectURL(url) ; url.split('/').pop()
