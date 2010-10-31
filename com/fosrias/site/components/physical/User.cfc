component extends="CFCore.com.fosrias.core.interfaces.AORMComponent" 
          hint="Users"
          persistent="true"
          alias="com.fosrias.site.components.physical.User"
          style="rpc"
          table="users"
{
	/* properties */
	
	property name="id" column="id" type="numeric" ormtype="long" fieldtype="id" 
             generator="native" unsavedvalue="0"; 
	property name="nickname" column="alias" type="string" ormtype="string" ; 
    property name="login" column="login" type="string" ormtype="string" ; 
    property name="cryptedPassword" column="crypted_password" type="string" default="" ormtype="string" remotingfetch="false"; 
	property name="passwordSalt" column="password_salt" type="string" default="" ormtype="string" remotingfetch="false"; 
	property name="persistenceToken" column="persistence_token" type="string" default="" ormtype="string" ; 
	property name="loginCount" column="login_count" type="numeric" ormtype="int" default="0" ; 
	property name="lastRequestAt" column="last_request_at" type="date" default="" ormtype="timestamp" ; 
	property name="lastLoginAt" column="last_login_at" type="date" default="" ormtype="timestamp" ; 
	property name="lastLoginIp" column="last_login_ip" type="string" default="" ormtype="string" ; 
	property name="currentLoginIp" column="current_login_ip" type="string" default="" ormtype="string" ; 
	property name="password" persistent="false" type="string" default="" remotingfetch="false"; 
    property name="oldPassword" persistent="false" type="string"  default="" remotingfetch="false";
    property name="createdAt" column="created_at" type="date"; 
	property name="updatedAt" column="updated_at" type="date" ormtype="timestamp" ; 	
	property name="roles" fieldtype="many-to-many" CFC="UserRole"  linktable="user_roles_users" 
             FKColumn="user_id" inversejoincolumn="authorizable_id" fetch="join"
             cascade="save-update" orderby="authorizable_id" type="array" remotingfetch="true";
			 
    public User function init()
	{
	   super.init();
	   return this;
	}
	
	public string function getrolesList()
    {
	   var rolesList = "";
	   
	   var length = ArrayLen( this.getroles() );
	   For (i=1; i LTE length; i=i+1)
	   {
	       rolesList = rolesList & this.getroles()[i].getname();
		   
		   if (i LT length AND length > 0)
		      rolesList = rolesList  & ",";
	   }
         
	   return rolesList;
	}
	
	public void function logSession()
    {
		this.setloginCount(this.getloginCount() + 1);
		this.setlastLoginAt( Now() ); 
		this.setlastLoginIp( this.getcurrentLoginIp() ) ; 
		this.setcurrentLoginIp(CGI.REMOTE_ADDR); 
		EntitySave(this);
	}
} 
