console.log('import.coffee ok')

fs = require('fs')

source = fs.createReadStream('views/resources/users.txt')

console.log(source.buffer)