<!---
Documentation for format argument in the download method:

Valid formats for documents are: txt,odt,pdf,html,rtf,doc,png
Valid formats for presentations are: swf,pdf,ppt
Valid formats for spreadsheets are: xls,csv,pdf,ods,tsv,html
--->
<cfcomponent output="false" extends="google">

<cfset variables.docservice = "writely">
<cfset variables.spreadsheetservice = "wise">

<cffunction name="authenticate" access="public" returnType="boolean" output="false" hint="I authenticate a user for a service. If login fails, I throw an error.">
	<cfargument name="username" type="string" required="true">
	<cfargument name="password" type="string" required="true">

	<cfset super.authenticate(arguments.username,arguments.password,variables.docservice)>	
	<cfset super.authenticate(arguments.username,arguments.password,variables.spreadsheetservice)>	
	<cfreturn true />
</cffunction>

<cffunction name="download" access="public" returnType="any" hint="I get the source of the document." output="false">
	<cfargument name="id" type="string" required="true" hint="Document ID.">
	<cfargument name="type" type="string" required="false" hint="document,spreadsheet,presentation. Needed since Google isn't smart enough to look it up." default="document">
	<cfargument name="format" type="string" required="false" hint="Please see docs above for valid formats. It is based on type." default="txt">
	<cfargument name="sheet" type="numeric" required="false" hint="What sheet to get. Google uses 0 based indexes, but that's dumb. I'll substract one for you.">
	
	<cfset var result = "">
	<cfset var theURL = "">
	<cfset var getAsBinary = "no">
	<cfset var service = variables.docservice>
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="document">
			<cfset theUrl = "http://docs.google.com/feeds/download/documents/Export?docID=#urlEncodedFormat(arguments.id)#&exportFormat=#arguments.format#">
		</cfcase>
		<cfcase value="presentation">
			<cfset theUrl = "http://docs.google.com/feeds/download/presentations/Export?docID=#urlEncodedFormat(arguments.id)#&exportFormat=#arguments.format#">
		</cfcase>
		<cfcase value="spreadsheet">
			<cfset theUrl = "http://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=#urlEncodedFormat(arguments.id)#&fmcmd=#spreadSheetFormat(arguments.format)#">			
			<cfif structKeyExists(arguments,"sheet")>
				<cfset theUrl = theURL & "&gid=#decrementValue(sheet)#">
			</cfif>
			<cfset service = variables.spreadsheetservice>
		</cfcase>
		<cfdefaultcase>
			<cfthrow message="Invalid type (#arguments.type#) specified. Must be one of: document,presentation,spreadsheet">
		</cfdefaultcase>
	</cfswitch>
	
	<cfif listFindNoCase("odf,pdf,doc,png,swf,ppt,ods,xls",arguments.format)>
		<cfset getAsBinary = "yes">
	<cfelse>
		<cfset getAsBinary = "no">
	</cfif>
	
	<!---
	<cfoutput>
	id=#arguments.id#,
	url=#theurl#<br/>
	getasb=#getasbinary#
	<p>
	</cfoutput>
	--->
	
	<cfhttp url="#theURL#" method="get" result="result" charset="utf-8" getasbinary="#getAsBinary#">
		<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#getAuth(service)#">
		<cfhttpparam type="header" name="GData-Version" value="2.0">
	</cfhttp>

	<cfreturn result.filecontent>
	
</cffunction>

