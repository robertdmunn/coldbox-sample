
component extends='coldbox.system.Interceptor'{

	property name="SecurityService" inject="model";
	property name="UserService" inject="model";
	property name="secretKey" inject="coldbox:setting:secretKey";
	property name="log" inject="coldbox:plugin:logger";

	void function configure(){

	}

	void function preProcess(event,struct interceptData){

		var rc = event.getCollection();
		var prc = event.getCollection(private=true);

		if( len( event.getHTTPHeader("X-AuthToken","") ) ){
			log.info( "HTTPSecurity interceptor - set user from auth token" );
			local.base64Token = gettoken( getHttpRequestData().headers['X-AuthToken'], 1," " );
			local.hash = gettoken( getHttpRequestData().headers['X-AuthToken'], 2," " );
			local.valid = true;
			if( local.hash eq hmac( local.base64Token, variables.secretKey, "HMACSHA256"  ) ){

				// token is valid
				local.auth = deserializeJSON( toString( toBinary( gettoken( getHttpRequestData().headers['X-AuthToken'], 1," " ) ) ) );
				log.info( "Auth Token:" & serializeJSON( local.auth ) );
				if( len( UserService.getUser( username = local.auth.username ).username ) and local.auth.expires gt now() ){
					SecurityService.setUser( local.auth );
				}else{
					local.valid = false;
				}
			}else{
				local.valid = false;
			}
			if( NOT local.valid ){
				log.info( "Invalid token, redirecting ... " );
				event.setNextEvent( event = "rest.auth.loginFail" );
			}
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
						local.user = { username : gettoken( local.auth, 1, ":" ) };
						SecurityService.setUser( local.user );
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

			//return;

		}
		log.info( "Checking whether to set auth token" );
		if( NOT isNull( request.user ) ){
			log.info( "Set auth token" );
			local.authtoken = duplicate( request.user );
			local.authtoken.expires = dateAdd( 'n', 30, now() );
			local.base64Token = toBase64( serializeJSON( local.authtoken ) );
			local.hash = hmac( local.base64Token, variables.secretKey, "HMACSHA256"  );
			//local.pc = getpagecontext().getresponse();
			//local.pc.setHeader("X-AuthToken", local.base64Token & " " & local.hash );
			event.setHTTPHeader( name="X-AuthToken", value="#local.base64Token# #local.hash#" );
		}
		return;
	}
}