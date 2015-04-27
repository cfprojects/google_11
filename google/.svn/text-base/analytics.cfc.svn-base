<cfcomponent output="false" extends="google" displayname="google analytics API">
	<cfset variables.anaylticsService = "analytics" />
	<cfset variables.username = "" />
	<cfset variables.baseURL = "https://www.google.com/analytics/feeds" />
	<!--- todo: rock the bells --->
	
	<cffunction name="authenticate" access="public" returnType="void" output="false" hint="I authenticate a user for a service. If login fails, I throw an error.">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		<!--- store the username in instance data since analytics needs to pass it --->
		<cfset variables.username = arguments.username />
		
		<cfset super.authenticate(arguments.username,arguments.password,variables.anaylticsService) />	
	</cffunction>
	
	<cffunction name="getAccountData" access="public" returntype="any" output="false" hint="i get analytics account data">
		<cfset var result = "" />
		<cfset var entries = "" />
		<cfset var packet = "" />
		<cfset var qData = queryNew("id,title,updated,tableID,accountID,accountName,profileID,webPropertyID") />
		<cfset var e = "" />
		<cfset var ee = "" />
		<cfset var dxp = "" />
		<cfset var thisEntry = "" />
		<cfset var thisEntriesdxpProps = "" />
		
		<cfhttp url="#variables.baseURL#/accounts/default" method="GET" result="result" charset="utf-8">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#getAuth(variables.anaylticsService)#">
			<cfhttpparam type="header" name="GData-Version" value="2.0">
		</cfhttp>
		<cfdump var="#result#">
		<cfif not isXml(result.fileContent)>
			<cfthrow message="#result.fileContent#">
		</cfif>
		
		<cfset packet = xmlParse(result.fileContent)>
		
		<cfset entries = xmlSearch(packet,"//:feed/:entry") />
		
		<cfset queryAddRow(qData,arrayLen(entries)) />

		<cfloop from="1" to="#arrayLen(entries)#" index="e">
			<cfset thisEntry = entries[e] />
			<cfloop from="1" to="#arrayLen(thisEntry)#" index="ee">
				<cfset thisEntriesdxpProps = xmlSearch(thisEntry[ee], "dxp:property") />			
				<cfset querySetCell(qData,"id", thisEntry[ee]["id"].xmlText, e) />		
				<cfset querySetCell(qData,"updated", thisEntry[ee]["updated"].xmlText, e) />
				<cfset querySetCell(qData,"title", thisEntry[ee]["title"].xmlText, e) />
				<cfset querySetCell(qData,"tableID", thisEntry[ee]["dxp:tableID"].xmlText, e) />
				<cfloop from="1" to="#arrayLen(thisEntriesdxpProps)#" index="dxp">
					<cfif listFindNoCase(qData.columnList, replace(thisEntriesdxpProps[dxp].xmlAttributes.name,"ga:",""))>
						<cfset querySetCell(qData, replace(thisEntriesdxpProps[dxp].xmlAttributes.name,"ga:",""), thisEntriesdxpProps[dxp].xmlAttributes.value, e) />
					</cfif>
				</cfloop>
			</cfloop>
		</cfloop>
		
		<cfreturn qData />
	</cffunction>
	
	<cffunction name="getBrowserSummary" access="public" returntype="struct" output="false" hint="i get summary of the page views by browser for the given site or page.  i will return page path, browser and view count">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="pagePath" required="false" hint="to filter on a particular page path pass it in" default="" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfset var args = {} />
		<cfset args.id = arguments.id />
		<cfif len(arguments.pagePath)>
			<cfset args.dimensions = "ga:pagePath,ga:browser" />
		<cfelse>
			<cfset args.dimensions = "ga:browser" />
		</cfif>
		<cfset args.metris = "ga:pageviews" />
		<cfset args.startDate = arguments.startDate />
		<cfset args.endDate = arguments.endDate />
		<cfset args.sort = "-ga:pageviews" />
		<cfset args.maxResults = arguments.maxResults />
		<cfif len(arguments.pagePath)>
			<cfset args.filters = "ga:pagePath=#arguments.pagePath#" />
		</cfif>
		<cfset args.startIndex = arguments.startIndex />
		
		<cfreturn getAnalyticsData(argumentCollection=args) />
	</cffunction>
	
	<cffunction name="getReferrerSummary" access="public" returntype="struct" output="false" hint="i get summary of the page views by referrer for the given site or page.  i will return page path, source (domain), keyword and view count">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="pagePath" required="false" hint="to filter on a particular page path pass it in" default="" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfset var args = {} />
		<cfset args.id = arguments.id />
		<cfif len(arguments.pagePath)>
			<cfset args.dimensions = "ga:pagePath,ga:source,ga:keyword" />
		<cfelse>
			<cfset args.dimensions = "ga:source,ga:keyword" />
		</cfif>
		<cfset args.metris = "ga:pageviews" />
		<cfset args.startDate = arguments.startDate />
		<cfset args.endDate = arguments.endDate />
		<cfset args.sort = "-ga:pageviews" />
		<cfset args.maxResults = arguments.maxResults />
		<cfif len(arguments.pagePath)>
			<cfset args.filters = "ga:pagePath=#arguments.pagePath#" />
		</cfif>
		<cfset args.startIndex = arguments.startIndex />
		
		<cfreturn getAnalyticsData(argumentCollection=args) />
	</cffunction>
	
	<cffunction name="getContentOverview" access="public" returntype="struct" output="false" hint="i get a content overview for the given site.  i will return page path and view count">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfreturn getAnalyticsData(id=arguments.id,dimensions='ga:pagePath',metrics='ga:pageviews',startDate=arguments.startDate,endDate=arguments.endDate,sort='-ga:pageviews',maxResults=arguments.maxResults,startIndex=arguments.startIndex) />
	</cffunction>
	
	<cffunction name="getTrafficSourceOverview" access="public" returntype="struct" output="false" hint="i get a traffic source overview for the given site.  i will return referring source domain and visit count">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfreturn getAnalyticsData(id=arguments.id,dimensions='ga:source',metrics='ga:visits',startDate=arguments.startDate,endDate=arguments.endDate,sort='-ga:visits',maxResults=arguments.maxResults,startIndex=arguments.startIndex) />
	</cffunction>
	
	<cffunction name="getKeywordOverview" access="public" returntype="struct" output="false" hint="i get a keyword overview for the given site.  i will return keyword and visit count that used that keyword to reach your site">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfreturn getAnalyticsData(id=arguments.id,dimensions='ga:keyword',metrics='ga:visits',startDate=arguments.startDate,endDate=arguments.endDate,sort='-ga:visits',maxResults=arguments.maxResults,startIndex=arguments.startIndex) />
	</cffunction>
	
	<cffunction name="getGeographicOverview" access="public" returntype="struct" output="false" hint="i get a geographic overview for the given site.  i will return []">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="geographicalGrouping" required="false" hint="level at which to pull geo overview.  must be one of continent,subContinent,country,region,city.  default: continent" default="continent" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfset var l = "" />
		<cfset var e = "" />
		<cfset var validGroupings = "continent,subContinent,country,region,city" />
		
		<cfif not listFindNoCase(validGroupings,arguments.geographicalGrouping)>
			<cfthrow type="GoogleAnalyticsAPI.InvalidArgument" message="Invalid Argument"  detail="The value of the geographicalGrouping argument which is currently #arguments.geographicalGrouping# must be one of the following: '#validGroupings#'." />
		</cfif>
		<cfswitch expression="#arguments.geographicalGrouping#">
			<cfcase value="subContinent">
				<cfset e = "ga:subContinent" />
			</cfcase>
			<cfcase value="country">
				<cfset e = "ga:country" />
			</cfcase>
			<cfcase value="region">
				<cfset e = "ga:region" />
			</cfcase>
			<cfcase value="city">
				<cfset e = "ga:city" />
			</cfcase>
			<cfdefaultcase>
				<cfset e = "ga:continent" />
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn getAnalyticsData(id=arguments.id,dimensions=e,metrics='ga:visits,ga:pageviews,ga:timeOnSite,ga:newVisits',startDate=arguments.startDate,endDate=arguments.endDate,sort='-ga:visits',maxResults=arguments.maxResults,startIndex=arguments.startIndex) />
	</cffunction>
	
	<cffunction name="getAnalyticsData" access="public" returntype="struct" output="false" hint="i get analytics data">
		<cfargument name="id" required="true" hint="the tableID of the site you would like to retrieve data from (see getAccountData() method)  ex: ga1234" />
		<cfargument name="dimensions" required="false" hint="the analytic dimensions to grab (max 7 per query)" default="ga:browser,ga:country,ga:city,ga:countOfVisits,ga:date,ga:visitorType" />
		<cfargument name="metrics" required="false" hint="the analytic metrics to grab (max 10 per query)" default="ga:pageviews,ga:timeOnPage,ga:uniquePageViews" />
		<cfargument name="filters" required="false" hint="filter used to limit results" default="" />
		<cfargument name="startDate" required="false" hint="the first date from which to collect data from the profile (default is 30 days prior to now())" default="#dateAdd("d", now(), -30)#" />
		<cfargument name="endDate" required="false" hint="the last date from which to collect data from the profile (default is now())" default="#now()#" />
		<cfargument name="sort" required="false" hint="data fields to sort the given results by" default="" />
		<cfargument name="maxResults" required="false" hint="max number of entries to fetch (defaults and not to exceed 1000)" default="1000" />
		<cfargument name="startIndex" required="false" hint="start index for results (used for pagination - default is 1)" default="1" />
		<cfset var result = "" />
		<cfset var sDate = dateFormat(arguments.startDate,"yyyy-mm-dd") />
		<cfset var eDate = dateFormat(arguments.endDate,"yyyy-mm-dd") />
		<cfset var entries = "" />
		<cfset var packet = "" />
		<cfset var e = "" />
		<cfset var ee = "" />
		<cfset var d = "" />
		<cfset var m = "" />
		<cfset var a = "" />
		<cfset var thisEntry = "" />
		<cfset var thisEntriesDimensions = "" />
		<cfset var thisEntriesMetrics = "" />
		<cfset var rStruct = structNew() />
		<cfset var eArr = arrayNew(1) />
		<cfset var eStruct = structNew() />
		<cfset var qE = queryNew("") />
		<cfset var mc = "" />
		<cfset var dc = "" />
		<cfset var ac = "" />
		<cfset var agg = "" />
		<cfset rStruct.metadata = structNew() />
		
		<cfhttp url="#variables.baseURL#/data" method="get" result="result" charset="utf-8">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#getAuth(variables.anaylticsService)#">
			<cfhttpparam type="header" name="GData-Version" value="2.0">
			<cfhttpparam type="url" name="ids" value="#arguments.id#" />
			<cfhttpparam type="url" name="max-results" value="#arguments.maxResults#" />
			<cfhttpparam type="url" name="start-date" value="#sDate#" />
			<cfhttpparam type="url" name="end-date" value="#eDate#" />
			<cfhttpparam type="url" name="dimensions" value="#arguments.dimensions#" />
			<cfhttpparam type="url" name="metrics" value="#arguments.metrics#" />
			<cfhttpparam type="url" name="start-index" value="#arguments.startIndex#" />
			<cfif len(arguments.sort)>
				<cfhttpparam type="url" name="sort" value="#arguments.sort#" />
			</cfif>
			<cfif len(arguments.filters)>
				<cfhttpparam type="url" name="filters" value="#cleanOperators(arguments.filters)#" />
			</cfif>
		</cfhttp>
		<cfif not isXml(result.fileContent)>
			<cfthrow message="#result.fileContent#">
		</cfif>
		
		<cfset packet = xmlParse(result.fileContent)>
		
		<cfif isXML(result.fileContent) and structKeyExists(packet, "errors")>
			<cfthrow type="GoogleAnalyticsAPI.RemoteError" message="#packet.errors.error.internalReason.xmlText#">
		</cfif>
		<cfset rStruct.metadata["startDate"] = arguments.startDate />
		<cfset rStruct.metadata["endDate"] = arguments.endDate />
		
		<cfset rStruct.metadata["totalResults"] = packet.feed["openSearch:totalResults"].xmlText />
		<cfset rStruct.metadata["startIndex"] = packet.feed["openSearch:startIndex"].xmlText />
		<cfset rStruct.metadata["itemsPerPage"] = packet.feed["openSearch:itemsPerPage"].xmlText />
		
		<cfset entries = xmlSearch(packet,"//:feed/:entry") />
		
		<cfif arrayLen(entries)>
			<cfset queryAddRow(qE,arrayLen(entries)) />
		</cfif>
		
		<cfloop from="1" to="#arrayLen(entries)#" index="e">
			<cfset thisEntry = entries[e] />
			
			<cfloop from="1" to="#arrayLen(thisEntry)#" index="ee">
				<cfset thisEntriesDimensions = xmlSearch(thisEntry[ee], "dxp:dimension") />			
				<cfset eStruct = structNew() />
				<cfloop from="1" to="#arrayLen(thisEntriesDimensions)#" index="d">
					<cfset dc = replace(thisEntriesDimensions[d].xmlAttributes.name,"ga:","") />
					<cfif not listContainsNoCase(qE.columnList,dc)>
						<cfset queryAddColumn(qE,dc,arrayNew(1)) />
					</cfif>
					<cfset querySetCell(qE,dc,thisEntriesDimensions[d].xmlAttributes.value,e) />
					<!--- <cfset eStruct[dc] = thisEntriesDimensions[d].xmlAttributes.value /> --->
				</cfloop>
				
				<cfset thisEntriesMetrics = xmlSearch(thisEntry[ee], "dxp:metric") />			
				
				<cfloop from="1" to="#arrayLen(thisEntriesMetrics)#" index="m">
					<cfset mc = replace(thisEntriesMetrics[m].xmlAttributes.name,"ga:","") />
					<cfif not listContainsNoCase(qE.columnList,mc)>
						<cfset queryAddColumn(qE,mc,arrayNew(1)) />
					</cfif>
					<cfset querySetCell(qE,mc,thisEntriesMetrics[m].xmlAttributes.value,e) />
				</cfloop>
				
				<cfset arrayAppend(eArr, eStruct) />
			</cfloop>
		</cfloop>
		<!--- have we got any aggregate goodies? --->
		<cfset agg = xmlSearch(packet, "//:feed/dxp:aggregates/dxp:metric") />
		<cfloop from="1" to="#arrayLen(agg)#" index="a">
			<cfset ac = replace(agg[a].xmlAttributes.name,"ga:","") />
			<cfset rStruct.metadata[ac] = agg[a].xmlAttributes.value />
		</cfloop>
		
		<cfset rStruct.data = qE />
		<cfreturn rStruct />
	</cffunction>
	
	<cffunction name="cleanOperators" access="private" output="false" returntype="string" hint="i url encode the filter operators">
		<cfargument name="filter" required="true" />
		<cfset var r = "" />
		<cfset r = replace(arguments.filter,"==", urlEncodedFormat("==")) />
		<cfset r = replace(arguments.filter,"!=", urlEncodedFormat("!=")) />
		<cfset r = replace(arguments.filter,">", urlEncodedFormat(">")) />
		<cfset r = replace(arguments.filter,"<", urlEncodedFormat("<")) />
		<cfset r = replace(arguments.filter,">=", urlEncodedFormat(">=")) />
		<cfset r = replace(arguments.filter,"<=", urlEncodedFormat("<=")) />
		<cfset r = replace(arguments.filter,"=~", urlEncodedFormat("=~")) />
		<cfset r = replace(arguments.filter,"!~", urlEncodedFormat("!~")) />
		<cfset r = replace(arguments.filter,"!@", urlEncodedFormat("!@")) />
		<cfset r = replace(arguments.filter,"^", urlEncodedFormat("^")) />
		<cfreturn r />
	</cffunction>
	
</cfcomponent>