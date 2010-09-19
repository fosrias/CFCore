////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/*
 * Utility application service that is pasted into a cf project and available
 * for remote testing of application access.
 */
component  extends="CFCore.com.fosrias.cfcore.interfaces.AService" 
           hint="Remote service with functions to check on application."
{ 
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
	public ApplicationService function init()
	{
        super.init();
		return this;
    }
	 
    //--------------------------------------------------------------------------
    //
    //  Remote methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Remote method that checks if the application is initialized or not.
     */
    remote any function isInitialized()
    {
        return callResult( isDefined("APPLICATION") AND structKeyExists(
            APPLICATION, 'isInitialized') );
    }
	
	
    /**
     * @hint Remote method that shows the APPLICATION variable to debug
     * missing mappings.
     */
    remote any function showORMStructures()
    {
        return callResult(APPLICATION);
    }
}