console.log 'import.coffee ok'

fs = require 'fs'
parse = require 'csv-parse'

source = fs.createReadStream './resources/users.txt'
parser=parse
  delimiter ','

#implémenter flux d'écriture et lecture de fichier pour remplir la bdd leveldb (cvs->leveldb)
#faire chemin retour (leveldb->csv)
