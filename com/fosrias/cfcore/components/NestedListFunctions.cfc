/*
 * The following methods are used to insert, delete and move AORMComponents that
 * have a lft and rgt column for managing nested lists. The assumption is that
 * the updated lft and rght columns have been set on the client correctly,
 * so all we are doing here is saving them in the correct location.
 */
component hint="Functions for managing nested lists."
{
    public any function nestedInsert()
	{
	
	throw(message="#this.findmodel()#")
            
	   //Shift everything right
		var hqlString = "UPDATE #this.findmodel()# SET rgt = rgt + 2 WHERE " &
		    " rgt >  #this.getrgt()#";
		ORMExecuteQuery(hqlString);
		
	    hld = "UPDATE #this.findmodel()# SET lft = lft + 2 WHERE lft > " & 
		     "#this.getrgt()#";
        ORMExecuteQuery(hqlString);
	    
		//Save in new location. Assumes lft and rgt correctly set in the client
        //Force an insert using true. Causes preInsert callback to fire.
        EntitySave(this, true);
	}
	
	public any function nestedRemove(boolean delete = true)
	{
	   //Load the current values
	   var lft = value.getlft();
       var rgt = value.getrgt();
	   var range = rgt - lft;
	   
	   var hqlString = "DELETE FROM #this.findModel()# WHERE lft BETWEEN " & 
	       "#lft# AND #rgt#";
	   if (delete)
	   {
	       ORMExecuteQuery(hld);
	   } else {
	       //Clear the nesting. We save the record, but remove it from the tree.
	       value.setlft(-1);
	       value.setrgt(-1);
	       EntitySave(value);
	   }
	   
	   
	   //Shift all remaining records left
	   hqlString = "UPDATE #this.findModel()# SET rgt = rgt - #range# " & 
	       "WHERE rgt > #rgt#";
       ORMExecuteQuery(hqlString);
	   
	   hqlString = "UPDATE #this.findModel()# SET lft = lft - #range# " & 
	       "WHERE lft > #rgt#";
       ORMExecuteQuery(hqlString);
	}
	
	public any function nestedMove()
	{
	   var current = EntityLoad( this.getmodel(),  this.getid() );
	   
	   if (NOT this.getlft() eq current.getlft() OR NOT 
	       this.getrgt() eq current.getrgt()) 
	   {
	       //Remove it from its current position
           this.nestedRemove();
           
           //Reinsert it in its new position.
           this.nestedInsert();
		   return true;
	   }
	   return false;
	}
}