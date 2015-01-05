
http = require 'http'
stylus = require 'stylus'
nib = require 'nib'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
session = require 'express-session'
errorhandler = require 'errorhandler'
dojo = require 'connect-dojo'
coffee = require 'connect-coffee-script'
serve_favicon = require 'serve-favicon'
serve_index = require 'serve-index'
serve_static = require 'serve-static'
db = require '../lib/db'
client = db "./db"
# config = require '../conf/hdfs'

app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use serve_favicon "#{__dirname}/../public/favicon.ico"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser 'toto'
app.use methodOverride '_method'
app.use session secret: 'toto', resave: true, saveUninitialized: true

app.use coffee
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  bare: true
app.use stylus.middleware
  src: "#{__dirname}/../views"
  dest: "#{__dirname}/../public"
  compile: (str, path) ->
    stylus(str)
    .set('filename', path)
    .set('compress', config?.css?.compress)
    .use nib()
app.use serve_static "#{__dirname}/../public"

app.get '/', (req, res, next) ->
  res.render 'index', title: 'Express'

#Action de Login
app.post '/user/login', (req, res, next) ->
  console.log "login"
  #On requête la bdd
  client.users.get_by_username req.body.username, (err,user) ->
    #Si le retour est correct (pas d'erreur)
    if err is 200
      json_user = JSON.stringify user
      #On test si le username et password récupérés correspondent à ceux saisi par le user
      if user['username'] is req.body.username && user['password'] is req.body.password
        #Si oui, on renvoit le json qui validera la connectin
        console.log "Connexion du user "+user['username']+" | "+user['password']+": OK"
        res.end json_user
        my_user = null
        json_user = null
      else
        #Si non, on teste sur le champ email de la bdd
        client.users.get_by_email req.body.username, (err,user) ->
          #Si le retour est correct (pas d'erreur)
          if err is 200
            json_user = JSON.stringify user
            #On test si le username et password récupérés correspondent à ceux saisi par le user
            if user['email'] is req.body.username && user['password'] is req.body.password
              #Si oui, on renvoit le json qui validera la connectin
              console.log "Connexion du user "+user['email']+" | "+user['password']+": OK"
              res.end json_user
              my_user = null
              json_user = null
            else
              #Si non, on renvoit null qui indiquera l'erreur de saisie
              console.log "Connexion du user "+req.body.username+" | "+req.body.password+": FAIL"
              res.end null
              my_user = null

#Action de signup
app.post '/user/signup', (req, res, next) ->
  console.log "signup"
  #Création de l'objet user qui sera converti en JSON par la suite
  my_user = new Object
  my_user.username = req.body.username
  my_user.firstname = req.body.firstname
  my_user.lastname =req.body.lastname
  my_user.email = req.body.email
  my_user.password = req.body.password
  #Conversion JSON
  json_user=JSON.stringify my_user

  #Vérification de la non-présence du username et de l'email dans la bdd leveldb
  client.users.get_by_username my_user.username, (err,user) ->
    #On test si le username et password récupérés correspondent à ceux saisi par le user
    #TODO gestion email
    if user['username'] is req.body.username
      #Si oui, on renvoit null pour indiquer l'erreur lors de la création du user
      console.log "User "+user['username']+": Existant"
      res.end null
      my_user = null
    else
      #Si le username et l'email n'existe pas
      #Ajout de l'utilisateur dans la bdd leveldb
      client.users.set req.body.username, req.body.email, json_user, (state)->
        if state is 200
          console.log "Création du user "+req.body.username+" | "+req.body.password+": OK"
          res.writeHead(200, { 'Content-Type': 'application/json' });
          console.log json_user
          res.end json_user
          my_user = null

app.use serve_index "#{__dirname}/../public"
if process.env.NODE_ENV is 'development'
  app.use errorhandler()


module.exports = app
