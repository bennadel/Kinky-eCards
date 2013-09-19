
<!--- Include page header. --->
<cfinclude template="../../extensions/includes/_header.cfm" />

<cfoutput>

	<h1>
		Preview Hayden Panettiere eCard
	</h1>
	
	<p>
		Please review the following Hayden Panettiere eCard to make sure that
		your information is correct. If you wish to send it, click the <strong>Send</strong> button. 
		To go back and modify your information, click the <strong>Edit Message</strong> link.
	</p>
	
	
	<div id="ecard-display">
		
		<div id="ecard-graphic">
			
			<img 
				src="./images/ecards/#REQUEST.Image.id#.jpg" 
				width="641"
				height="525"
				alt="#REQUEST.Image.description#"
				class="graphic"
				/>
			
			<img 
				src="./images/global/stamp.gif"
				width="56" 
				height="64" 
				alt="Stamp"
				class="stamp"
				/>
				
		</div>
		
	
		<div id="ecard-message">
			
			<p class="recipient">
				#REQUEST.CardData.RecipientName#
				<em>(#REQUEST.CardData.RecipientEmail#)</em>
			</p>
		
			<p class="sender">
				#REQUEST.CardData.SenderName#
				<em>(#REQUEST.CardData.SenderEmail#)</em>
			</p>
			
			<p class="message">
				#REQUEST.CardData.Message.ReplaceAll(
					JavaCast( "string", "\r\n?|\r?\n" ),
					JavaCast( "string", "<br />" )
					)#
			</p>
				
		</div>	
	
	</div>
	
	
	<form action="#REQUEST.FrontController#" method="post">
		
		<!--- Pass back the go directive. --->
		<input type="hidden" name="go" value="send.process" />
		
		<!--- Pass back the form ID. --->
		<input type="hidden" name="formid" value="#REQUEST.Attributes.FormID#" />
		
		<p>
			<input type="submit" value="Send Hayden Panettiere eCard &raquo;" />
			
			( <a href="#REQUEST.FrontController#?go=send.enterdata&formid=#REQUEST.Attributes.FormID#">edit message</a> )
		</p>
		
	</form>
	
</cfoutput>

<!--- Include page footer. --->
<cfinclude template="../../extensions/includes/_footer.cfm" />