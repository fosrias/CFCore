////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/*
 * The AORMApplication is the base class for ORM applications. Extending this
 * class enables default RESTful services to access database models 
 * automatically by using the following naming conventions:
 *
 * table:   my_models (with field names 'my_field')
 * model:   MyModel.cfc (which must be unique, application wide)
 * service: MyModelsService.cfc
 *
 * @see AORMComponent.cfc, ARESTfulService.cfc
 */
component
{
    include "/CFCore/com/fosrias/core/components/InflectionFunctions.cfc";
	include "/CFCore/com/fosrias/core/components/ORMFunctions.cfc";
	
    this.ormenabled = true;
	this.ormsettings.logSQL = true;
	this.ormsettings.eventhandling = true;
	
	//--------------------------------------------------------------------------
    //
    //  Abstract Constructor
    //
    //--------------------------------------------------------------------------
    
    /*
     * @hint Adds structures to map primary keys for ORM components.
     */
    private void function onApplicationStart()
    {
        initInflection();
        initORMStructures();
		
		//Define the application settings for tracking reset
        APPLICATION.dateInitialized = now();
		
		//Reset this value if application was reset by index.cfm
		this.applicationTimeout = createTimeSpan( 172700, 0, 0, 0 );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /*
     * @hint Clears the APPLICATION mappings.
     */
    public void function onApplicationEnd()
	{
	   clearInflection();
	   clearORMStructures();
	}
	
	/*
     * @hint Error handler for application. Primarily used to rethrow an
	 * error when login validation fails.
     */
    public void function onError(any exception, string eventName)
	{
        if (eventName eq "onRequestStart" AND FindNoCase('Your username and/or password is invalid', exception.rootcause.message)  )
		{
		  throw(message="#exception.rootcause.message#");
		  
		} else {
		
            throw(object=exception);
		}
            
	}
}