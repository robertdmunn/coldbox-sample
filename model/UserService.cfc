<cfcomponent output="false">
	<cfproperty name="log" inject="coldbox:plugin:logger" />
	<cffunction name="init" returntype="model.UserService">

		<cfreturn this />
	</cffunction>

	<cffunction name="authUser" access="public" returntype="boolean">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfset log.info( " Authenticating username and password ... " ) />

		<cfreturn arguments.username eq "user" and arguments.password eq "password" />
	</cffunction>


	<cffunction name="getUser" access="public" returntype="boolean">
		<cfargument name="username" type="string" required="true" />

		<cfset log.info( " Retrieving username ... " ) />

		<cfreturn arguments.username eq "user" />
	</cffunction>
</cfcomponent>