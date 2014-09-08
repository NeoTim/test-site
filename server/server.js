var express = require("express");
var http = require('http');
var io = require('socket.io');
var path = require('path')
var mongoose = require("mongoose");
var cors = require("cors");

mongoose.connect('mongodb://localhost/simple');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
  console.log("MONGOD Connected")
});

var app = express();

module.exports = app
