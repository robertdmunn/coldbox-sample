<cfcomponent output="false" hint="WireBox Injector config" extends="coldbox.system.ioc.config.Binder">
<cfscript>

	function configure(){
		wireBox = {

			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			}
		};
		map( "SecurityService" ).to( "model.SecurityService" )
			.asSingleton();
		map( "UserService" ).to( "model.UserService" )
			.asSingleton();

	}
</cfscript>
</cfcomponent>