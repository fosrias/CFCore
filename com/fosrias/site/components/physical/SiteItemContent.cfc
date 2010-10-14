////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * Since this base class is an ORM class, the table needs a discriminator
 * column set on it or else ORM mappings try to force one. Seems that you can't
 * extend ORM components without it treating it like single table inheritance
 * as a default.
 */
component extends="CFCore.com.fosrias.core.interfaces.AORMComponent" 
          hint="The model for sites"
          persistent="true"
          alias="com.fosrias.site.components.physical.SiteItemContent"
          style="rpc"
          table="site_item_contents"
{
	property name="id" column="id" type="numeric" ormtype="long" fieldtype="id" 
	         generator="native" unsavedvalue="0"; 
	property name="siteItemId" column="site_item_id" type="numeric" 
	         ormtype="long" default="0";
    property name="text" column="text" type="string" ormtype="string"; 
	property name="link" column="link" type="string" ormtype="string"; 
	property name="fileName" column="file_name" type="string" ormtype="string"; 
	property name="fileLocation" column="file_location" type="string" ormtype="string"; 
    property name="fileType" column="file_type" type="string" ormtype="string"; 
	property name="fileSize" column="file_size" type="numeric" ormtype="int"; 
	property name="fileContent" column="file_content" type="binary"; //ormtype="java.lang.Object"; 
	property name="revision" type="numeric" ormtype="integer" default="1";
    property name="createdAt" column="created_at" type="date"; 
	property name="updatedAt" column="updated_at" type="date" ormtype="timestamp"; 
	property name="item"  persistent="false" type="any";
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    remote SiteItemContent function init()
    {
        super.init();
        return this;
    }
	
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Increments the revision number when new item contents are created.
     */
    public void function incrementRevision()
	{
        var lastRecord = EntityLoad("SiteItemContent", 
		    { siteItemId = this.getsiteItemId() }, "revision DESC",
			{offset=0, maxResults=1} );
		
		if (ArrayLen(LOCAL.lastRecord) gt 0)
	    {
		    this.setrevision(LOCAL.lastRecord[1].getrevision() + 1);
	    }
	}
} 
