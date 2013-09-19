
<!--- Make sure that we have a form ID. --->
<cfparam name="REQUEST.Attributes.FormID" type="string" default="" />

<!--- Check to make sure that we have a valid form ID. --->
<cfif NOT StructKeyExists( SESSION.FormData, REQUEST.Attributes.FormID )>
	
	<!--- 
		We don't have a valid form ID, so send the user back to 
		the homepage so that they can select an eCard to send out. 
	--->
	<cflocation
		url="#REQUEST.FrontController#?go=home"
		addtoken="false"
		/>

</cfif> 


<!--- 
	Since we know that we have the form data, get a short hand to 
	the user's stored form data. 
--->
<cfset REQUEST.CardData = SESSION.FormData[ REQUEST.Attributes.FormID ] />


<!--- Query for image. --->
<cfquery name="REQUEST.Image" dbtype="query">
	SELECT
		id,
		description
	FROM
		APPLICATION.Images
	WHERE
		id = <cfqueryparam value="#REQUEST.CardData.Card#" cfsqltype="cf_sql_integer" />	
</cfquery>