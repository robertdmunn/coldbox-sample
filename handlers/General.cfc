<cfcomponent output="false"  extends="coldbox.system.EventHandler">
	<cfproperty name="UserService" inject="model"/>
	<cfscript>
		this.event_cache_suffix = "";
		this.prehandler_only 	= "";
		this.prehandler_except 	= "";
		this.posthandler_only 	= "";
		this.posthandler_except = "";
		this.aroundHandler_only = "";
		this.aroundHandler_except = "";
		/* HTTP Methods Allowed for actions. */
		/* Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'} */
		this.allowedMethods = structnew();
	</cfscript>

	<!--- Default Action --->
	<cffunction name="index" returntype="void" output="false" hint="My main event">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset rc.title = "Coldboxing "/>

		<cfset event.setView("home")>
	</cffunction>


</cfcomponent>