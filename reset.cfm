<!---
Stop the application. After calling this method, the next
page request to the application should start it up again
(resetting it).
--->

<cfset APPLICATION.applicationTimeout = createTimeSpan( 0, 0, 1, 0 )/>
<cfset applicationStop() />
 
<!--- Redirect back to overview. --->
<cflocation url="index.cfm" addtoken="false"/>