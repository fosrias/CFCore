////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/*
 * The CallResult component is a utility payload component that returns 
 * a data object with an optional message
 */
component  hint="Payload object for returning data calls with messages"
           alias="com.fosrias.core.vos.CallResult"
		   type="rpc"
{
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------
    
    property name="data" 
	         getter="true" 
			 type="any" 
			 hint="The data payload.";

	//----------------------------------
    //  message
    //----------------------------------
    
    property name="message"
	         getter="true"
			 setter="true" 
	         type="string" 
	         hint="The message";
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
     */
    public CallResult function init(any Data, String message = '')
	{
	   this.data = data;
	   this.message = message;
	   return this;
	}
}