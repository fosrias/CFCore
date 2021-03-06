﻿////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

component  extends="CFCore.com.fosrias.core.interfaces.AORMComponent" 
           hint="Building block items of the site"
		   persistent="true"
		   optimisticlock="all"
		   dynamicupdate="true"
           alias="CFCore.com.fosrias.site.components.physical.SiteItem"
           style="rpc"
           table="site_items"
{
	property name="id" ormtype="integer" type="numeric" fieldtype="id" 
             generator="native" unsavedvalue="0";
    property name="contentId" column="content_id" ormtype="integer" type="numeric"  default="0";
    property name="parentId" column="parent_id" ormtype="integer" type="numeric" default="0";
    property name="lft" ormtype="integer" type="numeric";
    property name="rgt" ormtype="integer" type="numeric";
    property name="relatedItemId" column="related_item_id" ormtype="integer" type="numeric" default="0";
    property name="type" type="string" default="TEXT";
    property name="urlFragment" column="url_fragment" type="string" searchable="true";
    property name="browserTitle" column="browser_title" type="string" searchable="true";
    property name="name" type="string" searchable="true";
    property name="description" type="string" searchable="true";
    property name="tags" type="string" searchable="true";
    property name="xmlTags" column="xml_tags" type="string" searchable="true";
    property name="image" column="image" type="binary"; //ormtype="java.lang.Object"; 
    property name="isActive" column="is_active" type="boolean" default="false";
    property name="isLink" column="is_link" type="boolean" default="false";
    property name="isMenuItem" column="is_menu_item" type="boolean" default="false";
    property name="menuSeparator" column="menu_separator" type="string" default="NONE";
    property name="isDeleted" column="is_deleted" type="boolean" default="false";
    property name="isLocked" column="is_locked" type="boolean" default="false";
    property name="isSystem" column="is_system" type="boolean" default="false";
    property name="isListDetail" column="is_list_detail" type="boolean" default="false";
    property name="isSearchable" column="is_searchable" type="boolean" default="true";
    property name="createdAt" column="created_at" ormtype="timestamp" type="date" ;
    property name="updatedAt" column="updated_at" ormtype="timestamp" type="date";
	property name="content" persistent="false" type="any";
	property name="authors" persistent="false" type="any";
	property name="categories" persistent="false" type="any";
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
	 */
    remote SiteItem function init()
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
     * @hint Whether the item is the site master or not.
     */
    public boolean function getisMaster()
	{
	   return VARIABLE['type'] eq 'SITE';
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public string function defineWhereClause()
	{
	   //We only return values in the nesting.
	   return super.defineWhereClause() & " AND lft > 0";
	}
	
	public void function processListDetail()
    {
        var parent = entityLoad("SiteItem", this.getparentId(), true );
		
		//No parent when creating system site items
		if ( NOT structKeyExists(LOCAL, "parent") )
	       return;
		   
		switch ( parent.gettype() )
		{
            case "FAQ_LIST":
			case "LIST":
			case "LIST_BY_DATE":
            case "LIST_BY_NAME":
            case "POST_LIST":
			{
                //We only care if the parent is a list
				if ( this.gettype() eq "SITE_LINK" OR this.getisMenuItem() )
				{
				   //We keep links and menu items
				   this.setisListDetail(false);
				   
				} else  {
				
                    this.setisListDetail(true);
					
					if (this.gettype() EQ "LIST_SPACER")
					{
					   this.setisSearchable(false);
					}
					
				}
			}
		}
	}
}