<!--- create the analytics component --->
<cfset analytics = createObject("component", "analytics") />
<cfdump var="#analytics#" expand="false" />

<!--- authenticate with the mother ship --->
<cfset analytics.authenticate('email addy','google account password') />
<cfset accountData = analytics.getAccountData() />
<cfdump var="#accountData#" label="Account Data">

<!--- query the account data results to get a specific site ID --->
<cfquery name="qID" dbtype="query">
select tableID
from accountData
where title like <cfqueryparam value="%********your domain name *************%" cfsqltype="cf_sql_varchar" />
</cfquery>

<cfset myID = qID.tableID[1] />
<cfdump var="#myID#">

<!--- page to work with in method calls (optional)--->
<cfset page = "/blog/client/index.cfm" />

<!--- raw call to the getAnalyticsData function --->
<cfset analyticsData = analytics.getAnalyticsData(id=myid,dimensions="ga:keyword", metrics="ga:visits", maxResults=25) />
<cfdump var="#analyticsData#" label="visits by keyword" />

<!--- get a summary of referring sites and keywords (starting at row 50) --->
<cfset qReferrer = analytics.getReferrerSummary(id=myid,pagePath='#left("~#page#/", 32)#',maxResults=25,startIndex=50) />
<cfdump var="#qReferrer#" label="Referrer Summary">

<!--- browser summary --->
<cfset qBrowser = analytics.getBrowserSummary(id=myid,maxResults=25) />
<cfdump var="#qBrowser#" label="Browser Summary">
		
<cfset contentOverview = analytics.getContentOverview(id=myID,maxResults=10) />		
<cfdump var="#contentOverview#" top="10" label="Content Overview">

<cfset trafficOverview = analytics.getTrafficSourceOverview(id=myID,maxResults=10) />		
<cfdump var="#trafficOverview#" top="10" label="Traffic Source Overview">

<cfset keywordOverview = analytics.getKeywordOverview(id=myID,maxResults=10) />		
<cfdump var="#keywordOverview#" top="10" label="Keyword Overview">

<!--- geo overview by continent --->
<cfset geographicOverview = analytics.getGeographicOverview(id=myID,maxResults=10) />		
<cfdump var="#geographicOverview#" top="10" label="Geo Overview">
<!--- by country --->
<cfset geographicOverview = analytics.getGeographicOverview(id=myID,geographicalGrouping='country',maxResults=10) />		
<cfdump var="#geographicOverview#" top="10" label="Geo Overview">
<!--- by city --->
<cfset geographicOverview = analytics.getGeographicOverview(id=myID,geographicalGrouping='city',maxResults=10) />		
<cfdump var="#geographicOverview#" top="10" label="Geo Overview">


