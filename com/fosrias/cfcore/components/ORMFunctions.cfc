////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster   www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * @hint ORM utility functions for use as component mixins.
 */
component
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/**
     * Calling this function will clear ORM values if this component
     * is modified, without restarting the server.
     *
     * @hint Clears application wide ORM structures functionality.
     */
    public void function clearORMStructures()
    {
        StructDelete(APPLICATION, "modelNames");
		StructDelete(APPLICATION, "primaryKeys");
        StructDelete(APPLICATION, "serviceModelNames");
        StructDelete(APPLICATION, "sortOrders");
        StructDelete(APPLICATION, "whereClauses");
        
        StructDelete(APPLICATION, "hasORMStructures");
		
        StructDelete(APPLICATION, "findModelName");
        StructDelete(APPLICATION, "findPrimaryKey");
        StructDelete(APPLICATION, "findServiceModelName");
        StructDelete(APPLICATION, "findSortOrder");
		StructDelete(APPLICATION, "findWhereClause");
		
        StructDelete(APPLICATION, "setModelName");
        StructDelete(APPLICATION, "setPrimaryKey");
        StructDelete(APPLICATION, "setServiceModelName");
        StructDelete(APPLICATION, "setSortOrder");
        StructDelete(APPLICATION, "setWhereClause");
    }
    
    /* 
	 * Calling this function will force a rebuild of ORM functionality values 
	 * if this component is modified, without restarting the server.
     *
     * @hint Initializes application-wide ORM structures and functionality.
     */
    public void function initORMStructures()
	{
	    clearORMStructures();
		
        APPLICATION.modelNames = {};
        APPLICATION.serviceModelNames = {};
        APPLICATION.primaryKeys = {};
        APPLICATION.sortOrders = {};
		APPLICATION.whereClauses = {};

        APPLICATION.hasORMStructures = hasORMStructures;
        
		APPLICATION.buildWhereClause = buildWhereClause;
        
		APPLICATION.findModelName = findModelName;
        APPLICATION.findPrimaryKey = findPrimaryKey;
        APPLICATION.findServiceModelName = findServiceModelName;
        APPLICATION.findSortOrder = findSortOrder;
		
		APPLICATION.setModelName = setModelName;
        APPLICATION.setPrimaryKey = setPrimaryKey;
        APPLICATION.setServiceModelName = setServiceModelName;
        APPLICATION.setSortOrder = setSortOrder;
		APPLICATION.setWhereClause = setWhereClause;
		
		//Build all ORM models once to initialize them vs. doing it when
		//first called by crawling through the tree and initializing them
		//by creating a new instance of each model in onApplicationStartup.
	}
	
	/*
     * @hint Determines whether a primary key is set for the ORM component type.
     */
    public boolean function isInitialized()
    {
        return isDefined("APPLICATION") AND 
		    structKeyExists(APPLICATION, "isInitialized");
    }
    
    /* 
     * @hint Sets the application as initialized for ORM functionality. This
	 * method must be called at the end of the onApplicationStart after 
	 * models have been created.
     */
    public function setORMInitialized()
	{
        APPLICATION.isInitialized = Now().toString();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /*
     * @hint Determines whether a primary key is set for the ORM component type.
     */
    private boolean function hasORMStructures(String type)
    {
        return structKeyExists(APPLICATION.primaryKeys, type);
    }
    
    /*
     * @hint Finds model name for a ORM component type.
     */
    private String function findModelName(String type)
    {
        return APPLICATION.modelNames[type];
    }
    
    /*
     * @hint Sets the model name mapping for a ORM component type.
     */
    private boolean function setModelName(String key, 
                                          String value)
    {
        //We only can set the primary key once
        if ( NOT APPLICATION.hasORMStructures(key) )
        {
            APPLICATION.modelNames[key] = value;
            return true;
        } else {
            
            throw(type="Model name Error", 
                message="Model name for #key# is already set.");
            return false;
        }
    }
    
    /*
     * @hint Finds primary key for a ORM component type.
     */
    private String function findPrimaryKey(String type)
    {
        return APPLICATION.primaryKeys[type];
    }
    
    /*
     * @hint Sets the primary key mapping for a ORM component type.
     */
    private boolean function setPrimaryKey(String key, 
                                           String value, 
                                           String packageKey = "Null")
    {
        //We only can set the primary key once
        if ( NOT APPLICATION.hasORMStructures(key) )
        {
            APPLICATION.primaryKeys[key] = value;
            
            //Allows for mapping by ORM component name and package name.
            if (NOT packageKey eq "Null")
            {
                APPLICATION.primaryKeys[packageKey] = value;
            }
            return true;
        } else {
            
            throw(type="Primary Key Error", 
                message="Primary key for #key# is already set.");
            return false;
        }
    }
    
    /*
     * @hint Finds model name for a ORM component type.
     */
    private String function findServiceModelName(String type)
    {
        return APPLICATION.serviceModelNames[type];
    }
    
    /*
     * @hint Sets the model name mapping for a ORM component type.
     */
    private boolean function setServiceModelName(String key, 
                                                 String value)
    {
        //We only can set the service model name
        if ( NOT structKeyExists(APPLICATION.serviceModelNames, key) )
        {
            APPLICATION.serviceModelNames[key] = value;
            return true;
        } else {
            
            throw(type="Model name Error", 
                message="Service model name for #key# is already set.");
            return false;
        }
    }
    
    /*
     * @hint Finds sort order for a ORM component type.
     */
    private String function findSortOrder(String type)
    {
        return APPLICATION.sortOrders[type];
    }

    /*
     * @hint Sets the sort order mapping for a ORM component type.
     */
    private boolean function setSortOrder(String key, 
                                          String value, 
                                          String packageKey = "Null")
    {
        //We only can set the sort order once
        if ( NOT structKeyExists(APPLICATION.sortOrders, key) )
        {
            APPLICATION.sortOrders[key] = value;
			
            //Allows for mapping by ORM component name and package name.
            if (NOT packageKey eq "Null")
            {
                APPLICATION.sortOrders[packageKey] = value;
            }
            return true;
        } else {
            
            throw(type="Sort Order Error", 
                message="Sort Order for #key# is already set.");
            return false;
        }
    }
	
	/*
     * @hint Finds sort order for a ORM component type.
     */
    private String function buildWhereClause(String type, String query)
    {
        return REReplace(APPLICATION.whereClauses[ARGUMENTS.type], 'queryDef', 
            ARGUMENTS.query, 'all');
    }

    /*
     * @hint Sets the sort order mapping for a ORM component type.
     */
    private boolean function setWhereClause(String key, 
                                            String value, 
                                            String packageKey = "Null")
    {
        //We only can set the sort order once
        if ( NOT structKeyExists(APPLICATION.whereClauses, key) )
        {
            APPLICATION.whereClauses[key] = value;
            
            //Allows for mapping by ORM component name and package name.
            if (NOT packageKey eq "Null")
            {
                APPLICATION.whereClauses[packageKey] = value;
            }
            return true;
        } else {
            
            throw(type="Where Clause Error", 
                message="Where Clause for #key# is already set.");
            return false;
        }
    }				 
}