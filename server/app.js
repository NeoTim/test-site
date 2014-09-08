
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



var userSchema = {
  id: Number,
  username: String,
  password: String,
};
var roomSchema = {
  id: Number,
  user_id: Number,
  roomname: String,
};
var messageSchema = {
  id: Number,
  user_id: Number,
  room_id: Number,
  text: String
};

var Room = mongoose.model('Room', roomSchema, 'rooms');
var User = mongoose.model('User', userSchema, 'users');
var Message = mongoose.model('Message', messageSchema, 'messages');

var app = express();
app.use(cors());
app.use(express.static(__dirname + '/client'));
// app.set('port', process.env.PORT || 3333)
app.use(express.bodyParser());
app.use(express.methodOverride());

app.use(app.router);
// app.use(express.static(__dirname + "/dist"));

// Use this so we can get access to `req.body` in our posted login
// and signup forms.
app.use( require('body-parser')() );

// We need to use cookies for sessions, so use the cookie parser middleware
app.use( require('cookie-parser')() );

// app.engine('hbs', expressHbs({extname:'hbs', defaultLayout:'main.hbs'}));
// app.set('view engine', 'hbs');


// var router = app.Router()
var Rest = app.Router()

Rest.route('/')
  .get(function(req, res){
    res.sendFile(__dirname + '/index.html');
  });

Rest.route('/api/auth/login')
  .post(function(req, res){
    var username = req.body.username;
    var password = req.body.password;
    authenticateUser(username, password, function(err, user){
      if (user) {
        // This way subsequent requests will know the user is logged in.
        req.session.username = user.username;

        res.redirect('/');
      } else {
        res.render('login', {badCredentials: true});
      }
    });
  });


Rest.route('/api/auth/signup')
  .post(function(req, res){

  })

Rest.route('/api/rooms')
  .get(function(req, res){
    Room.find(function(err, doc){
      if(err) throw err
      console.log(doc)
      res.send(doc);
    });
  })
  .post(function(req, res){
    Room.save(req, function(err, doc){
      if(err) throw err
      console.log(doc)
      res.send(doc)
    });
  })
  .put(function(req, res){
    Room.update(req, function(err, doc){
      if(err) throw err
      console.log(doc)
      res.send(doc)
    });
  })

Rest.route('/api/users')
  .get(function(req, res){
    User.find(function(err, doc){
      if(err) throw err;
      res.send(doc);
      console.log(doc)
    });
  })
  .post(function(req, res){
    User.save(req, function(err, doc){
      if(err) throw err;
      res.send(doc)
    });
  })
  .put(function(req, res){
    User.update(req, function(err, doc){
      if(err) throw err;
      res.send(doc)
    });
  })
Rest.route('/api/messages')
  .get(function(req, res){
    Message.find(function(err, doc){
      if(err) throw err;
      res.send(doc);
      console.log(doc)
    });
  })
  .post(function(req, res){
    Message.save(req, function(err, doc){
      if(err) throw err;
      res.send(doc)
      console.log(doc)
    });
  })
  .put(function(req, res){
    Message.update(req, function(err, doc){
      if(err) throw err;
      res.send(doc)
      console.log(doc)
    });
  })

app.listen(3000);
module.exports = app





// var express = require('express')
//   , io = require('socket.io')
//   , http = require('http')
//   , app = express()
//   // , path = require('path')
// ;




// app.configure(function() {
//     app.set('port', process.env.PORT || 3333)
//     app.use(express.bodyParser());
//     app.use(express.methodOverride());

//     app.use(app.router);
//     app.use(express.static(__dirname + "/dist"));
// });

// var server = http.createServer(app)
// var server = http.createServer(app)

// io.listen(server);

// server.listen(app.get('port'), function() {
//     console.log("Express server listening on port " + app.get('port'));
// });





// var databaseUrl = "square"; // "username:password@example.com/mydb"
// var collections = ["users", "reports"]
// var db = require("mongojs").connect(databaseUrl, collections);

// db.users.find({sex: "female"}, function(err, users) {
//   if( err || !users) console.log("No female users found");
//   else users.forEach( function(femaleUser) {
//     console.log(femaleUser);
//   } );
// });

