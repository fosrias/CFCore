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
    
	include "/CFCore/com/fosrias/cfcore/components/InflectionFunctions.cfc";
    
    //--------------------------------------------------------------------------
    //
    //  Abstract constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    private void function init(string model = "Null")
	{
	   var serviceName = GetMetadata(this).name;
	   
	   if (ARGUMENTS.model eq "Null")
	   {
	       var modelName = REReplaceNoCase(serviceName, "service", "", "all");
		   
		   modelName = singularize( demodulize(modelName) );
           ARGUMENTS.model = modelName;
	   }
	   
	   APPLICATION.setServiceModelName(serviceName, ARGUMENTS.model);
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
	
	/*
     * @hint Abstract method for retrieving the model name associated with
     * the service.
     */
    public string function getsortOrder()
    {
       return APPLICATION.findSortOrder( this.getmodel() );
    }

    /*
     * @hint Abstract method for retrieving the model name associated with
     * the service.
     */
    public string function getmodel()
    {
       return APPLICATION.findServiceModelName( GetMetadata(this).name );
    } 
}
