# Node.js WebApp

##Functionnalities

* signin form: accept username/email
* signup form:
* import/export csv+json


##Layout

./git
./gitignore
./npmignore
/bin/start
/bin/import
/bin/export
/db/.gitignore
/lib/app.coffee
/lib/db.coffee, import.coffee, export.coffee
/package.json (name,version,dependancies,...)
/README.md
/LICENSE
/public
/tests/db.coffee
/tests/app.coffee
/views

##Signup/Signin

Ajax request to communicate with the server, only one url for all the screens.

If user is already loged in, he must arrive on its homepage (not on signin or signup screen).

##LevelDB schema

User namespace
key: "user#{username}:#{properties}"
properties: "lastname", "firstname", "email" and "password"

key: "user#{email}:#{properties}"
properties: "username", "lastname", "firstname" and "password"


## Import/export

Create 2 commands `.\bin\import` and `.\bin\export`. Each commands take 2 options "--help" and "--format".

### Import & Export module

'''
.\bin\import
import [--help] [--format {name}] input
Introduction message
--help          Print this message
--format {name} One of csv(default) or json
input           Imported File
'''

'''
./bin/export --help
import [--help] [--format {name}] output
Introduction message
--help          Print this message
--format {name} One of csv(default) or json
output           Exported File
'''

Import must implement the "stream.Writable" class inside a module './lib/import'. Here's an example how to use the import module:

'''
import = require './lib/import'
db = require './lib/db'
client = db './db'
fs
.createReadStream('./sample.csv')
.pipe import(client, format: 'csv')
'''

Export must implement the "stream.Readable" class inside a module './lib/export'. Here's an example how to use the export module:

'''
export = require './lib/export'
db = require './lib/db'
client = db './db'
export(client, format: 'csv')
.pipe fs.createReadStream('./sample.csv')
'''

[connect]:

Contributors

* Ridwan Burahee: <lien github>
* Benoit Chassinat
* Goeffrey Visticot
