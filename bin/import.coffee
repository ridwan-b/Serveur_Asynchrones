require('coffee-script/register')
lazy = require("lazy")
fs = require('fs')
db = require('../lib/db.coffee')
client = db("./db")

new lazy(fs.createReadStream('./Stream/bdd.csv'))
     .lines
     .forEach(function(line){
        line_split = line.toString().split(",");

        if(line_split[0]=="username")
        {
          my_user = new Object
          my_user.username = line_split[1]
          my_user.firstname = line_split[2]
          my_user.lastname = line_split[3]
          my_user.email = line_split[4]
          my_user.password = line_split[5]
          json_user= JSON.stringify(my_user)

          client.users.set(my_user.username, my_user.email, json_user, function(state){
            if(state == 200)
              console.log("Création du user "+my_user.username+" | "+my_user.password+": OK")
            })
        }
     }
 );
