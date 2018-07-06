var express = require('express');


var app = express();
var fs = require('fs');

app.get('/', function(req, res) {
	fs.readFile('./index.html','utf-8', function(err, data) {
    	res.writeHead(200, {'Content-Type': 'text/html'});
    	res.end(data);
  	});
  	fs.readFile('./main.css','utf-8', function(err, data) {
    	res.writeHead(200, {'Content-Type': 'text/css'});
    	res.end(data);
  	});
});


app.use(function(req, res, next){

    res.setHeader('Content-Type', 'text/plain');

    res.send(404, 'Page cannot be found!');

});



app.listen(8080);