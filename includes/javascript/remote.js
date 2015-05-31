"use strict";

app.remote =  ( function( $ ){

	 var _login = function ( data ){
		$.ajax({
			url: "/index.cfm/api/auth/login",
			type: "POST",
			beforeSend: function( xhr ){
				xhr.setRequestHeader ( "Authorization", "Basic " + app.util.base64.encode64( data.username + ":" + data.password ) );
			},
			success: function( json, textStatus, request ){
				if ( json.ERROR === false ) {
					app.model.set( "user.username", data.username );
					
					
					$( "div[name='loginStatus']" ).show( 'fade', {}, 200 );
					$( "div[name='loginCredentials']" ).hide( 'fade', { queue : false }, 200 );
					
					
					//	app.user.username = data.username;
				}else{
					$.publish( "user.logout", [{loginFail: true }] );
				}
			},
			error: function( xhr, status ){
				$.publish( "user.logout", [{loginFail: true }] );
			}
		});				
		$( "#loginForm" )
			.removeAttr( "disabled" );
	},

	 _logout = function ( data ){
		$.ajax({
			url: "/index.cfm/api/auth/logout",
			type: "POST",
			data: data,
			success: function( json, textStatus, request ){
				app.model.set( "user.username", "" );
				$( "div[name='loginCredentials']" ).show( 'fade', {}, 200 );
				$( "div[name='loginStatus']" ).hide( 'fade', { queue : false }, 200 );				
			},
			error: function( xhr, status ){

			}
		});
	},

	_refresh = function( data ){
		$.ajax({
			url: "/index.cfm/api/auth/refresh",
			type: "GET",

			success: function( json ){
				if ( json.ERROR === true ) {
					$.publish( "user.logout", [{loginFail: false }] );
				}
			},
			error: function( xhr, status ){
				$.publish( "user.logout", [{loginFail: false }] );
			}
		});
	};

	return {
		login: _login,
		logout: _logout,
		refresh: _refresh
	};

}( jQuery ));