<cffunction name="getDocumentList" access="public" returnType="query" output="false" hint="I return a query of documents. ToDo: More Filtering.">
	<cfargument name="title" type="string" required="false">
	<cfargument name="max" type="numeric" required="false">
	<cfargument name="doctype" type="string" required="false" hint="Filter by type. One of document,presentation,spreadsheet">
	<cfargument name="starred" type="boolean" required="false" hint="Filter by starred. Ignored if false.">
	<cfargument name="search" type="string" required="false" hint="Filter by search term.">
	
	<cfset var result = "">
	<cfset var packet = "">
	<cfset var x = "">
	<cfset var docs = queryNew("id,title,updated,type,sourceurl,link,author,authoremail,starred")>
	<cfset var entry = "">
	<cfset var updated = "">
	<cfset var type = "">
	<cfset var y = "">
	<cfset var mainurl = "http://docs.google.com/feeds/documents/private/full">
	<cfset var parts = "">
	
	<cfif structKeyExists(arguments, "doctype")>
		<!--- need to append /- to the mainurl --->
		<cfset mainurl = mainurl & "/-/#arguments.doctype#">
	</cfif>
	<cfif structKeyExists(arguments, "starred") and arguments.starred>
		<cfif not structKeyExists(arguments, "doctype")>
			<cfset mainurl = mainurl & "/-">
		</cfif>
		<cfset mainurl = mainurl & "/starred">
	</cfif>
	
	<cfif structKeyExists(arguments, "title")>
		<!--- google wont let you end in a ?, so we need to be smart about --->
		<cfif not find("?", mainurl)>
			<cfset mainurl = mainurl & "?">
		<cfelse>
			<cfset mainurl = mainurl & "&">
		</cfif>
		<cfset mainurl = mainurl & "title=#urlEncodedFormat(arguments.title)#&max-results=1">
	</cfif>

	<cfif structKeyExists(arguments, "max")>
		<cfif not find("?", mainurl)>
			<cfset mainurl = mainurl & "?">
		<cfelse>
			<cfset mainurl = mainurl & "&">
		</cfif>
		<cfset mainurl = mainurl & "max-results=#arguments.max#">
	</cfif>

	<cfif structKeyExists(arguments, "search")>
		<cfif not find("?", mainurl)>
			<cfset mainurl = mainurl & "?">
		<cfelse>
			<cfset mainurl = mainurl & "&">
		</cfif>
		<cfset mainurl = mainurl & "q=#urlEncodedFormat(arguments.search)#">
	</cfif>

	<!---<cfoutput>mainurl=#mainurl#</cfoutput>--->
	
	<cfhttp url="#mainurl#" method="get" result="result" charset="utf-8">
		<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#getAuth(variables.docservice)#">
		<cfhttpparam type="header" name="GData-Version" value="2.0">
	</cfhttp>
	
	<cfif not isXml(result.filecontent)>
		<cfthrow message="#result.filecontent#">
	</cfif>
	
	<cfset packet = xmlParse(result.filecontent)>

	<cfif not structKeyExists(packet, "feed")>
		<cfthrow message="Bad Response">
	</cfif>	

	<cfif not structKeyExists(packet.feed, "entry")>
		<cfreturn docs>
	</cfif>
	
	<cfloop index="x" from="1" to ="#arrayLen(packet.feed.entry)#">
		<cfset entry = packet.feed.entry[x]>
		<cfset updated = entry.updated.xmltext>
		<cfset queryAddRow(docs)>
		<!--- stupid google doesn't provide a 'real' access to id, instead it is put inside a string that looks like so:
		http://docs.google.com/feeds/documents/private/full/spreadsheet%3AXXXXXXXXXX
		So we split on %3a --->
		<cfset parts = entry.id.xmltext.split("%3A")>
		<cfset querySetCell(docs, "id", parts[arrayLen(parts)])>
		<cfset querySetCell(docs, "title", entry.title.xmltext)>
		<!--- todo, parse date --->
		<cfset querySetCell(docs, "updated", updated)>

		<cfset querySetCell(docs, "starred", false)>

		<!--- search category node --->
		<cfloop index="y" from="1" to="#arrayLen(entry.category)#">
			<cfif entry.category[y].xmlAttributes.scheme is "http://schemas.google.com/g/2005##kind">
				<cfset querySetCell(docs, "type", entry.category[y].xmlAttributes.label)>
			<!--- not sure this check is secure enough - may need to check more labels --->
			<cfelseif entry.category[y].xmlAttributes.scheme is "http://schemas.google.com/g/2005/labels">
				<cfset querySetCell(docs, "starred", true)>
			</cfif>
		</cfloop>

		<cfset querySetCell(docs, "sourceurl", entry.content.xmlattributes.src)>
		<!--- find the Link that is alternate --->
		<cfloop index="y" from="1" to="#arrayLen(entry.link)#">
			<cfif entry.link[y].xmlAttributes.rel is "self">
				<cfset querySetCell(docs, "link", entry.link[y].xmlattributes.href)>
			</cfif>
		</cfloop>

		<cfset querySetCell(docs, "author", entry.author.name.xmlText)>
		<cfset querySetCell(docs, "authoremail", entry.author.email.xmlText)>
	</cfloop>
	
	<cfreturn docs>
</cffunction>

<cffunction name="spreadSheetFormat" access="private" returnType="numeric" output="false" hint="Google requires numbers for Excel formats. This lets you provide a simple format.">
	<cfargument name="format" type="string" required="true">
	<cfswitch expression="#arguments.format#">
		<cfcase value="xls">
			<cfreturn 4>
		</cfcase>
		<cfcase value="csv">
			<cfreturn 5>
		</cfcase>
		<cfcase value="pdf">
			<cfreturn 12>
		</cfcase>
		<cfcase value="ods">
			<cfreturn 13>
		</cfcase>
		<cfcase value="tsv">
			<cfreturn 23>
		</cfcase>
		<cfcase value="html">
			<cfreturn 102>
		</cfcase>
		<cfdefaultcase>
			<cfreturn 102>
		</cfdefaultcase>
	</cfswitch>
</cffunction>


</cfcomponent>