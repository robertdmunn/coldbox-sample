$.subscribe( "user.login", function( evt, data ){
	app.remote.login( data );
});
					
$.subscribe( "user.logout", function( evt, data ){
	app.model.set( "user.username", "" );
	app.model.set( "authToken", "" );
	clearTimeout( app.getToken );
	app.getToken = undefined;
	$( "div[name='loginCredentials']" ).show( 'fade', {}, 200 );
	$( "div[name='loginStatus']" ).hide( 'fade', { queue : false }, 200 );		
	
	//app.remote.logout();
	//failed login
	/*	if( data !== undefined && data.loginFail === true ){
		alert( "Login unsuccessful. Please try again." );
	}	*/

});

$.subscribe( "user.refresh", function( evt, data ){
	app.remote.refresh();
});