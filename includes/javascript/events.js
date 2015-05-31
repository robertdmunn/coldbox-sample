$.subscribe( "user.login", function( evt, data ){
	app.remote.login( data );
});
					
$.subscribe( "user.logout", function( evt, data ){
	app.remote.logout();
	//failed login
	if( data !== undefined && data.loginFail === true ){
		alert( "Login unsuccessful. Please try again." );
	}

});

$.subscribe( "user.refresh", function( evt, data ){
	app.remote.refresh();
});