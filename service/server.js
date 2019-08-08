'use strict';
let app = require('express')();
let http = require('http').Server(app);
let io = require('socket.io')(http);
var Kafka = require('no-kafka');

// var producer = new Kafka.Producer();


io.on('connection', (socket) => {
  console.log('USER CONNECTED');

  socket.on('disconnect', function(){
    console.log('USER DISCONNECTED');
  });
 
});

http.listen(8091, () => {
  console.log('started on port 8091');
  var consumer = new Kafka.SimpleConsumer({
        connectionString: 'localhost:9092',
        clientId: 'no-kafka-client'
    }); 
 
// data handler function can return a Promise 
	var dataHandler = function (messageSet, topic, partition) {
		messageSet.forEach(function (m) {
			console.log(topic, partition, m.offset, m.message.value.toString('utf8'));
			if(topic=="test")
			{
				io.emit('message', {x:(new Date()).getTime(), y: m.message.value.toString('utf8')});
			}
			else
			{
				io.emit('sampleMessage', {x:(new Date()).getTime(), y: m.message.value.toString('utf8')});
			}
		});
	};
 
	// return producer.init().then(function(){
	// 	return producer.send({
	// 		topic: 'test',
	// 		partition: 0,
	// 		message: {
	// 			value: 'Hello!'
	// 		}
	// 	});
	//   })
	//   .then(function (result) {
	// 	/*
	// 	[ { topic: 'kafka-test-topic', partition: 0, offset: 353 } ]
	// 	*/
	//   });
	return consumer.init().then(function () {
		// Subscribe partitons 0 and 1 in a topic: 
		var v1= consumer.subscribe('test', [0, 1], dataHandler);
		console.log("Subscried to topic: 'test'");
		var v2= consumer.subscribe('Sample', [0, 1], dataHandler);
		console.log("Subscried to topic: 'Sample'");
		var arr=[];
		arr.push([v1,v2]);
		console.log("val:"+arr);
		return arr;
		
	});
});

