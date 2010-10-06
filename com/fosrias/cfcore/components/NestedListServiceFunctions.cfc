/*
 * The following methods are used to insert, delete and move AORMComponents that
 * have a lft and rgt column for managing nested lists. The assumption is that
 * the updated lft and rght columns have been set on the client correctly,
 * so all we are doing here is saving them in the correct location.
 */
component hint="Functions for managing nested lists."
{
    public any function nestedInsert(any value)
	{  
		//Get the parent right value
		var hqlString = "SELECT lft, rgt FROM #this.getModel()# " &
		   "WHERE id=#ARGUMENTS.value.getparentId()#";
		var result = ORMExecuteQuery(hqlString)[1];
		var parentLft = result[1];
		var parentRgt = result[2];
		var range = parentRgt - parentLft;

	    var hqlString = "";
		
		var query = new Query();
        query.setdataSource("ContentManager"); 
        query.setsql("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE"); 
        query.execute();
        query.setsql("BEGIN TRANSACTION"); 
        query.execute();
        
        try
        {
		
	        if (range eq 1)
		    {
				//Adding the first child
				hqlString = "UPDATE #this.getmodel()# SET rgt = rgt + 2 WHERE " &
				    " rgt >  #parentLft#";
				ORMExecuteQuery(hqlString);
				
				hqlString = "UPDATE #this.getmodel()# SET lft = lft + 2 WHERE lft > " & 
				     "#parentLft#";
				ORMExecuteQuery(hqlString);
				
	        } else {
		        //Adding another child
				//Shift everything right by 2
				hqlString = "UPDATE #this.getmodel()# SET rgt = rgt + 2 WHERE " &
				    " rgt >=  #ARGUMENTS.value.getlft()#";
				ORMExecuteQuery(hqlString);
				
				hqlString = "UPDATE #this.getmodel()# SET lft = lft + 2 WHERE " &
				     "lft >= #ARGUMENTS.value.getlft()#";
				ORMExecuteQuery(hqlString);
	        } 
		    
			//Save in new location. Assumes lft and rgt correctly set in the client
	        //Force an insert using true. Causes preInsert callback to fire.
	        EntitySave(ARGUMENTS.value, true);
			query.setsql("COMMIT TRANSACTION");
	        query.execute();
        
        } catch (any error) {
            query.setsql("ROLLBACK TRANSACTION");
            query.execute();
            rethrow;
        }
	}
	
	public any function nestedRemove(any value, boolean delete = true)
	{
        //Load the current values
	    var lft = ARGUMENTS.value.getlft();
        var rgt = ARGUMENTS.value.getrgt();
	    var range = rgt - lft;
	   
	    var hqlString = "DELETE FROM #this.getmodel()# WHERE lft BETWEEN " & 
	        "#lft# AND #rgt#";
			
        //Lock the tables
		var query = new Query();
		query.setdataSource("ContentManager"); 
		query.setsql("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE"); 
		query.execute();
		query.setsql("BEGIN TRANSACTION"); 
		query.execute();
		
		try
		{	
		    if (delete)
		    {
		        ORMExecuteQuery(hqlString);
		    } else {
			
			     //Clear the nesting. We save the record, but remove it from 
				//the tree.
		        hqlString = "UPDATE #this.getmodel()# SET lft = -1, rgt = -1 " &
				     "WHERE lft BETWEEN  #lft# AND #rgt#";
		        ORMExecuteQuery(hqlString);
		    }
		   
		   //Shift all remaining records left
		   hqlString = "UPDATE #this.getmodel()# SET rgt = rgt - #range + 1# " & 
		       "WHERE rgt > #rgt#";
	       ORMExecuteQuery(hqlString);
		   
		   hqlString = "UPDATE #this.getmodel()# SET lft = lft - #range + 1# " & 
		       "WHERE lft > #rgt#";
	       ORMExecuteQuery(hqlString);
		   
		   query.setsql("COMMIT TRANSACTION");
           query.execute();
        
        } catch (any error) {
            query.setsql("ROLLBACK TRANSACTION");
            query.execute();
            rethrow;
        }
	}
	
	public any function nestedMove(any value)
	{
		//Load the current persistent location of the record
		var hqlString = "SELECT lft, rgt FROM #this.getModel()# " &
		   "WHERE id=#ARGUMENTS.value.getid()#";
		var result = ORMExecuteQuery(hqlString)[1];
		var lft = result[1];
		var rgt = result[2];
		var range = rgt - lft;
		
        if (NOT ARGUMENTS.value.getlft() eq lft) 
        {
		    //Lock the tables
			var query = new Query();
			query.setdataSource("ContentManager"); 
            query.setsql("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE"); 
            query.execute();
			query.setsql("BEGIN TRANSACTION"); 
            query.execute();
            
		    try
			{
			    //Copy the entire tree into the move buffer
				hqlString = "DELETE FROM SiteItemBuffer";
				ORMExecuteQuery(hqlString);
	            
				hqlString = "INSERT INTO SiteItemBuffer (id, lft , rgt) SELECT " &
	                "id, lft, rgt FROM #this.getmodel()# WHERE lft > 0 " & 
					"ORDER BY lft";
				ORMExecuteQuery(hqlString);
				
	            //Delete item and its children from buffer at its current location
		        hqlString = "DELETE FROM SiteItemBuffer WHERE lft BETWEEN " & 
		            "#lft# AND #rgt#";
	            ORMExecuteQuery(hqlString);
	       
				hqlString = "UPDATE SiteItemBuffer SET rgt = rgt - #range + 1# " & 
				   "WHERE rgt > #rgt#";
				ORMExecuteQuery(hqlString);
				
				hqlString = "UPDATE SiteItemBuffer SET lft = lft - #range + 1# " & 
				   "WHERE lft > #rgt#";
				ORMExecuteQuery(hqlString);
				
				//Make a gap to move into
	            var reference = "";
	            hqlString = "SELECT (lft - rgt) FROM #this.getModel()# " &
	               "WHERE id=#ARGUMENTS.value.getparentId()#";
	            
				//Check if the new parent has children
				if (ORMExecuteQuery(hqlString)[1] eq 1)
	            {
	                //Moving to be the first child
					reference = newParentLft + 1;
	
	            } else {
				
	                //Moving as another child
					reference = ARGUMENTS.value.getlft();
					
					//If moving down, adjust the reference by the range of 
					//item being removed above it
					if ( lft < value.getlft() )
					{
					   reference -= range + 1;
					}
	            } 
				
			    //Create the gap
	            hqlString = "UPDATE SiteItemBuffer SET rgt = rgt + " & 
	                "#range + 1# WHERE rgt >= #reference#";
	            ORMExecuteQuery(hqlString);
	            
	            hqlString = "UPDATE SiteItemBuffer SET lft = lft + " & 
	                "#range + 1# WHERE lft >= #reference#";
	            ORMExecuteQuery(hqlString);
				
				var offset = lft - reference;
				
				//Insert into the gap location
				hqlString = "INSERT INTO SiteItemBuffer (id, lft, rgt) SELECT " &
	                "id, lft  - #offset# , rgt - #offset# FROM #this.getmodel()# " & 
					"WHERE lft BETWEEN #lft# and #rgt# ORDER BY lft";
	            ORMExecuteQuery(hqlString);
				
				ORMFlush();
				
				//Update the whole tree with the new left and right values
				var table = GetMetadata(this).table;
	            sqlString = "UPDATE #table# SET #table#.lft = " & 
				    "site_items_buffer.lft, #table#.rgt = site_items_buffer.rgt " & 
					"FROM site_items_buffer WHERE #table#.id = " & 
					"site_items_buffer.id";
	            
				query.setsql(sqlString); 
				query.execute();
				
            
	            //Update the values so that discrepancies from the client are
				//not saved since the move is accurate here.
				hqlString = "SELECT lft, rgt FROM #this.getModel()# " &
	                "WHERE id=#ARGUMENTS.value.getid()#";
	            result = ORMExecuteQuery(hqlString)[1];
	            ARGUMENTS.value.setlft( result[1] );
	            ARGUMENTS.value.setrgt( result[2] );
				
				//So that any other changes to me are updated at the same time.
				//Don't force an insert. Causes preUpdate callback to fire.
				//We can only move existing items.
				EntitySave(ARGUMENTS.value);
				
			    query.setsql("COMMIT TRANSACTION");
                query.execute();
            
            } catch (any error) {
                query.setsql("ROLLBACK TRANSACTION");
                query.execute();
                rethrow;
            }
			return true;	
        }
        return false;
	}
}