
<!--- Include page header. --->
<cfinclude template="../../extensions/includes/_header.cfm" />

<cfoutput>

	<h1>
		Your Hayden Panettiere eCard Has Been Sent
	</h1>
	
	<p>
		Thank you for using the Kinky eCard system. Your Hayden Panettiere 
		eCard has been sent to
		<strong>#REQUEST.CardData.RecipientName#</strong> 
		<em>&lt;#REQUEST.CardData.RecipientEmail#&gt;</em>.
	</p>
	
	<p>
		Want more Hayden? <a href="#REQUEST.FrontController#?go=home">Send another eCard</a> &raquo;
	</p>
	
</cfoutput>

<!--- Include page footer. --->
<cfinclude template="../../extensions/includes/_footer.cfm" />