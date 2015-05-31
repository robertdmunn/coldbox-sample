# websocket-sample
Sample Coldbox app that demonstrates the use of websockets for server side real time debug info on the client, among other things

**Installation**

Pre-requisites
--------------

CFML Server - Tested on Lucee 4.5.1 (www.lucee.org) on Tomcat 7 (tomcat.apache.org).
NodeJS (nodejs.org)
npm 
Git
Bower (bower.io)

1. Download the application zip file and extract it or "git clone" into the directory of your choice.

2. From the command line, go to the root of the application and type:

    bower update
	
Doing so will install the JavaScript components required for the application.

3. Install Coldbox (www.coldbox.org). This application has been tested on Coldbox 3.7.0. 

Download the Coldbox package and put the coldbox folder inside the application root. You need coldbox/system, but not the docs or examples, to get the app to run.

4. From there, set up the site on Tomcat, etc. depending on your environment. Make sure the index file is set to index.cfm.

5. Open the site in a browser. 

**What It Does**

This is a sample application that demonstrates, among other things, how to display server-side debug information in your client application using web sockets.

The application uses a technology stack including JavaScript (jQuery, jQuery UI among other things), CFML ( Lucee Server on Tomcat in my demo ), Coldbox, Logbox and a couple of Java components for the web socket functionality.

You can apply the principles in the application to any server technology. The easiest way to implement the ideas is to leverage an application logging library ( Logbox in this case ) that allows you to define custom appenders for logging output.

The application itself does very little. It allows you to login ( hint - username : "user", password : "password" ) and logout. While you are logged in, the client application will refresh the session state with the server every 60 seconds so you can see something happening in the debug window without waiting too long. Because it is using Coldbox, the application will also show Coldbox system logging in its debug window. being able to show events that are happening in the background rather than in response to a specific request can be very useful when you are trying to debug problems with background processes.
