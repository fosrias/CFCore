////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/*
 * Default items. Since this component is only used to upload data, it's alias
 * is not tied to a ColdFusion path and thus is not kept in the core library.
 */
component alias="CFCore.com.fosrias.site.components.utility.Defaults"
          style="rpc"
{
	property name="itemTypes" type="any" 
	         hint="The site item types";
			 
    property name="masterItem" type="SiteItem" 
	         hint="The top level site item.";
			 
	property name="items" type="any"
             hint="Site items used to build the menu and links.";

    public Defaults function init(boolean isBase = true)
	{
	    //Load the master site item
        this.masterItem = entityLoad("SiteItem", {type='SITE'}, true);
               
		//Pre-process master item
        if ( NOT structKeyExists(this, "masterItem") )
        {
            this.masterItem = 
			    new CFCore.com.fosrias.site.components.physical.SiteItem();
			
        } else {
		   
		   //Retrieve the masterItem content, which has lazy loading.
		   //We use lazy loading since we don't want the content with
		   //regular SiteItem calls since they build the site menu
		   //and their content is accessed as needed on page calls.
		   this.masterItem.setcontent( EntityLoad("SiteItemContent", 
		      this.masterItem.getcontentId() , true) );
		}
		
		//Return the default site items.
		if (isBase)
		{
            //Return all the items that are not non-menu or link items in
			//lists.
			this.items = ormExecuteQuery("FROM SiteItem WHERE is_list_detail " &
			    " = false AND lft > 0 AND is_active = true ORDER BY lft", false);
				
            //Check if the home page implementation is a marquee. If it
			//is, load its image content immediately.
			if (ArrayLen(this.items) > 3)
			{
                var home = this.items[2];
				var afterHome = this.items[3];
				
				if (afterHome.getparentId() eq home.getid() AND 
				    afterHome.gettype() eq 'MARQUEE')
				{
				    var i = 4;
					var item = this.items[i];
					while (item.getrgt() lt afterHome.getrgt() )
					{
					   //Direct children of a marquee must be image file 
					   //content.
					   if ( item.getparentId() eq afterHome.getid() )
					   {
					       item.setcontent( EntityLoad("SiteItemContent",
						      item.getcontentId(), true) );
						  
					   }
					   i = i + 1;
					   item = this.items[i];
					}
					 ORMFlush();
				}
			}
				
		} else {
		  
		    //Load content manager selectors
            this.itemTypes =  ormExecuteQuery("FROM SiteItemType ORDER BY " & 
                "sortOrder ASC", false );
		}
		
	   return this;
	}
}