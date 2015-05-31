<cfcomponent output="false" singleton>

	<cfproperty name="UserService" inject="model"/>

	<cffunction name="init" returntype="model.SecurityService">

		<cfreturn this />
	</cffunction>

	<cffunction name="userValidator" access="public" returntype="boolean" output="false" hint="Mandatory method for security interceptor">
        <cfargument name="rule" required="true" type="struct"  hint="The rule to verify">
		<cfargument name="messagebox" type="any" required="true" hint="The ColdBox messagebox plugin. You can use to set a redirection message"/>
		<cfargument name="controller" type="any" required="true" hint="The coldbox controller" />


		<cfset var isAllowed = false>

		<cfset var user = getUser()>
		<cfset var currentPermission = ''>
        <!--- Check if we have a user  --->
		<cfif isStruct(user)>
			<cfset isAllowed = true>

		<cfelse>
			<!--
				returns a blank user, meaning no current session
			 -->
		</cfif>

        <cfreturn isAllowed>
	</cffunction>

	<cffunction name="getUser" access="public" output="false" returntype="any">
		<cfset var user = ''>

			<cfif isDefined("request.user")>
				<cfset user = request.user>
			</cfif>

		<cfreturn user>
	</cffunction>

	<cffunction name="setUser" access="public" output="false" returntype="void">
		<cfargument name="user" required="yes" type="struct" hint="">

		<cfset request.user = arguments.user>

	</cffunction>

	<cffunction name="setValidated" access="public" returntype="void">
		<cfargument name="validated" type="boolean"/>
		<cfargument name="messages" type="string" default="" required="false"/>

		<cfset prc.error = (NOT arguments.validated) />
		<cfset prc.messages = arguments.messages />
	</cffunction>


</cfcomponent>