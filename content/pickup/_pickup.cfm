
<!--- Include page header. --->
<cfinclude template="../../extensions/includes/_header.cfm" />

<cfoutput>
	
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
	
		
		<p class="send-note">
			Like the eCard? Why not <a href="#REQUEST.FrontController#?go=home">send one</a> yourself.
		</p>
		
	</div>
	
</cfoutput>

<!--- Include page footer. --->
<cfinclude template="../../extensions/includes/_footer.cfm" />