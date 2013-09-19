
<!--- Make sure that we have a form ID. --->
<cfparam name="REQUEST.Attributes.FormID" type="string" default="" />
<cfparam name="REQUEST.Attributes.Email" type="string" default="" />

<!--- Get the card data file path. --->
<cfset REQUEST.DataFilePath = "#APPLICATION.DataDirectory##REQUEST.Attributes.FormID#.data" />


<!--- 
	Check to make sure that we have a valid form ID that has a corresponding 
	data file as well as a valid email address that will allow us to decrypt 
	the data.
--->
<cfif NOT (
	Len( REQUEST.Attributes.FormID ) AND
	FileExists( REQUEST.DataFilePath ) AND
	IsValid( "email", REQUEST.Attributes.Email )
	)>

	<!--- 
		We don't have a valid form ID or email address, so send the 
		user to the error page to indicate that something went wrong.
	--->
	<cflocation
		url="#REQUEST.FrontController#?go=pickup.error"
		addtoken="false"
		/>

</cfif> 


<!--- 
	Try to work with the data. If anything goes wrong, redirect 
	the user to the error page. 
--->
<cftry>
		
	<!--- Read in the ecard data file. --->
	<cffile
		action="read"
		file="#REQUEST.DataFilePath#"
		variable="REQUEST.EncryptedData"
		/>
		
	
	<!--- Try to decrypt the data using the passed in email address. --->
	<cfset REQUEST.DecryptedData = Decrypt(
		REQUEST.EncryptedData,
		REQUEST.Attributes.Email,
		"CFMX_COMPAT",
		"hex"	
		) />
	
		
	<!--- Parse the decrypted data into XML. --->
	<cfset REQUEST.CardXML = XmlParse( REQUEST.DecryptedData ) />
	
	
	<!--- Create a card data structure based on the XML. --->
	<cfset REQUEST.CardData = {
		Card = REQUEST.CardXML.card.XmlAttributes.id,
		SenderName = REQUEST.CardXML.card.sender.name.XmlText,
		SenderEmail = REQUEST.CardXML.card.sender.email.XmlText,
		RecipientName = REQUEST.CardXML.card.recipient.name.XmlText,
		RecipientEmail = REQUEST.CardXML.card.recipient.email.XmlText,
		Message = Replace(
			Trim( REQUEST.CardXML.card.message.XmlText ),
			"&amp;",
			"&",
			"all"
			)
		} />
		
		
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
		
	
	<!--- Catch any errors that were thrown during the decryption process. --->
	<cfcatch>
	
		<!--- There was an error, so forward user to error page. --->
		<cflocation
			url="#REQUEST.FrontController#?go=pickup.error"
			addtoken="false"
			/>
	
	</cfcatch>
	
</cftry>