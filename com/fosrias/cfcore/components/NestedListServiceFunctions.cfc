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
	}
	
	public any function nestedRemove(any value, boolean delete = true)
	{
        //Load the current values
	    var lft = ARGUMENTS.value.getlft();
        var rgt = ARGUMENTS.value.getrgt();
	    var range = rgt - lft;
	   
	    var hqlString = "DELETE FROM #this.getmodel()# WHERE lft BETWEEN " & 
	        "#lft# AND #rgt#";
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
	   hqlString = "UPDATE #this.getmodel()# SET rgt = rgt - #range# " & 
	       "WHERE rgt > #rgt#";
       ORMExecuteQuery(hqlString);
	   
	   hqlString = "UPDATE #this.getmodel()# SET lft = lft - #range# " & 
	       "WHERE lft > #rgt#";
       ORMExecuteQuery(hqlString);
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
		var isUpMove = ARGUMENTS.value.getlft() < lft;
		
        if (NOT ARGUMENTS.value.getlft() eq lft) 
        {
		    //Get new parent information
            hqlString = "SELECT lft, rgt FROM #this.getModel()# " &
               "WHERE id=#ARGUMENTS.value.getparentId()#";
            var result = ORMExecuteQuery(hqlString)[1];
            var newParentLft = result[1];
            var newParentRgt = result[2];
            var newParentRange = newParentLft - newParentRgt;
            
		    //Make a gap where moving to
			//First check if we are moving to parent with no children.
            if (newParentRange eq 1)
            {
                //Moving to be the first child, create the gap
                hqlString = "UPDATE #this.getmodel()# SET rgt = rgt + #range + 1# WHERE " &
                    " rgt > #newParentLft#";
                ORMExecuteQuery(hqlString);
                
                hqlString = "UPDATE #this.getmodel()# SET lft = lft + #range + 1# WHERE lft > " & 
                     "#newParentLft#";
                ORMExecuteQuery(hqlString);

            } else {
            
                //Moving as another child, create the gap
                hqlString = "UPDATE #this.getmodel()# SET rgt = rgt + #range + 1# WHERE " &
                    " rgt >=  #ARGUMENTS.value.getlft()#";
                ORMExecuteQuery(hqlString);
                
                hqlString = "UPDATE #this.getmodel()# SET lft = lft + #range + 1# WHERE " &
                     "lft >= #ARGUMENTS.value.getlft()#";
                ORMExecuteQuery(hqlString);
            } 
			
			//Find my current location
			hqlString = "SELECT lft, rgt FROM #this.getModel()# " &
                "WHERE id=#ARGUMENTS.value.getid()#";
	        result = ORMExecuteQuery(hqlString)[1];
	        var currentLft = result[1];
	        var currentRgt = result[2];
            var offset = currentLft - ARGUMENTS.value.getlft();
			
			//Move into the gap. Update location and the location of any 
			//children.
            hqlString = "UPDATE #this.getmodel()# SET lft = lft - #offset#, rgt = rgt - #offset# " &
             "WHERE lft BETWEEN  #currentLft# AND #currentRgt#";
            ORMExecuteQuery(hqlString);
			
			
			//Update to the new parent id so everything is current
		    hqlString = "UPDATE #this.getmodel()# SET parentId = #ARGUMENTS.value.getparentId()#  WHERE " &
                        " id =  #ARGUMENTS.value.getid()#";
            ORMExecuteQuery(hqlString);
			
			//Find the reference to compact the tree. If it is a down move,
			//Use the right value of the previous record.
			var reference = lft - 1;
			
			if (isUpMove)
			{
                //Find my new parents right location
	            hqlString = "SELECT rgt FROM #this.getModel()# " &
	                "WHERE id=#ARGUMENTS.value.getparentId()#";
	            reference = ORMExecuteQuery(hqlString)[1];
			}
			
			//Compact the gap
			hqlString = "UPDATE #this.getmodel()# SET rgt = rgt - #range + 1# WHERE " &
                " rgt >  #reference#";
            ORMExecuteQuery(hqlString);
            
            hqlString = "UPDATE #this.getmodel()# SET lft = lft - #range + 1# WHERE " &
                 "lft > #reference#";
            ORMExecuteQuery(hqlString);
			
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
			
			return true;	
        }
        return false;
	}
}