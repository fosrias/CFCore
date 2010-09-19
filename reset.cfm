<!---
Stop the application. After calling this method, the next
page request to the application should start it up again
(resetting it).
--->
<cfset applicationStop() />
 
<!--- Redirect back to overview. --->
<cflocation url="index.cfm" addtoken="false"/>