﻿////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * The AORMComponent is the abstract base component for ORM components.
 *
 * @see AORMApplication.cfc, ARESTfulService.cfc
 */
component
{
    include "/CFCore/com/fosrias/cfcore/components/InflectionFunctions.cfc";
    
    //--------------------------------------------------------------------------
    //
    //  Abstract Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor
	 * 
     * Making this function private effectively turns this into an 
	 * abstract component. Concrete subclasses must define a public init 
	 * constructor method that returns the component. The primary key for the 
	 * ORM component is determined from the component properties based on
     * which property(ies) is(are) specified as primary key(s) in the 
     * property definitions.
    
     * Concrete implementations of this class must call super.init(). If
     * a sortOrder parameter is provided, it will override the calculated value.
     * 
     * Calculate the primary key for the model if it is not set
     * We use the APPLICATION scope so that we can mimic class variables within
     * the context of the request.
	 *
	 * To include a simple search on the values in a table column, add a
	 * searchable="true" attribute on its associated property.
     * 
	 * APPLICATION scope is used to store primary keys and mimic class 
	 * variable functionality.since these values will never change unless 
	 * underlying table changes and the application must be restarted to 
     * update the ORM mappings in that case anyhow. No locking is used since
     * the cfc dot-delimited name must be unique and these values will be 
     * also.
	 *
	 * The default timestamp names are 'createdAt' and 'updatedAt.' Override
     * these by the name of the corresponding property in the ORM model.
     *
	 * @hint A initialization routine, runs when object is created.
     */
	private void function init(String model ="Null",
	                           String sortOrder = "Null",
                               String createdAtField = "created_at",
                               String updatedAtField = "updated_at") 
    {
	    //Get the metadata
	    var metadata = GetMetadata(this);
		
	    //See AORMApplication for APPLICATION utility methods used here.
		//The following effectively creates class variables for the 
		//primary key and sort order so they are only calculated once for
		//each component after the server is started.
		if ( NOT APPLICATION.hasORMStructures(metadata.name) )
		{   
		    var modelName = ARGUMENTS.model;
			
		    //Set model name for mapping
			if (modelName eq "Null")
			{
			    modelName = demodulize(metadata.name);	
			}
		
		    //Initialize the structures
            //Determine the primary key and its associated sortOrder
			var primaryKey = "";
			var defaultSortOrder = sortOrder;
			
			var properties = metadata.PROPERTIES;
			var property = "";
			
			for (i=1;i LTE ArrayLen(properties);i=i+1) 
			{
			    property = properties[i];
				
			    if ( structKeyExists(property, "fieldtype") AND 
				    property.fieldtype eq "id" )
				{
				    if( Len(primaryKey eq 0) )
					{
                        primaryKey = property.name;
						if (defaultSortOrder eq "Null")
						{
						    if ( structKeyExists(property, "column") )
							{
							    defaultSortOrder = "#property.column# ASC";
							} else {
							    defaultSortOrder = "#property.name# ASC";
							}
						}
					} else {
					    primaryKey = "#primaryKey#, #property.name#";
						if (NOT arguments.sortOrder eq "Null")
                        {
                            if ( structKeyExists(property, "column") )
                            {
                                defaultSortOrder = "#sortOrder#, 
								    #property.column# ASC";
                            } else {
                                defaultSortOrder = "#sortOrder#, 
								    #property.name# ASC";
                            }
                        }
					}
				}
			}
			APPLICATION.setPrimaryKey(modelName, primaryKey, metadata.name);
            APPLICATION.setSortOrder(modelName, defaultSortOrder, 
                metadata.name);
	        APPLICATION.setWhereClause(modelName, defineWhereClause(), 
                metadata.name);
		    APPLICATION.setCreatedAtField(modelName, ARGUMENTS.createdAtField, 
			    metadata.name);
			APPLICATION.setUpdatedAtField(modelName, ARGUMENTS.updatedAtField, 
			    metadata.name);
		}
    }
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/**
     * @hint Sets the createdAt value for the component if the createdAtField
	 * exists.
     */
    public function setCreatedAt(Date value)
    {
		var metaData = GetMetadata(this);
		var createdAtField = APPLICATION.findCreatedAtField(metaData.name);
		if ( structKeyExists(metaData.PROPERTYSTRUCT, createdAtField) )
        {
             VARIABLES[createdAtField] = ARGUMENTS.value;
        }
    }
    
    /**
     * @hint Sets the updatedAt value for the component if the updatedAtField
     * exists.
     */
    public function setUpdatedAt(Date value)
    {
		var metaData = GetMetadata(this);
        var updatedAtField = APPLICATION.findUpdatedAtField(metaData.name);
		if ( structKeyExists(metaData.PROPERTYSTRUCT, updatedAtField) )
        {
            VARIABLES[updatedAtField] = ARGUMENTS.value;
        }
    }
    
    /**
     * @hint Returns the primary key of the record, which may be composite.
     */
    public any function getPrimaryKey()
    {
	   var primaryKey = APPLICATION.findPrimaryKey(GetMetadata(this).name);
	   var splitIds = primaryKey.split(",");
	   try
	   {
	       //REFACTOR: Add composite primary key functionality.
           return VARIABLES[primaryKey];
	   } 
	   catch(any e) 
	   {
	       //Property does not exist, therefore it is new
		   WriteOutput("Error: " & e.message);

		   return 0;
	   }
    }

    /**
     * @hint Nullifies blank or zero id's.  Useful for dealing with objects 
     * coming back from remoting.
     */
    public void function nullifyZeroID() 
    {
        if (getPrimaryKey() eq 0 OR getPrimaryKey() eq "")
        {
            //REFACTOR: Add composite primary key functionality.
            var primaryKey = APPLICATION.findPrimaryKey(GetMetadata(this).name);
	    	var splitIds = primaryKey.split(",");
	   
    		//REFACTOR: Add composite primary key functionality.
        	VARIABLES[primaryKey] = JavaCast("Null", "");	
        }
    }
	
	//--------------------------------------------------------------------------
    //
    //  Callback Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Event handler that fires after a delete operation.
     */
    remote void function postDelete(any entity) 
	{
	
    }

    /**
     * @hint Event handler that fires after a insert operation.
     */
    remote void function postInsert(any entity) 
	{
	
    }

    /**
     * @hint Event handler that fires after a load operation.
     */
    remote void function postLoad(any entity) 
	{
	
    }

    /**
     * @hint Event handler that fires after a update operation.
     */
    remote void function postUpdate(any entity) 
	{
	
    }

    /**
     * @hint Event handler that fires before a delete operation.
     */
    remote void function preDelete(any entity) 
	{
	
    }

    /**
    * @hint Event handler that fires before an insert operation. Ensures magic 
	* words get populated.
    */
    remote void function preInsert(any entity) 
	{
		this.nullifyZeroID();
        this.setCreatedAt( now() );
		this.setUpdatedAt( now() );
    }

    /**
    * @hint Event handler that fires before a load operation.
    */
    remote void function preLoad(any entity) 
	{
	
    }

    /**
     * @hint Event handler that fires before a update operation. Ensures magic 
	 * words get populated.
     */
    remote void function preUpdate(any entity , struct oldData ) 
	{
		//Check if new record. Only existing records should be updated.
        if (this.getPrimaryKey() eq 0 OR this.getPrimaryKey() eq "")
        {
            throw (type="Update Method Error", 
                   message="Update method called on "
                   + "new #GetMetadata(this).name#.");
        }
	   this.setUpdatedAt( now() );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * Provides simple non-indexed search where clause for all ORM properties 
	 * defined as searchable.
	 *
	 * @hint Abstract function that builds a where clause from the models
     */
    private String function defineWhereClause()
	{
	    var properties = GetMetadata(this).PROPERTIES;
	    var whereClause = "";
	    var property = "";
	    var columnName = "";
	           
	    for (i=1;i LTE ArrayLen(properties);i=i+1) 
        {
            property = properties[i];
			if ( structKeyExists(property, "column") )
            {
                columnName = property.column;
				
            } else {
                columnName = property.name;
            }
			
			//Only columns with the attribute searcheable defined as true
			//are used.
			if ( structKeyExists(property, "searchable") AND 
			     property.searchable )
			{
                whereClause = ListAppend(whereClause, 
                " #columnName# LIKE '%queryDef%'", "|");
			} 
	    }
	   
	    whereClause = Replace(whereClause, "|", " OR ", "all");
        
		return whereClause;
	}
}