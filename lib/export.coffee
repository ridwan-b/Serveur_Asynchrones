var util = require('util');
var Readable = require('stream').Readable;

var MyStream = function(options) {
  Readable.call(this, options); // pass through the options to the Readable constructor
  this.counter = 2;
};

util.inherits(MyStream, Readable); // inherit the prototype methods

MyStream.prototype._read = function(client,format) {
  this.push('foobar');
  if (this.counter-- === 0) { // stop the stream
    this.push(null);
  }
};

var mystream = new MyStream();
mystream.pipe(process.stdout);

//module.exports = (export="#{__dirname}../lib") ->
//	MyStream.prototype._read : (n) ->
//	  this.push('foobar');
//	  if (this.counter-- === 0) { // stop the stream
//	    this.push(null);