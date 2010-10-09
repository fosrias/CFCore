////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

component extends="CFCore.com.fosrias.core.interfaces.AORMApplication"
{
	this.name       = "Core Libray";
	//this.datasource = "None";

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /*
	 * @hint Initialzes ORM functionality and ORM models
	 */
    public boolean function onApplicationStart() 
	{
	    //Must be first line
		super.onApplicationStart();
		
		//Add services to make sure they are configured correctly
		//Run index.cfm to check everything is loading correctly
		//Relace the following with a pasted in version in actual application
		//that is running
		application.applicationService = 
		    new com.fosrias.cfCore.services.ApplicationService();
		
		//Create a model to populate its maps and make sure it is working
		//new ApplicationName.package.samplesService();
        
		//This must be last line
		setORMInitialized();
		
        return true;
    }
}