
level = require 'level'

module.exports = (db="#{__dirname}../db") ->
  db = level db if typeof db is 'string'
  close: (callback) ->
    db.close callback
  users:
    get_by_username: (username, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{username}:"
      .on 'data', (data) ->
        [_, username, key] = data.key.split ':'
        user.username ?= username
        user[key] = data.value
      .on 'error', (err) ->
        callback err
      .on 'end', ->
        callback 200, user
    get_by_email: (email, callback) ->
      user = {}
      db.createReadStream
        gt: "users:#{email}:"
      .on 'data', (data) ->
        [_, email, key] = data.key.split ':'
        user.email ?= email
        user[key] = data.value
      .on 'error', (err) ->
        callback err
      .on 'end', ->
        callback 200, user
    set: (username, email, user, callback) ->
      json_user = JSON.parse(user)
      #Ajout avec index sur username
      ops = for k, v of json_user
        continue if k is 'username'
        type: 'put'
        key: "users:#{username}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err

      #Ajout avec index sur email
      ops = for k, v of json_user
        continue if k is 'email'
        type: 'put'
        key: "users:#{email}:#{k}"
        value: v
      db.batch ops, (err) ->
        callback err

      callback 200
    del: (username, callback) ->
      # TODO
