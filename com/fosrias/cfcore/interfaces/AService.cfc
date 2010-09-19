////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * The AService component is the abstract base class for all service 
 * components and implements service wide utility functions.
 */
component hint="Base class for services."
{
    import CFCore.com.fosrias.cfcore.components.CallResult;
    
	//--------------------------------------------------------------------------
    //
    //  Abstract constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    private void function init()
	{
	   //Does nothing currently
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Utility method to return remote calls in wrapper that can
	 * include a message.
     */
    public CallResult function callResult(any data, String message = "")
    {
       return new CallResult(data, message);
    }
}
