////////////////////////////////////////////////////////////////////////////////
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
           alias="com.fosrias.site.components.physical.SiteItem"
           style="rpc"
           table="site_items"
{
	property name="id" ormtype="integer" type="numeric" fieldtype="id" 
             generator="native" unsavedvalue="0";
    property name="contentId" column="content_id" ormtype="integer" type="numeric";
    property name="parentId" column="parent_id" ormtype="integer" type="numeric" default="0";
    property name="lft" ormtype="integer" type="numeric";
    property name="rgt" ormtype="integer" type="numeric";
    property name="type" type="string" default="TEXT";
    property name="sortOrder" column="sort_order" ormtype="integer" type="numeric" default="0";
    property name="urlFragment" column="url_fragment" type="string" searchable="true";
    property name="browserTitle" column="browser_title" type="string" searchable="true";
    property name="name" type="string" searchable="true";
    property name="description" type="string" searchable="true";
    property name="tags" type="string" searchable="true";
    property name="isActive" column="is_active" type="boolean" default="false";
    property name="isMenuItem" column="is_menu_item" type="boolean" default="false";
    property name="menuSeparator" column="menu_separator" type="string" default="NONE";
    property name="isDeleted" column="is_deleted" type="boolean" default="false";
    property name="createdAt" column="created_at" ormtype="timestamp" type="date" ;
    property name="updatedAt" column="updated_at" ormtype="timestamp" type="date";
	property name="content" persistent="false" type="any";
	
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
	
	public string function defineWhereClause()
	{
	   //We only return values in the nesting.
	   return super.defineWhereClause() & " AND lft > 0";
	}
}