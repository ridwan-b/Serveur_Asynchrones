user = {}
login = {user,options={},callback} ->
  throw Error "Property username is required" unless user.username
  throw Error "Property password is required" unless user.password
  options.log ?= false
  if options.log is null or typeof options.log is 'undefined'
  db.query """
  SELECT *
  FROM users
  WHERE
    username is #{user.username} and
    password is PASSWORD(#{user.password})
  """, (err, results) ->
    callback err, !!results.length

  login
    username = 'david'
    password = 'xxx'
    # email = "blabla@blabla.fr"
  , (err,islogin) ->
    console.log err, islogin
