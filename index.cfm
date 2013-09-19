
<!--- Check to see which value of Go we are looking at. --->
<cfswitch expression="#REQUEST.Attributes.Go[ 1 ]#">

	<cfcase value="error">
		<cfinclude template="./content/error/_index.cfm" />
	</cfcase>
	
	<cfcase value="pickup">
		<cfinclude template="./content/pickup/_index.cfm" />
	</cfcase>
	
	<cfcase value="send">
		<cfinclude template="./content/send/_index.cfm" />
	</cfcase>

	<!--- Default to home. --->
	<cfdefaultcase>
		<cfinclude template="./content/home/_index.cfm" />
	</cfdefaultcase>

</cfswitch>