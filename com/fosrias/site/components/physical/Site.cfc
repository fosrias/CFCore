////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

component extends="CFCore.com.fosrias.core.interfaces.AORMComponent" 
          hint="The model for sites"
          persistent="true"
          alias="com.fosrias.site.components.physical.Site"
          style="rpc"
          table="sites"
{
    property name="id" ormtype="integer" type="numeric" fieldtype="id" 
             generator="native";
    property name="contactEmail" column="contact_email"  type="string";
    property name="webmasterEmail" column="webmaster_email"  type="string";
    property name="url" type="string";
    property name="title" type="string" searchable="true";
    property name="description" type="string" searchable="true";
    property name="tags" type="string" searchable="true";
    property name="sessionEditor" column="session_editor" type="string";
    property name="sessionAt" column="session_at" ormtype="timestamp" type="date";
    property name="createdAt" column="created_at" ormtype="timestamp" type="date";
    property name="updatedAt" column="updated_at" ormtype="timestamp" type="date";

    /**
     * @hint A initialization routine, runs when object is created.
     */
    remote Site function init()
    {
        super.init();
        return this;
    }
}