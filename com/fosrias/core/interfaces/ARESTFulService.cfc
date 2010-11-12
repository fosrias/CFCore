<!---
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
 * Role based security is implemented on create, destroy and update as a 
 * default. Thus, those methods are tag based.
 * 
 * Note: ORM queries reference the MyModel name, not the my_models 
 * table name. The opposite is true of Query objects.
 * 
 * @see AService, AORMApplication.cfc, AORMComponent.cfc
 */
--->
<cfcomponent extends="CFCore.com.fosrias.core.interfaces.AService">
<cfscript>

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
	 * first line in their init method with the model name as an optional
	 * parameter to override the default naming scheme.
	 *
	 * @hint A initialization routine, runs when object is created.
	 */
	private void function init(string model = "Null")
	{
	    super.init(model);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Remote script methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Returns the count of records in the underlying table.
     */
    remote any function count() 
    {
        return callResult( 
		    ormExecuteQuery("SELECT COUNT(*) FROM #this.getmodel()#")[1] );
    }

    /**
	 * @hint Returns all of the records in the underlying table.
	 */
	remote any function index()
	{
		return callResult( entityLoad( this.getmodel(), {}, 
		    this.getsortOrder() ) );
	}

	/**
     * @hint Returns all of the records in the underlying table, with paging.
     */
    remote any function indexPaged(numeric offset ="0",
                                   numeric maxResults ="0", 
                                   string orderBy ="Null") 
    {
        var params = {};
		var orderByClause = ARGUMENTS.orderBy;
		
		if (ARGUMENTS.offset neq 0)
        {
            params.offset = ARGUMENTS.offset;
        }
        if (ARGUMENTS.maxResults neq 0)
        {
            params.maxResults = ARGUMENTS.maxResults;
        }
		if (orderByClause eq "Null")
        {
            orderByClause = this.getsortOrder();
        }
        
        return callResult( entityLoad(this.getmodel(), {}, orderByClause, 
		    params) );
    }

    /**
     * @hint Performs search against the underlying table.
     */
    remote any function search(string query,
	                           boolean queryIsWhere = false) 
    {
		var hqlString = "FROM #this.getmodel()#";
		var whereClause = "";
		var orderByClause = this.getsortOrder();
		
		if (Len(ARGUMENTS.query) gt 0)
		{
		    whereClause = buildWhereClause(ARGUMENTS.query, 
			    ARGUMENTS.queryIsWhere);
		}
		if (Len(whereClause) gt 0)
		{
		    hqlString = hqlString & " WHERE " & whereClause;
		}
		if (Len(orderByClause) gt 0)
        {
		    hqlString = hqlString & " ORDER BY #orderByClause#";	
		}   
			   
        return callResult( ormExecuteQuery(hqlString, false, {}) );
    }

    /**
     * @hint Determines total number of results of search for paging purposes.
     */
    remote any  function searchCount(string query,
	                                 boolean queryIsWhere = false) 
    {
	    var hqlString = "SELECT COUNT(*) FROM #this.getmodel()#";
        var whereClause = "";
        
        if (Len(ARGUMENTS.query) gt 0)
        {
            whereClause = buildWhereClause(ARGUMENTS.query, 
                ARGUMENTS.queryIsWhere);
        }
        if (Len(whereClause) gt 0)
        {
            hqlString = hqlString & " WHERE " & whereClause;
        }
		return callResult(  ormExecuteQuery(hqlString, false, {})[1] );
    }
    
    /**
	 *  @hint Performs search against the underlying table, with paging.
     */
    remote any function searchPaged(string query, 
                                    numeric offset ="0", 
                                    numeric maxResults ="0",
									string orderBy ="Null",
                                    boolean queryIsWhere = false)
    {	
	    //Note: Query calls are against the model, not the table name
		var hqlString = "FROM #this.getmodel()#";
        var whereClause = "";
		var orderByClause = "";
        var params = {};
		
        if (ARGUMENTS.offset neq 0)
		{
            params.offset = arguments.offset;
        }
        if (ARGUMENTS.maxResults neq 0)
		{
            params.maxResults = arguments.maxResults;
        }
        if (Len(ARGUMENTS.query) gt 0)
		{
            whereClause = buildWhereClause(ARGUMENTS.query, 
                ARGUMENTS.queryIsWhere);
        }
        if (Len(whereClause) gt 0)
		{
            hqlString = hqlString & " WHERE " & whereClause;
        }
	    if (ARGUMENTS.orderBy eq "Null")
        {
            orderByClause = this.getsortOrder();
        } else {
		
		    orderByClause = ARGUMENTS.orderBy;
		}
        if (Len(orderByClause) gt 0)
        {
            hqlString = hqlString & " ORDER BY #orderByClause#";   
        }   
                  
	    return callResult(  ormExecuteQuery(hqlString, false, params) );
    }

    /**
     * @hint Returns one record from the underlying table.
     */
    remote any function show(required String id) 
    {
        //REFACTOR for composite primary keys
		return callResult(  EntityLoad(this.getmodel(), ARGUMENTS.id, true) );
    }
	
	//--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @hint Adds a where clause to a query.
     */
    private string function buildWhereClause(String query,
                                             boolean queryIsWhere)
	{
	    if (queryIsWhere)
		{
            return query;
			
		} else {
		
		    return APPLICATION.buildWhereClause(this.getmodel(), 
			    arguments.query);
		}
	    
	}
</cfscript>
<cffunction name="create" access="remote" roles="super,admin,content" 
            hint="Creates one record in the underlying table">
	<cfargument name="value" required="true" type="any">
		<cfscript>
			//Force an insert. Causes preInsert callback to fire.
			EntitySave(ARGUMENTS.value, true);
			
			return callResult(ARGUMENTS.value);
		</cfscript>
</cffunction>
<cffunction name="destroy" access="remote" roles="super,admin" 
            hint="Deletes one record from the underlying table">
    <cfargument name="value" required="true" type="any">
        <cfscript>
            EntityDelete(ARGUMENTS.value);
        </cfscript>
</cffunction>
<cffunction name="update" access="remote" roles="super,admin,content" 
            hint="Updates one record from the underlying table">
    <cfargument name="value" required="true" type="any">
        <cfscript>
            EntitySave(ARGUMENTS.value);
            
            return callResult(ARGUMENTS.value);
        </cfscript>
</cffunction>
</cfcomponent>