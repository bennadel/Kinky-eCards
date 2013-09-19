
<!--- Include page header. --->
<cfinclude template="../../extensions/includes/_header.cfm" />

<cfoutput>

	<h1>
		Enter Hayden Panettiere eCard Data
	</h1>
	
	<p>
		You have selected the following Hayden Panettiere eCard:
	</p>
	
	<p>
		<img 
			src="./images/ecards/thumbs/#REQUEST.Image.id#.jpg" 
			width="200"
			height="164"
			alt="#REQUEST.Image.description#"
			/>
	</p>
	
	<p>
		<em>#REQUEST.Image.description#</em>
	</p>

	
	<h2>
		Hayden Panettiere eCard Data
	</h2>
	
	<!--- Check to see if there are any errors. --->
	<cfif ArrayLen( REQUEST.Errors )>
		
		<div class="form-errors">
			
			<h3>
				Please review the following:
			</h3>
			
			<ul>
				<cfloop
					index="REQUEST.ErrorMessage"
					array="#REQUEST.Errors#">
					
					<li>
						#REQUEST.ErrorMessage#
					</li>
					
				</cfloop>
			</ul>
			
		</div>	
	
	</cfif>
	
	
	<form id="form" action="#CGI.script_name###form" method="post" class="data-form">
		
		<!--- Pass back the go directive. --->
		<input type="hidden" name="go" value="send" />
		
		<!--- Pass back submission flag. --->
		<input type="hidden" name="submitted" value="true" />
		
		<!--- Pass back the ecard. --->
		<input type="hidden" name="card" value="#REQUEST.Attributes.Card#" />
		
		<!--- Pass back the form ID. --->
		<input type="hidden" name="formid" value="#REQUEST.Attributes.FormID#" />
		
		
		<div class="data-item">
			<label id="sender_name">Sender:</label>
			<input id="sender_name" type="text" name="sender_name" value="#FORM.sender_name#" />
		</div>
		<br />
		
		<div class="data-item">
			<label id="sender_email">Sender Email:</label>
			<input id="sender_email" type="text" name="sender_email" value="#FORM.sender_email#" />
		</div>
		<br />
		
		<div class="data-item">
			<label id="recipient_name">Recipient:</label>
			<input id="recipient_name" type="text" name="recipient_name" value="#FORM.recipient_name#" />
		</div>
		<br />
		
		<div class="data-item">
			<label id="recipient_email">Recipient Email:</label>
			<input id="recipient_email" type="text" name="recipient_email" value="#FORM.recipient_email#" />
		</div>
		<br />
		
		<div class="data-item">
			<label id="message">Message:</label>
			<textarea id="message" name="message">#FORM.message#</textarea>
		</div>
		<br />
		
		<div class="buttons">
			<input type="submit" value="Preview Hayden Panettiere eCard &raquo;" />
			
			( <a href="#REQUEST.FrontController#?go=home">cancel</a> )
		</div>
		
	</form>
	
</cfoutput>

<!--- Include page footer. --->
<cfinclude template="../../extensions/includes/_footer.cfm" />