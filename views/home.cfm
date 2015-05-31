<cfoutput>

<h2>WebSocket Sample</h2>
<div name="intro">

<p>This is a sample application that demonstrates, among other things, how to display server-side debug information in your client application using web sockets. </p>
<p>The application uses a technology stack including JavaScript (jQuery, jQuery UI among other things), CFML ( Lucee Server on Tomcat in my demo ), Coldbox, Logbox and a couple of Java components for the web socket functionality.</p>
<p>You can apply the principles in the application to any server technology. The easiest way to implement the ideas is to leverage an application logging library ( Logbox in this case ) that allows you to define custom appenders for logging output.</p>
<p>
	The application itself does very little. It allows you to login ( hint - username : "user", password : "password" ) and logout. While you are logged in, the client application will refresh the session state with the server every 60 seconds so you can
	see something happening in the debug window without waiting too long. Because it is using Coldbox, the application will also show Coldbox system logging in its debug window. being able to show events that are happening in the background rather than
	in response to a specific request can be very useful when you are trying to debug problems with background processes.
</p>
</div>

<form>
<div name="loginCredentials">
	<div><input name="username" type="text" placeholder="Username" class="ui-corner-all ui-widget-input" /></div>
	<div><input name="password" type="password" placeholder="Password"  class="ui-corner-all ui-widget-input"/></div>
</div>
<div name="loginStatus">
	Current User: <span name="username"></span>
</div>
<div name="buttons">
	<div><input type="button" name="login" value="Login" class="ui-corner-all"> <input name="logout" type="button" value="logout"  class="ui-corner-all"/></div>
</div>
</form>

</cfoutput>