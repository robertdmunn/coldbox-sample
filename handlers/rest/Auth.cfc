component extends="coldbox.system.EventHandler" {
	property name="UserService" inject="model";

	this.allowedMethods = {
		login: "POST"

	};

	function preHandler(event,rc,prc,action){
		// default REST response to JSON
		event.paramValue("format", "json");
		log.info( ", Event : #event.getCurrentRoute()#, Method: #event.getHTTPMethod()#, username : #request.user.username#" );

		if( NOT reFindnocase("^(xml|json)$", rc.format) ){
			rc.invalidFormat = rc.format;
			rc.format = "json";
			event.overrideEvent( "rest.contacts.invalidFormat" );
		}

		prc.response = {
			error = false,
			messages = "",
			data = ""
		};
	}

	function postHandler(event,rc,prc,action){
		event.renderData(data=prc.response, type=rc.format);
	}

	function login(event,rc,prc){
		if(not isNull( prc.response.error ) and prc.response.error eq true){
			prc.response.data = false;
		}
		else{
			log.info( "Checking user login ..." );

			if( prc.response.data eq false ){
				log.error( "Authentication failed." );
			}
		}
	}

	function logout(event, rc, prc){
		log.info( "Logging out of server session ... " );
		structclear( session );
		prc.response.data = "";
	}

	function refresh(event, rc, prc){
		log.info( "Refreshing server session ... " );
		// just hitting the server to refresh the time to live for the session
	}

	function loginFail(event,rc,prc){
		log.error( "Login failed." );
		prc.response.error = true;
		prc.response.data = "Login Failed";
		prc.response.code = 401;
		prc.response.status = "Not authorized";
	}

}