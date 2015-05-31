
component extends='coldbox.system.Interceptor'{

	property name="SecurityService" inject="model";
	property name="UserService" inject="model";

	property name="log" inject="coldbox:plugin:logger";

	void function configure(){

	}

	void function preProcess(event,struct interceptData){

		var rc = event.getCollection();
		var prc = event.getCollection(private=true);

		if( NOT isNull( session.isAuthenticated ) and session.isAuthenticated ){
			//valid session
			SecurityService.setUser( { username : session.username } );
		}

		else if( len( event.getHTTPHeader("Authorization","") ) gt 5 ){
			log.info( "HTTPSecurity interceptor - authenticating " );
			var response = {
				error = false,
				messages = "",
				data = ""
			};
			try{
				local.auth = toString( toBinary( gettoken( getHttpRequestData().headers['Authorization'],2," ") ) );

			}catch(Any e){
				local.auth = "";
			}

			if( listlen(local.auth,":") eq 2){
			    // auth the user
				try{
					local.getAuth = UserService.authuser( username = gettoken( local.auth, 1, ":" ), password = gettoken( local.auth, 2, ":" ) );
					if( local.getAuth ){

						session.isAuthenticated = true;
						session.username = gettoken( local.auth, 1, ":" );
						SecurityService.setUser( { username : session.username } );
					}else{
						response.error = true;
						response.messages = "User not authenticated";
					}
				}catch(Any e){
					response.error = true;
					response.messages = e.message;
				}
				event.setValue( "response", response, true );

			}else{
				//not authorized
				response.error = true;
				event.setHTTPHeader( statusCode="401", statusText="Not authorized" );
				event.setValue( "response", response, true );
			}

			return;

		}
		return;
	}
}