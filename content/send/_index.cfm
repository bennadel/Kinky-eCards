
<!--- Check to see which send action we are executing. --->
<cfswitch expression="#REQUEST.Attributes.Go[ 2 ]#">
	
	<cfcase value="preview">
		<cfinclude template="_preview_action.cfm" />
		<cfinclude template="_preview.cfm" />
	</cfcase>
	
	<cfcase value="process">
		<cfinclude template="_process_action.cfm" />
		<cfinclude template="_process.cfm" />
	</cfcase>
	
	<!--- Default to data entry. --->
	<cfdefaultcase>
		<cfinclude template="_enter_data_action.cfm" />
		<cfinclude template="_enter_data.cfm" />
	</cfdefaultcase>

</cfswitch>