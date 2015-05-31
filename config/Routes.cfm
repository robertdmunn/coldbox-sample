 <cfscript>

	setUniqueURLS(false);

	if( len(getSetting('AppMapping') ) lte 1){
		setBaseURL("https://#cgi.HTTP_HOST#/index.cfm");
	}
	else{
		setBaseURL("https://#cgi.HTTP_HOST#/#getSetting('AppMapping')#/index.cfm");
	}

	with(pattern="/api", handler="rest.")
		.addRoute(pattern="/auth/loginfail", handler="Auth", action="loginFail")
		.addRoute(pattern="/auth/login", handler="Auth", action="login")
		.addRoute(pattern="/auth/logout", handler="Auth", action="logout")
		.addRoute(pattern="/auth/refresh", handler="Auth", action="refresh")
	.endWith();


	addRoute(pattern=":handler/:action?");

	function PathInfoProvider(Event){
		return CGI.PATH_INFO;
	}
</cfscript>