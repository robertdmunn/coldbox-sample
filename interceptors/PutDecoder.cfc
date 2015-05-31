/**
* Intercepts with HTTP Basic Authentication
*/
component extends='coldbox.system.Interceptor'{

	void function configure(){
	}

	void function onRequestCapture( event ){
		// translate http content for PUT verb
		if( arguments.event.getHTTPMethod() eq "PUT" ){
			local.list = arguments.event.getHTTPContent();
			for( local.i = 1; local.i lte listlen( local.list, "&"); local.i++ ){
				arguments.event.setValue( gettoken( listGetAt( local.list, local.i, "&" ), 1, "=" ), urldecode( gettoken( listGetAt( local.list, local.i, "&" ), 2, "=" ) ) );
			}			
		}
	}
}