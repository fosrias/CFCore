////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010   Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * The ARESTfulService component is the abstract base class for all RESTful 
 * service components. It also includes some non-RESTful methods that support
 * page indexing and searches.
 *
 * The default naming convention for the components is:
 *
 * table:   my_models (with field names 'my_field')
 * model:   MyModel.cfc (which must be unique, application wide)
 * service: MyModelsService.cfc
 *
 * The default primary key of the model is assumed to be the field 'id'. This
 * service is intended for use with applications that extend the 
 * compoent AORMApplication.cfc and ORM components that extend the 
 * AORMComponent.cfc.
 * 
 * Note: Query statements reference the MyModel name, not the my_models 
 * table name.
 * 
 * @see AService, AORMApplication.cfc, AORMComponent.cfc
 */
component extends="CFCore.com.fosrias.cfcore.interfaces.AService"
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
	 * @comment Private ensures the component is abstract and is not 
	 * instantiated. 
	 *
	 * Concrete implementations of this component must call super.init() as the 
	 * first line in their init method with the table name as a parameter.
	 *
	 * @hint A initialization routine, runs when object is created.
	 */
	private void function init()
	{
	    super.init();
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/*
     * @hint Abstract method for retrieving the model name associated with
     * the service.
     */
    public string function getSortOrder()
    {
       return "id ASC"; //APPLICATION.findSortOrder( this.getModel() );
    }

    //--------------------------------------------------------------------------
    //
    //  Abstract methods
    //
    //--------------------------------------------------------------------------
    
	/*
	 * @hint Abstract method for retrieving the model name associated with
	 * the service.
	 */
    public string function getModel()
	{
       throw(type="Implementation Error" message="The method getModel is not implemented in #GetMetadata(this).name#.")
	}
	
    //--------------------------------------------------------------------------
    //
    //  Remote methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Returns the count of records in the underlying table.
     */
    remote numeric function count() 
    {
        return ormExecuteQuery("SELECT COUNT(*) FROM #this.getModel()#")[1];
    }

    /**
     * @hint Updates one record from the underlying table.
     */
    remote void function create(required any value) 
    {
        ARGUMENTS.value.nullifyZeroID();
        EntitySave(ARGUMENTS.value);
    }
    
    /**
     * @hint Deletes one record from the underlying table.
     */
    remote void function destroy(required any value) 
    {
        EntityDelete(ARGUMENTS.value);
    }
    
    /**
	 * @hint Returns all of the records in the underlying table.
	 */
	remote any function index()
	{
		return callResult( entityLoad( this.getModel(), {}, 
		    this.getSortOrder() ) );
	}

	/**
     * @hint Returns all of the records in the underlying table, with paging.
     */
    remote Array function indexPaged(numeric offset ="0",
                                     numeric maxRresults ="0", 
                                     string orderBy ="Null") 
    {
        var loadArgs = {};
		var orderByClause = ARGUMENTS.orderBy;
		
		if (ARGUMENTS.offset neq 0)
        {
            loadArgs.offset = ARGUMENTS.offset;
        }
        if (ARGUMENTS.maxRresults neq 0)
        {
            loadArgs.maxRresults = ARGUMENTS.maxRresults;
        }
		if (orderByClause eq "Null")
        {
            orderByClause = this.getSortOrder();
        }
        
        return entityLoad(this.getModel(), {}, orderByClause, loadArgs);
    }

    /**
     * @hint Performs search against the underlying table.
     */
    remote Array function search(string query) 
    {
		var hqlString = "FROM #this.getModel()#";
		var whereClause = "";
		var orderByClause = this.getSortOrder();
		
		if (Len(arguments.q) gt 0)
		{
		    whereClause = buildWhereClause(this.getModel(), query);
		}
		if (Len(whereClause) gt 0)
		{
		    hqlString = hqlString & " WHERE " & whereClause;
		}
		if (Len(orderByClause) gt 0)
        {
		    hqlString = hqlString & " ORDER BY #orderByClause#";	
		}   
			   
        return ormExecuteQuery(hqlString, false, {});
    }

    /**
     * @hint Determines total number of results of search for paging purposes.
     */
    remote numeric function searchCount(string query) 
    {
	    var hqlString = "SELECT count(*) FROM #this.getModel()#";
        var whereClause = "";
        
        if (Len(ARGUMENTS.query) gt 0)
        {
            whereClause = buildWhereClause( this.getModel(), 
			    ARGUMENTS.query);
        }
        if (Len(whereClause) gt 0)
        {
            hqlString = hqlString & " WHERE " & whereClause;
        }
		return ormExecuteQuery(hqlString, false, {})[1];
    }
    
    /**
	 *  @hint Performs search against the underlying table, with paging.
     */
    remote Array function searchPaged(string query, 
                                      numeric offset ="0", 
                                      numeric maxresults ="0", 
                                      string orderby ="Null")
    {	
	    //Note: Query calls are against the model, not the table name
		var hqlString = "FROM #this.getModel()#";
        var whereClause = "";
		var orderByClause = "";
        var params = {};
		
        if (ARGUMENTS.offset neq 0)
		{
            params.offset = arguments.offset;
        }
        if (ARGUMENTS.maxresults neq 0)
		{
            params.maxresults = arguments.maxresults;
        }
        if (Len(ARGUMENTS.query) gt 0)
		{
            whereClause = buildWhereClause( this.getModel(), ARGUMENTS.query);
        }
        if (Len(whereClause) gt 0)
		{
            hqlString = hqlString & " WHERE " & whereClause;
        }
	    if (ARGUMENTS.orderby eq "Null")
        {
            orderByClause = this.getSortOrder();
        }	
        if (Len(orderByClause) gt 0)
        {
            hqlString = hqlString & " ORDER BY #orderByClause#";   
        }   
                  
	    return ormExecuteQuery(hqlString, false, params);
    }

    /**
     * @hint Returns one record from the underlying table.
     */
    remote any function show(required string id) 
    {
        return EntityLoad(this.getModel(), ARGUMENTS.id, true);
    }

    /**
     * @hint Updates one record from the underlying table.
     */
    remote void function update(required any value)
    {
	    //Check if new record. Only existing records should be updated.
        if (ARGUMENTS.value.getId() eq 0 OR ARGUMENTS.value.getId() eq "")
        {
            throw (type="Update Method Error", 
			       message="#GetMetadata(this).name# update method called on "
				   + "new #GetMetadata(value).name#.");
        }
        EntitySave(ARGUMENTS.value);
    }
	
	/**
     * @hint Adds a where clause to a query.
     */
    private string function buildWhereClause(String type, String query)
	{
	    return APPLICATION.buildWhereClause(arguments.type, arguments.query);
	}
}