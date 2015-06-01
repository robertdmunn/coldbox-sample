<cfcomponent output="false" hint="Coldbox App Configuration">
<cfscript>
/**
structures/arrays to create for configuration

- coldbox (struct)
- settings (struct)
- conventions (struct)
- environments (struct)
- wirebox (struct)
- ioc (struct)
- debugger (struct)
- mailSettings (struct)
- i18n (struct)
- webservices (struct)
- datasources (struct)
- layoutSettings (struct)
- layouts (array of structs)
- cacheBox (struct)
- interceptorSettings (struct)
- interceptors (array of structs)
- modules (struct)
- logBox (struct)
- flash (struct)
- orm (struct)
- validation (struct)

Available objects in variable scope
- controller
- logBoxConfig
- appMapping (auto calculated by ColdBox)

Required Methods
- configure() : The method ColdBox calls to configure the application.
Optional Methods
- detectEnvironment() : If declared the framework will call it and it must return the name of the environment you are on.
- {environment}() : The name of the environment found and called by the framework.

*/

	// Configure ColdBox Application
	function configure(){

		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "Coldboxing",
			eventName 				= "event",

			//Development Settings
			debugMode				= false,
			debugPassword			= "",
			reinitPassword			= "",
			handlersIndexAutoReload = true,

			//Implicit Events
			defaultEvent			= "General.index",
			requestStartHandler		= "Main.onRequestStart",
			requestEndHandler		= "",
			applicationStartHandler = "Main.onAppInit",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "Main.onSessionEnd",
			missingTemplateHandler	= "",

			//Extension Points
			UDFLibraryFile 				= "",
			coldboxExtensionsLocation 	= "",
			modulesExternalLocation		= [],
			pluginsExternalLocation 	= "",
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",

			//Error/Exception Handling
			exceptionHandler		= "Main.onException",
			onInvalidEvent			= "",
			customErrorTemplate		= "",

			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			proxyReturnCollection 	= false,

			// custom settings
			debugPort = 8880,
			secretKey = GenerateSecretKey( "AES" )
		};

		// custom settings

		settings = {
			javaloader_libpath = expandPath("/includes/java/")
		};

		environments = {
			development = "home$"
		};

		flash = {
        	scope = "session"
        };
		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};


		logBox = {
			// Appenders
			appenders : {
				coldboxTracer : { class:"coldbox.system.logging.appenders.ColdboxTracerAppender" },
				webSocketAppender : { class:"model.logging.WebSocketAppender", levelMax:"INFO", levelMin:"FATAL", properties : { host:"127.0.0.1",port: coldbox.debugPort } },
				fileAppender :	{ class: "coldbox.system.logging.appenders.AsyncRollingFileAppender",
					levelMax:"INFO",
					levelMin:"fatal",
					properties:{
						filePath:"/logs",
						fileName:'coldboxlog',
						autoExpand:"true",
						fileMaxSize:"3000",
						fileMaxArchives:"5"
	       			}

				}
			},
			// Root Logger
			root : {levelMin:"FATAL", levelMax:"DEBUG", appenders:"*"},
			// Granualr Categories
			categories : {
				"coldbox.system" : { levelMin:"FATAL", levelMax:"INFO", appenders:"*"},
				"handlers" : { levelMin:"FATAL", levelMax:"INFO", appenders:"*"},
				"handlers.rest" : { levelMin:"FATAL", levelMax:"INFO", appenders:"*"},
				"model" : { levelMin:"FATAL", levelMax:"INFO", appenders:"*"}
			}
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "Main.cfm",
			defaultView   = ""
		};

		// wirebox integration
		wirebox = {
			singletonReload = false,
			binder = 'config.WireBox'
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [
			//SES
			{class="coldbox.system.interceptors.SES",
			 properties={}
			},
			// decode PUT variables
			{class="interceptors.PutDecoder"},
			{ class="interceptors.HTTPSecurity"},

			{class="coldbox.system.interceptors.Security",
			 properties={
			 	rulesSource="xml",
				rulesFile="config/securityrules.xml.cfm",
				debugMode=true,
				validatorModel="SecurityService",
				throwOnInvalidStates = true
				}
			}
		];

		/*	datasources = {
			mydsn   = {name="websocket-sample"}
		};	*/
	}

	function development(){
		// Override coldbox directives
		coldbox.debugMode = false;
		coldbox.handlerCaching = false;
		coldbox.eventCaching = false;

		logbox.appenders.WebSocketAppender.levelMax = "DEBUG";
		logbox.appenders.WebSocketAppender.levelMin = "FATAL";
		logbox.appenders.fileAppender.levelMax = "INFO";
		logbox.categories.handlers.levelMax = "INFO";
		logbox.categories.handlers.rest.levelMax = "INFO";

	}
</cfscript>
</cfcomponent>