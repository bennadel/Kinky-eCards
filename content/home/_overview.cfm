
<!--- Include page header. --->
<cfinclude template="../../extensions/includes/_header.cfm" />

<cfoutput>

	<h1>
		Send Hayden Panettiere eCards Using Kinky eCards
	</h1>
	
	<p>
		Please select the Hayden Panettiere eCard that you want to send.
		Once you click on the desired Hayden picture, you will be given 
		the opporutnity to enter the sender, recipient, and Hayden Panettiere
		eCard message data.
	</p>

	
	<h2>
		Hayden Panettiere eCard Options
	</h2>
	
	<ul id="ecard-options">
	
		<!--- Loop over images. --->
		<cfloop query="APPLICATION.Images">
			
			<li>
				<a 
					href="#REQUEST.FrontController#?go=send&card=#APPLICATION.Images.id#"
					title="Send eCard of #APPLICATION.Images.description#">
					<img 
						src="./images/ecards/thumbs/#APPLICATION.Images.id#.jpg" 
						width="200"
						height="164"
						alt="#APPLICATION.Images.description#"
						/>
						
					<span>
						#APPLICATION.Images.description#
					</span>
				</a>
			</li>
			
		</cfloop>
		
	</ul>
	
	
	<!--- Clear floating elements. --->
	<div class="clearall">
		<br />
	</div>
	
</cfoutput>

<!--- Include page footer. --->
<cfinclude template="../../extensions/includes/_footer.cfm" />