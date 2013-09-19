
<cfcomponent
	output="false"
	hint="Handles application settings and application-level events.">
	
	
	<!--- Set application settings. --->
	<cfset THIS.Name = "ColdFusion eCards" />
	<cfset THIS.SessionManagement = true />
	<cfset THIS.SessionTimeout = CreateTimeSpan( 0, 0, 20, 0 ) />
	<cfset THIS.SetClientCookies = true />
	
	<!--- Set page request settings. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="false"
		/>
		
		
	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Initializes the application.">
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Clear the application. We should do this incase we are re-initializing. --->
		<cfset StructClear( APPLICATION ) />
		
		
		<!--- 
			Get the root directory for this application. That will be 
			the directory holding this file (Application.cfc).
		--->
		<cfset APPLICATION.RootDirectory = GetDirectoryFromPath( GetCurrentTemplatePath() ) />
		
		<!--- 
			Get the proper sever-side path seperator. We will be using 
			this when we build other configuration paths.
			
			NOTE: All of the paths we generate will be assumed to end with
			a slash. Therefore, any string appended to a calculated path 
			will NOT include the leading slash.
		--->
		<cfset APPLICATION.ServerPathSlash = Left(
			REReplace( 
				APPLICATION.RootDirectory,
				"^[^\\/]+",
				"",
				"all"				
				),
			1
			) />
		
		<!--- 
			Set the path to the data driectory. This is where we 
			are doing to store the ecard data submitted by the users.
		--->
		<cfset APPLICATION.DataDirectory = (
			APPLICATION.RootDirectory & 
			"data" & 
			APPLICATION.ServerPathSlash
			) />
			
			
		<!--- Read in the image data xml file. --->
		<cfset APPLICATION.ImagesXML = XmlParse( APPLICATION.RootDirectory & "images.xml" ) />
		
		<!--- 
			Now, convert the xml to a query. The query object will be much easier
			to work with and more closely related to standard database-drive 
			applicatoins. We can also easily perform ColdFusion query of queries. 
		--->
		<cfset APPLICATION.Images = QueryNew(
			"id, description",
			"cf_sql_integer, cf_sql_varchar"
			) />
			
		<!--- Loop over XML to populate query. --->
		<cfloop
			index="LOCAL.ImageNode"
			array="#XmlSearch( APPLICATION.ImagesXML, '//image/' )#">
			
			<!--- Add row to query. --->
			<cfset QueryAddRow( APPLICATION.Images ) />
			
			<!--- Set row data. --->
			<cfset APPLICATION.Images[ "id" ][ APPLICATION.Images.RecordCount ] = JavaCast( "int", Trim( LOCAL.ImageNode.id.XmlText ) ) />
			<cfset APPLICATION.Images[ "description" ][ APPLICATION.Images.RecordCount ] = JavaCast( "string", Trim( LOCAL.ImageNode.desc.XmlText ) ) />
			
		</cfloop>
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
	
	
	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Initializes the user's session.">
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Store the use ID / TOKEN values before we clear. --->
		<cfset LOCAL.CFID = SESSION.CFID />
		<cfset LOCAL.CFTOKEN = SESSION.CFTOKEN />
		
		<!--- 
			Clear the session. We should do this incase we 
			are re-initializing.
		--->
		<cfset StructClear( SESSION ) />
		
		<!--- Restore the ID/TOKEN values. --->
		<cfset SESSION.CFID = LOCAL.CFID />
		<cfset SESSION.CFTOKEN = LOCAL.CFTOKEN />
		
		<!--- 
			Set up a struct to hold the form data. We the need the form data so that 
			the user can go back and forth on multi-page forms (ex. enter data and 
			preview eCard).
		--->
		<cfset SESSION.FormData = {} />
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="true"
		hint="Performs pre-page processing for the requested template.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Page"
			type="string"
			required="true"
			hint="The requested page template."
			/>
	
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		
		<!--- 
			This entire application will be funneled through the index.cfm 
			page; however, if someone were to select a different CFM file, 
			we need to make sure it does not become any kind of security 
			breach. Therefore, before we do anything else, let's check to see
			what the user is selecting. If this is not the index.cfm page, 
			then just return false, which will kill the page request. 
		--->
		<cfif (GetBaseTemplatePath() NEQ (GetDirectoryFromPath( GetCurrentTemplatePath() ) & "index.cfm"))>
			
			<!--- They have requested a non-authorized page. Kill the request. --->
			<cfreturn false />
		
		</cfif>
		
		
		<!--- 
			ASSERT: At this point, we know that we are dealing with a 
			valid page request that is going through index.cfm in the 
			root directory.
		--->
		
		
		<!--- Check to see if we need to reset the application. --->
		<cfif StructKeyExists( URL, "reset" )>
		
			<!--- Manually invoke application initialization. --->
			<cfset THIS.OnApplicationStart() />
			
		</cfif>
		
		
		<!--- 
			Loop over form data to escape quotes and other HTML data. This 
			will stop input fields from breaking. In addition, I feel that in 
			the spirit of web rendernig, let's trim off leading and trailing
			white space.
		--->
		<cfloop
			item="LOCAL.Key"
			collection="#FORM#">
			
			<cfset FORM[ LOCAL.Key ] = HtmlEditFormat( Trim( FORM[ LOCAL.Key ] ) ) />
			
		</cfloop>
			
	
		<!--- 
			Combine the FORM and URL scopes into a single convenience 
			scope, Attributes. This way, we don't have to know exactly
			which scope a user-submitted value came from (unless we 
			need to know for sure).
		--->
		<cfset REQUEST.Attributes = Duplicate( URL ) />
		<cfset StructAppend( REQUEST.Attributes, FORM ) />
	
	
		<!--- Param some common request attributes. --->
		<cfparam 
			name="REQUEST.Attributes.Action"
			type="string"
			default=""
			/>
			
		<!--- Form submission flag. --->
		<cfparam 
			name="REQUEST.Attributes.Submitted"
			type="boolean"
			default="false"
			/>
		
	
		<!--- 
			Param the go attribute. This will be converted into 
			an array from the comma delimited list of values.
		--->
		<cfparam 
			name="REQUEST.Attributes.Go"
			type="string"
			default="home" 
			/>
		
		<!--- 
			Convert the Go attribute into an array. The {null} values 
			are being include so make sure that the Go array has a minimum 
			number of values.
		--->
		<cfset REQUEST.Attributes.Go = ListToArray(
			(REQUEST.Attributes.Go & ".{null}.{null}.{null}.{null}"),
			"."
			) />
			
			
		<!--- 
			Create a "FrontController" variable so that the forms and the links 
			can all post back to the index page without having to hard-code the 
			index.cfm in the values. 
		--->
		<cfset REQUEST.FrontController = CGI.script_name />
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
	
	
	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Executes the requested template.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Page"
			type="string"
			required="true"
			hint="The requested page template."
			/>
	
		<!--- Include the index no matter what page was requested. --->
		<cfinclude template="./index.cfm" />

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Handles uncaught exceptions that have bubbled up to the application event level.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"
			hint="The generated exception object."
			/>
			
		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			hint="The application event that was running when the uncaught exception was thrown."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		
		<!--- 
			Get the request monitor. We are going to use this to more 
			gracefully deal with our error event.
		--->
		<cfset LOCAL.RequestMonitor = CreateObject( "java", "coldfusion.runtime.RequestMonitor" ) />
		
		<!--- From the request monitor, we are going to get the current request timeout. --->
		<cfset LOCAL.RequestTimeout = LOCAL.RequestMonitor.GetRequestTimeout() />

		<!--- 
			Now that we have the current request timeout setting, we 
			are going to add 2 seconds to this value. This will give us 
			more time to more gracefully handle the exception; it will 
			help to ensure that our page does not run out of processing time. 
		--->
		<cfsetting 
			requesttimeout="#(LOCAL.RequestTimeout + 2)#"
			/>
		
		
		<!--- 
			Now that we have our error-handling environment configured to 
			be able to better deal with the exception, let's actually figure 
			out what is going on. For starters, let's check to see if we even
			need to care about this exception. In ColdFusion, the CFLocation tag
			will thrown an "abort" exception. We don't want to deal with this, so
			just exit out if that is the exception.
		--->
		<cfif (
			StructKeyExists( ARGUMENTS.Exception, "RootCause" ) AND
			(ARGUMENTS.Exception.RootCause.Type EQ "coldfusion.runtime.AbortException")
			)>
			
			<!--- Needless error; do not process this error. Return out. --->
			<cfreturn />
		</cfif>
	
	
		<!--- 
			ASSERT: At this point, we have an error that is real and that is 
			one we have to deal with. 
		--->
		
		
		<!--- Mail a copy of the CGI, URL, and FORM objects to aid in debugging. --->
		<cfmail
			to="ben@bennadel.com"
			from="errors@bennadel.com"
			subject="CFERROR: Kinky eCards"
			type="html">
			
			<cfdump var="#CGI#" label="CGI" />
			<cfdump var="#FORM#" label="FORM" />
			<cfdump var="#URL#" label="URL" />
		</cfmail>
	
		
		<!--- 
			We don't know where the error was thrown. Was it thrown before the 
			headers were flushed? Has data already made it to the screen? Because 
			we don't know that, we want to try to relocate to a new page. First 
			try to use CFLocation. If that doesn't work, use Javascript. 
			
			However, at the same time, we don't want to throw ourselves into an 
			infinite loop. Only redirect if the "norelocate" flag does NOT exist
			in the URL.
		--->
		<cfif NOT StructKeyExists( URL, "norelocate" )>
		
			<cftry>
				<cflocation
					url="./index.cfm?go=error&norelocate"
					addtoken="false"
					/>
					
				<cfcatch>
					
					<!--- The CFLocation failse. Try javascript as a backup. --->
					<script type="text/javascript">
						window.location.href = "./index.cfm?go=error&norelocate";
					</script>
				
				</cfcatch>		
			</cftry>
		
		</cfif>
	
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
</cfcomponent>