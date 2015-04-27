
<cfset docs = createObject("component", "docs")>

<cfset docs.authenticate("email addy","password")>

<!--- get all --->
<cfset mydocs = docs.getDocumentList()>
<cfdump var="#mydocs#" top=60 label="all">

<!--- get presos --->
<cfset mydocs = docs.getDocumentList(doctype='presentation')>
<cfdump var="#mydocs#" top=60 label="presentation" expand="false">

<!--- get starred --->
<cfset mydocs = docs.getDocumentList(starred=true)>
<cfdump var="#mydocs#" top=60 expand="false">

<!--- get starred, presentation --->
<cfset mydocs = docs.getDocumentList(doctype='presentation',starred=true)>
<cfdump var="#mydocs#" top=60 expand="false">

<!--- get starred, presentation, and contains word bullet --->
<cfset mydocs = docs.getDocumentList(doctype='presentation',starred=true,search='bullet')>
<cfdump var="#mydocs#" top=60>

<!--- contains word camden --->
<cfset mydocs = docs.getDocumentList(search='camden')>
<cfdump var="#mydocs#" top=60 expand="false">
<!--- will only work if first type if document or presentation --->
<cfset content = docs.download(mydocs.id[1],mydocs.type[1],'txt',1)>
<cfoutput>
<pre>
#content#
</pre>
</cfoutput>

<!--- get soreadsheets --->
<cfset mydocs = docs.getDocumentList(doctype='spreadsheet')>
<cfdump var="#mydocs#" top=60 label="Spreadsheets">

<!--- get first spreadsheet --->
<cfset content = docs.download(mydocs.id[1],mydocs.type[1],'html',1)>
<cfoutput>
<pre>
#content#
</pre>
</cfoutput>

<!--- Test PPT as PDF --->
<!---
<cfoutput>getting #mydocs.id[1]#<br></cfoutput>
<cfset content = docs.download(mydocs.id[1],mydocs.type[1],'pdf')>
<cfset fileWrite(expandPath("./test.pdf"), content)>
--->

<!---
<cfoutput>
<pre>
result is #trim(content)#
</pre>
</cfoutput>
--->
<!---
<cfset content = docs.download(mydocs.id[2],mydocs.type[2])>
<cfoutput>result is #trim(content)#</cfoutput>
--->
<!---

<hr>

<cfset mydocs = docs.getDocumentList(title="Blog")>
<cfdump var="#mydocs#" label="Search for Blog">

<hr>

<cfset content = docs.download(mydocs.sourceurl[1])>
<cfoutput>result is #content#</cfoutput>
--->