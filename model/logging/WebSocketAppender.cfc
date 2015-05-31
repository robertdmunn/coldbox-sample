<!-----------------------------------------------------------------------

Author     :	Robert Munn
Date        :	03/15/2015
Description :
	A websocket appender that logs to a websocket connection

Inspiration form SocketAppender by Luis Majano
Inspiration from Tim Blair <tim@bla.ir> by the cflogger project

Properties:
- host : the host to connect to
- port : the port to connect to
----------------------------------------------------------------------->
<cfcomponent extends="coldbox.system.logging.AbstractAppender"
			 output="false"
			 hint="A NIO websocket appender">

	<!--- Init --->
	<cffunction name="init" access="public" returntype="WebSocketAppender" hint="Constructor" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="name" 		required="true" hint="The unique name for this appender."/>
		<cfargument name="properties" 	required="false" default="#structnew()#" hint="A map of configuration properties for the appender"/>
		<cfargument name="layout" 		required="false" default="" hint="The layout class to use in this appender for custom message rendering."/>
		<cfargument name="levelMin"  	required="false" default="0" hint="The default log level for this appender, by default it is 0. Optional. ex: LogBox.logLevels.WARN"/>
		<cfargument name="levelMax"  	required="false" default="4" hint="The default log level for this appender, by default it is 5. Optional. ex: LogBox.logLevels.WARN"/>
		<!--- ************************************************************* --->
		<cfscript>
			// Init supertype
			super.init(argumentCollection=arguments);

			// Verify properties
			if( NOT propertyExists('host') ){
				$throw(message="The host must be provided",type="WebSocketAppender.HostNotFound");
			}

			if( NOT propertyExists('port') ){
				$throw(message="The port must be provided",type="WebSocketAppender.PortNotFound");
			}

			// Socket storage
			instance.ws = "";

			var paths = arraynew(1);
			paths[1]= expandpath("/includes/java/java_websocket.jar");
			paths[2]= expandpath("/includes/java/com.bonnydoonmedia.io.jar");
			var uri = createObject( "java", "java.net.URI" ).init( "ws://" & getProperty("host") & ":" & getProperty("port") );
			instance.javaloader = createObject('component',"javaloader.JavaLoader").init(paths);
			//instance.ws = javaloader.create( "com.bonnydoonmedia.io.WSClient" ).init( uri );
			instance.ws = instance.javaloader.create( "com.bonnydoonmedia.io.WSClient" ).init( uri );
			return this;
		</cfscript>
	</cffunction>

	<!--- onRegistration --->
	<cffunction name="onRegistration" output="false" access="public" returntype="void" hint="When registration occurs">
			<cfset openConnection()>
	</cffunction>

	<!--- onRegistration --->
	<cffunction name="onUnRegistration" output="false" access="public" returntype="void" hint="When Unregistration occurs">
			<cfset closeConnection()>
	</cffunction>

	<!--- Log Message --->
	<cffunction name="logMessage" access="public" output="true" returntype="void" hint="Write an entry into the appender.">
		<!--- ************************************************************* --->
		<cfargument name="logEvent" type="any" required="true" hint="The logging event"/>
		<!--- ************************************************************* --->
		<cfscript>
			var loge = arguments.logEvent;
			var entry = "";

			// Prepare entry to send.
			if( hasCustomLayout() ){
				entry = getCustomLayout().format(loge);
			}
			else{
				entry = "#severityToString(loge.getseverity())# #loge.getCategory()# #loge.getmessage()# ExtraInfo: #loge.getextraInfoAsString()#";
			}

			// Send data to Socket
			try{
				getSocket().send( entry );
			}
			catch(Any e){
				$log("ERROR","#getName()# - Error sending entry to socket #getProperties().toString()#. #e.message# #e.detail#");
			}

		</cfscript>
	</cffunction>

	<cffunction name="getSocket" access="public" returntype="any" output="false" hint="Get the socket object">
		<cfreturn instance.ws>
	</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------>

	<!--- Open a Connection --->
	<cffunction name="openConnection" access="private" returntype="void" output="false" hint="Opens a socket connection">
		<cfscript>
			try{
				getSocket().connect();
			}
			catch(Any e){
				$throw(message="Error opening socket to #getProperty("host")#:#getProperty("port")#",
					   detail=e.message & e.detail & e.stacktrace,
					   type="WebSocketAppender.ConnectionException");
			}
		</cfscript>
	</cffunction>

	<!--- Close the socket connection --->
	<cffunction name="closeConnection" access="public" returntype="void" output="no" hint="Closes the socket connection">
		<cfscript>
			getSocket().close();
		</cfscript>
	</cffunction>
</cfcomponent>