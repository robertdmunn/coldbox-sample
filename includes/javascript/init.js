
$( document ).ready( function() {
	
	$.ajaxSetup({
		type : "GET",
		// XML, HTML, JSON, JSONP, text and script
		beforeSend : function( xhr ) {
			var currentTime = new Date( ), getToken, 
			diff = Math.abs( currentTime - app.time ), 
			minutes = Math.floor( ( diff / 1000 ) / 60 );

			if( minutes > 30 ){
				$.publish( "user.logout" );
			}
			// this function keeps your session alive while
			// you are on the page and your computer is
			// active
			if ( typeof getToken !== "undefined" ) {
				clearTimeout( getToken );
			}

			xhr.then( function( ) {
				if ( app.model.get( "user.username" ) === 'user' ) {
					if ( typeof getToken === "undefined" ) {
						getToken = setTimeout( function( ) {
						$.publish( "user.refresh" );
						}, 60000 );
					}
				}
			});
			app.time = currentTime;
		},
		complete : function( xhr, status ) {
			var response;
			try{
				response = JSON.parse( xhr.responseText );
			}catch( e ){
				response = { ERROR : false, MESSAGES: "" };
			}

			if( xhr.state() === "resolved" && response.ERROR === true && response.MESSAGES.trim() === "Login failed" ){

				$.publish( "user.logout" );
			}
	

		},
		dataType : "json",
		cache : false
	});
	
	( function(){
		var user = { username : "" };
		app.model.set( "user", user );
		
		app.model.bind( "user.username", $( "span[name='username']" ) );
		
		$( "input[name='login']" )
			.on( "click", function(){
				var username = $( "input[name='username']" ).val(),
				password = 	$( "input[name='password']" ).val();
				$.publish( "user.login", { username : username, password: password } );
			});
		
		$( "input[name='logout']" )
		.on( "click", function(){

			$.publish( "user.logout", { } );
		});
		
		if( app.debug.active === true && $( "#debugDiv" ).attr( "class" ) === undefined ){
			$( "body", document ).prepend("<div id='debugDiv' class='debug'></div>");
			var fp = new gadgetui.display.FloatingPane( { selector: $( "#debugDiv" ), config : { title: "Debug", opacity: .7, position: { my: "right top", at: "right top", of: window } } } );
		}		
	})();
	


	
	
	
});