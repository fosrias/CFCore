////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

component alias="com.fosrias.site.components.utility.Defaults"
          style="rpc"
{
	property name="itemTypes" type="any" 
	         hint="The site item types";
	property name="masterItem" type="SiteItem" 
	         hint="The top level site item.";
	//property name="masterItemContent" type="SiteContentOnly" 
	//         hint="The top level site item.";

    public Defaults function init()
	{
	    //Load properties. Don't load site. It is the default only on a 
		//new site, which is handled on the client.
	    this.itemTypes =  ormExecuteQuery( 
		    "FROM SiteItemType WHERE code <> 'SITE' AND code <> 'HOME' ORDER " &
			"BY sortOrder ASC", false );
			
        this.masterItem = entityLoad( "SiteItem", {type='SITE'}, true );
               
		//Pre-process master item
        if ( NOT structKeyExists(this, "masterItem") )
        {
            this.masterItem = 
			    new CMService.com.fosrias.cm.components.physical.SiteItem();
			
        } else {
		   
		   //Retrieve the masterItem content, which has lazy loading.
		   //We use lazy loading since we don't want the content with
		   //regular SiteItem calls since they build the site menu
		   //and their content is accessed as needed on page calls.
		   this.masterItem.setcontent( EntityLoad("SiteItemContent", 
		      this.masterItem.getcontentId() , true) );
		}
		
	   return this;
	}
}