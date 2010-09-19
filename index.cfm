<cfsetting showdebugoutput="false" />

<!---
Param a variable in the application. We are doing this
outside of the OnApplicationStart() method to test whether
or not the application was truly killed of if the above
method was simply called.
--->

<cfparam name="application.hitCount" type="numeric" default="0" />
 
<!--- Increment the hit count. --->
<cfset application.hitCount++ />
 
<cfoutput>
<h1>
    Application Overview
</h1>
 
<p>
    Application hit count: #application.hitCount#
</p>
 
<p>
    Application initialized: #dateDiff("s", application.dateInitialized, 
	   now() )# seconds ago.
</p>
 
<p>
    <a href="reset.cfm">Reset application</a> &raquo;
</p>

</cfoutput>
