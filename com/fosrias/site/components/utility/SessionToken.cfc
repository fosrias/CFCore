component alias="com.fosrias.core.vos.SessionToken"
{
	property name="nickname" type="string";
	property name="userId" type="integer";
	property name="userRoles" type="array";
    
    public SessionToken function init(required numeric userId, 
	                                  required string nickname,
									  required array userRoles)
	{
	   this.nickname =  ARGUMENTS.nickname;
	   this.userId =    ARGUMENTS.userId;
	   this.userRoles = ARGUMENTS.userRoles;
	   return this;
	}
}