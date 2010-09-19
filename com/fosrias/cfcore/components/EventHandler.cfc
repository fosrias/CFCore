////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * The Eventhandler component is a template for application wide event handling 
 * or ORM events. Implement these functions in an ORM components individually
 * for functionality that applies to only those components.
 * 
 * Add a copy of this to any application as a template for global ORM event
 * handling.
 */
 component implements="CFIDE.ORM.IEventHandler"
{
	/**
	* @hint Event handler that fires after a delete operation.
	*/
	remote void function postDelete(any entity ) 
	{
	   //Do nothing unless implemented
	}

	/**
	* @hint Event handler that fires after a insert operation.
	*/
	remote void function postInsert(any entity ) 
	{
	   //Do nothing unless implemented
	}

	/**
	* @hint Event handler that fires after a load operation.
	*/
	remote void function postLoad(any entity ) 
	{
	   //Do nothing unless implemented
    }

	/**
	* @hint Event handler that fires after a update operation.
	*/
	remote void function postUpdate(any entity ) 
	{
	   //Do nothing unless implemented
    }

	/**
	* @hint Event handler that fires before a delete operation.
	*/
	remote void function preDelete(any entity ) 
	{
	   //Do nothing unless implemented
    }

	/**
	* @hint Event handler that fires before an insert operation.
	*/
	remote void function preInsert(any entity ) 
	{
        //Do nothing unless implemented
    }

	/**
	* @hint Event handler that fires before a load operation.
	*/
	remote void function preLoad(any entity ) 
	{
	   //Do nothing unless implemented
    }

	/**
	* @hint Event handler that fires before a update operation.
	*/
	remote void function preUpdate(any entity , struct oldData ) 
	{
	   //Do nothing unless implemented
    }
}