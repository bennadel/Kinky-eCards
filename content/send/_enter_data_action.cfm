
<!--- Param form data. --->
<cfparam name="REQUEST.Attributes.Card" type="numeric" default="0" />
<cfparam name="FORM.sender_name" type="string" default="" />
<cfparam name="FORM.sender_email" type="string" default="" />
<cfparam name="FORM.recipient_name" type="string" default="" />
<cfparam name="FORM.recipient_email" type="string" default="" />
<cfparam name="FORM.message" type="string" default="" />

<!--- Create an errors array. --->
<cfset REQUEST.Errors = [] />


<!--- 
	Check to see if we have a form ID. This is the value that will 
	allow us to store and access the form data in the user's session. 
	We are not doing this in a CFParam tag since we don't want the
	CreateUUID() function to fire unless it is required.
--->
<cfif NOT StructKeyExists( REQUEST.Attributes, "FormID" )>
	
	<!--- Create the unique Form ID. --->
	<cfset REQUEST.Attributes.FormID = CreateUUID() />

<cfelseif StructKeyExists( SESSION.FormData, REQUEST.Attributes.FormID )>

	<!--- 
		Since we have a form ID and we already have a card 
		structure in the user's session data, let's set the Card 
		using the stored Card data. 
	--->
	<cfset REQUEST.Attributes.Card = SESSION.FormData[ REQUEST.Attributes.FormID ].Card />
	
</cfif>


<!--- 
	ASSERT: At this point, we have a card ID in the 
	REQUEST.Attributes.Card variable. This either came from 
	the URL for from a stored form data structure.
--->


<!--- Query for image. --->
<cfquery name="REQUEST.Image" dbtype="query">
	SELECT
		id,
		description
	FROM
		APPLICATION.Images
	WHERE
		id = <cfqueryparam value="#REQUEST.Attributes.Card#" cfsqltype="cf_sql_integer" />	
</cfquery>


<!--- Check to see that a card was found. --->
<cfif NOT REQUEST.Image.RecordCount>
	
	<!--- Send user back to homepage to select an eCard. --->
	<cflocation
		url="#REQUEST.FrontController#?go=home"
		addtoken="false"
		/>
		
</cfif>


<!--- Check to see if the form has been submitted. --->
<cfif REQUEST.Attributes.Submitted>

	<!--- Validate data. --->
	<cfif NOT Len( FORM.sender_name )>
		
		<cfset ArrayAppend( 
			REQUEST.Errors,
			"Please enter the sender name." 
			) />
		
	</cfif>
	
	<cfif NOT IsValid( "email", FORM.sender_email )>
		
		<cfset ArrayAppend( 
			REQUEST.Errors,
			"Please enter a valid sender email." 
			) />
		
	</cfif>
	
	<cfif NOT Len( FORM.recipient_name )>
		
		<cfset ArrayAppend( 
			REQUEST.Errors,
			"Please enter the recipient name." 
			) />
		
	</cfif>
	
	<cfif NOT IsValid( "email", FORM.recipient_email )>
		
		<cfset ArrayAppend( 
			REQUEST.Errors,
			"Please enter a valid recipient email." 
			) />
		
	</cfif>
	
	<cfif NOT Len( FORM.message )>
		
		<cfset ArrayAppend( 
			REQUEST.Errors,
			"Please enter your eCard message." 
			) />
		
	</cfif>
	
	
	<!--- 
		At this point, we have collected all the data-type form 
		validation. Check to see if the form data is valid. 
	--->
	<cfif NOT ArrayLen( REQUEST.Errors )>
		
		<!--- Store the data in the user's form cache. --->
		<cfset SESSION.FormData[ REQUEST.Attributes.FormID ] = {
			Card = REQUEST.Attributes.Card,
			SenderName = FORM.sender_name,
			SenderEmail = FORM.sender_email,
			RecipientName = FORM.recipient_name,
			RecipientEmail = FORM.recipient_email,
			Message = FORM.message
			} />
		
		<!--- Preview the ecard. --->
		<cflocation 
			url="#REQUEST.FrontController#?go=send.preview&formid=#REQUEST.Attributes.FormID#&##top-of-page"
			addtoken="false"
			/>
	
	</cfif>
	
	
<cfelse>


	<!--- 
		The form has not been submitted. Let's see if we have an 
		existing set of data for this form ID. If we do, then we 
		need to initialized the form values. 
	--->
	<cfif StructKeyExists( SESSION.FormData, REQUEST.Attributes.FormID )>
		
		<!--- 
			We have already filled out this data and might be coming 
			back from a preview screen. Set form data. 
		--->
		<cfset REQUEST.Attributes.Card = SESSION.FormData[ REQUEST.Attributes.FormID ].Card />
		<cfset FORM.sender_name = SESSION.FormData[ REQUEST.Attributes.FormID ].SenderName />
		<cfset FORM.sender_email = SESSION.FormData[ REQUEST.Attributes.FormID ].SenderEmail />
		<cfset FORM.recipient_name = SESSION.FormData[ REQUEST.Attributes.FormID ].RecipientName />
		<cfset FORM.recipient_email = SESSION.FormData[ REQUEST.Attributes.FormID ].RecipientEmail />
		<cfset FORM.message = SESSION.FormData[ REQUEST.Attributes.FormID ].Message />
	
	</cfif>

</cfif>