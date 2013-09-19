
<!--- Check to see which pickup action we are executing. --->
<cfswitch expression="#REQUEST.Attributes.Go[ 2 ]#">
	
	<cfcase value="error">
		<cfinclude template="_error.cfm" />
	</cfcase>
	
	<!--- Default to pickup. --->
	<cfdefaultcase>
		<cfinclude template="_pickup_action.cfm" />
		<cfinclude template="_pickup.cfm" />
	</cfdefaultcase>

</cfswitch>