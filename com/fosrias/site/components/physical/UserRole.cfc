component extends="CFCore.com.fosrias.core.interfaces.AORMComponent" 
          hint="User roles"
          persistent="true"
          alias="CFCore.com.fosrias.site.components.physical.UserRole"
          style="rpc"
          table="user_roles"
{
	property name="authorizableId" column="authorizable_id" type="numeric" ormtype="long" fieldtype="id" 
             generator="native" unsavedvalue="0" default="0";
	property name="authorizableType" column="authorizable_type" type="string" ormtype="string" default=""; 
	property name="name" column="name" type="string" ormtype="string" ; 
	property name="description" column="description" type="string" ormtype="string" ; 
	property name="users" fieldtype="many-to-many" CFC="User" linktable="user_roles_users" 
             FKColumn="authorizable_id" inversejoincolumn="user_id" cascade="all" 
             orderby="user_id" lazy="true" remotingfetch="false";
	
	/**
     * Constructor
     */
    remote function init()
    {
	    super.init();
	}
} 
