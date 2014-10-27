__schm = {}


# Exports
#
module.exports =
  
  addSchema: (key, json) ->
    [key, json] = [json, key] if arguments.length == 1
    
    if json['id'] and _.isString(json['id']) and json['id'] isnt key
      __schm[json['id']] = json
    else
      throw new Error('Schema: schema needs either a name or id attribute.')
    
    if key
      __schm[key] = json
  
  
  validate: (key, object) ->
    unless __schm[key]
      throw new Error('Schema: could not find schema \'' + key + '\'.')

    