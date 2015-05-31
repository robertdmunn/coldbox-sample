<cfcomponent output="false">
	<cfsetting enablecfoutputonly="yes">

	<cfset this.name = hash(getCurrentTemplatePath())>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0)>

	<cfset COLDBOX_APP_ROOT_PATH = getDirectoryFromPath(getCurrentTemplatePath())>
	<cfset COLDBOX_APP_MAPPING   = "">
	<cfset COLDBOX_CONFIG_FILE 	 = "">
	<cfset COLDBOX_APP_KEY 		 = "">

	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfscript>
			application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING);
			application.cbBootstrap.loadColdbox();
			return true;
		</cfscript>
	</cffunction>

	<cffunction name="onRequestStart" returnType="boolean" output="true">
		<cfargument name="targetPage" type="string" required="true" />

		<!--- <cfset onApplicationStart()> --->
		<cfif not structKeyExists(application,"cbBootstrap") or application.cbBootStrap.isfwReinit()>
			<cflock name="coldbox.bootstrap_#hash(getCurrentTemplatePath())#" type="exclusive" timeout="5" throwontimeout="true">
				<cfset structDelete(application,"cbBootStrap")>
				<cfset application.cbBootstrap = CreateObject("component","coldbox.system.Coldbox").init(COLDBOX_CONFIG_FILE,COLDBOX_APP_ROOT_PATH,COLDBOX_APP_KEY,COLDBOX_APP_MAPPING)>
			</cflock>
		</cfif>
		<cfset application.cbBootstrap.onRequestStart(arguments.targetPage)>

		<cfreturn true>
	</cffunction>

	<cffunction name="onApplicationEnd" returnType="void"  output="false">
		<cfargument name="appScope" type="struct" required="true">
		<cfset arguments.appScope.cbBootstrap.onApplicationEnd(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="onSessionStart" returnType="void" output="false">
		<cfset application.cbBootstrap.onSessionStart()>
	</cffunction>

	<cffunction name="onSessionEnd" returnType="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" 	type="struct" required="false">
		<cfset appScope.cbBootstrap.onSessionEnd(argumentCollection=arguments)>
	</cffunction>

	<cffunction	name="onMissingTemplate" access="public" returntype="boolean" output="true" hint="I execute when a non-existing CFM page was requested.">
		<cfargument name="template"	type="string" required="true"	hint="I am the template that the user requested."/>
		<cfreturn application.cbBootstrap.onMissingTemplate(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>