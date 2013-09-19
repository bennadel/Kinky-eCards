
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

<!--- Create an XML document to persist the user's message. --->
<cfsavecontent variable="REQUEST.CardXML">
	<cfoutput>
	
		<card id="#REQUEST.CardData.Card#">
			<sender>
				<name>#XmlFormat( REQUEST.CardData.SenderName )#</name>
				<email>#XmlFormat( REQUEST.CardData.SenderEmail )#</email>
			</sender>
			<recipient>
				<name>#XmlFormat( REQUEST.CardData.RecipientName )#</name>
				<email>#XmlFormat( REQUEST.CardData.RecipientEmail )#</email>
			</recipient>
			<message>
				<![CDATA[ #XmlFormat( REQUEST.CardData.Message )# ]]>
			</message>
		</card>

	</cfoutput>
</cfsavecontent>


<!--- 
	Now that we have the user's card data, encrypt it using the 
	recipients email address. 
--->
<cfset REQUEST.EncryptedData = Encrypt(
	Trim( REQUEST.CardXML ),
	REQUEST.CardData.RecipientEmail,
	"CFMX_COMPAT",
	"hex"
	) />
	
	
<!--- Write the encrypted data to file. --->
<cffile
	action="write"
	file="#APPLICATION.DataDirectory##REQUEST.Attributes.FormID#.data"
	output="#REQUEST.EncryptedData#"
	addnewline="false"
	fixnewline="false"
	/>
	
	
<!--- Send email to recipient. --->
<cfmail
	to="#REQUEST.CardData.RecipientEmail#"
	from="#REQUEST.CardData.SenderEmail#"
	subject="#REQUEST.CardData.SenderName# has sent you a Hayden Panettiere eCard!"
	type="html">
	
	<p>
		Dear #REQUEST.CardData.RecipientName#,
	</p>
	
	<p>
		#REQUEST.CardData.SenderName# has sent you a Hayden Panettiere eCard
		using the Kinky eCard system. You can pick up your eCard by clicking 
		on the following link or copy and pasting it into your browser's URL.
	</p>
	
	<p>
		<a 
			href="http://#CGI.server_name##REQUEST.FrontController#?go=pickup&formid=#REQUEST.Attributes.FormID#&email=#UrlEncodedFormat( REQUEST.CardData.RecipientEmail )#"
			target="_blank"
			>http://#CGI.server_name##REQUEST.FrontController#?go=pickup&formid=#REQUEST.Attributes.FormID#&email=#UrlEncodedFormat( REQUEST.CardData.RecipientEmail )#</a>
	</p>
	
	<p>
		Thanks.
	</p>
	
	<p style="color: ##999999 ; font-size: 90% ;">
		Kinky eCards is a free ColdFusion eCard Application by 
		<a href="http://www.bennadel.com" target="_blank" style="color: ##999999 ;">Ben Nadel / Kinky Solutions</a>.
	</p>
	
</cfmail>