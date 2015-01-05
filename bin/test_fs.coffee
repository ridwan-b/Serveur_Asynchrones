lazy    = require("lazy")
fs = require('fs')

function write()
{
    fs.readFile('./Stream/bdd.csv','utf8', function (err, data) {
      if (err) throw err;
      console.log("mydata="+data);
      fs.writeFile ('./Stream/bdd.csv', data+'Hello Node\nSalut\n', function (err) {
        if (err) throw err;
        console.log('It\'s saved!');
      });
    });
};

write();

/* new lazy(fs.createReadStream('Mon fichier.txt'))
     .lines
     .forEach(function(line){
         console.log("Line:"+line.toString());
     }
 );*/
