/*
 * Based on NodeJS simple chat tutorial
 * http://ahoj.io/nodejs-and-websocket-simple-chat-tutorial
 * 
 */

( function( $ ) {
	"use strict";

    // for better performance - to avoid searching in DOM
    var title = "Debug Window",
    width = "50%",
    position = '{ my: "right top", at: "right top", of: "window" }';

    //flag to notify the system to start debugging
    app.debug = { active: true };
    
    window.WebSocket = window.WebSocket || window.MozWebSocket;

    // if browser doesn't support WebSocket, just show some notification and exit
    if (!window.WebSocket) {
        $('#debugDiv').html($('<p>', { text: 'Sorry, but your browser doesn\'t '
                                    + 'support WebSockets.'} ));
        return;
    }

    // open connection
    var connection = new WebSocket('ws://' + window.location.hostname + ':8880');

    connection.onopen = function () {
    	console.log( "Opened debug session..." );
    	$('#debugDiv').html( "Opened debug session...");
    };

    connection.onerror = function (error) {
        // just in there were some problems with conenction...
        $('#debugDiv').html($('<p>', { text: 'Sorry, but there\'s some problem with your '
                                    + 'connection or the server is down.' } ));
    };

    // most important part - incoming messages
    connection.onmessage = function (message) {
        // try to parse JSON message. Because we know that the server always returns
        // JSON this should work without any problem but we should make sure that
        // the massage is not chunked or otherwise damaged.
        try {
            var json = JSON.parse(message.data);
        } catch (e) {
            console.log('This doesn\'t look like a valid JSON: ', message.data);
            return;
        }
 
        if (json.type === 'history') { // entire message history
            // insert every single message to the chat window
            for (var i=0; i < json.data.length; i++) {
                addMessage(json.data[i].text,
                           new Date(json.data[i].time));
            }
        } else if (json.type === 'message') { // it's a single message
        	console.log("message received");
            addMessage( json.data.text,
                       new Date(json.data.time));
        } else {
            console.log('Hmm..., I\'ve never seen JSON like this: ', json);
        }
    };

    $( window )
    	.on("close", function(){
    		connection.close();
    	});
    
    
	var addMessage = function(message,  dt) {
    $('#debugDiv').prepend('<div>' +
         + (dt.getHours() < 10 ? '0' + dt.getHours() : dt.getHours()) + ':'
         + (dt.getMinutes() < 10 ? '0' + dt.getMinutes() : dt.getMinutes())
         + ': ' + message + '</div>');
    };

}( jQuery ) );