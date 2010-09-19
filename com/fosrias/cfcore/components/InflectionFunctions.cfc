////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (c) 2010    Mark W. Foster    www.fosrias.com
//  All Rights Reserved.
//
//  NOTICE: Mark W. Foster permits you to use, modify, and distribute this file
//  in accordance with the terms of the MIT license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * @hint Inflection functions for use as component mixins.
 */
component
{
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/**
     * Calling this function will clear inflection values if this component
     * is modified, without restarting the server.
     *
     * @hint Clears application wide inflection functionality.
     */
    public void function clearInflections()
	{
	    StructDelete(APPLICATION, "singularInflections");
        StructDelete(APPLICATION, "pluralInflections");
        StructDelete(APPLICATION, "uncountableInflections");
        
        StructDelete(APPLICATION, "isUncountableInflection");
        StructDelete(APPLICATION, "inflectSingular");
        StructDelete(APPLICATION, "inflectPlural");
	}
	
    /**
     * Calling this function will reset inflection values if this component
	 * is modified, without restarting the server.
	 *
	 * @hint Initializes application wide inflection functionality.
     */
    public void function initInflection()
	{
        clearInflections();
		
		APPLICATION.singularInflections = getSingularInflections();
        APPLICATION.pluralInflections = getPluralInflections();
        APPLICATION.uncountableInflections = getUncountableInflections();
		
        APPLICATION.isUncountableInflection = isUncountableInflection;
		APPLICATION.inflectSingular = inflectSingular;
        APPLICATION.inflectPlural = inflectPlural;
        
	}
	
	/**
     * @hint Returns the component name.
     */
    public function demodulize(String value)
	{
        return REReplace(value, '^.*\.', '');
	}
	
	/**
     * @hint Singularizes a name.
     */
    public String function pluralize(String value)
    {
        if ( APPLICATION.isUncountableInflection(value) )
        {
            return value;
        } 
        
        return APPLICATION.inflectPlural(value);
    }	
	
	/**
     * @hint Singularizes a name.
     */
    public String function singularize(String value)
    {
        if ( APPLICATION.isUncountableInflection(value) )
		{
            return value;
		} 
		
		return APPLICATION.inflectSingular(value);
    }	
	
	/**
     * @hint Underscores a camelCase name (makes snake case).
     */
    public String function underscore(String value)
    {
	     var underscored = REReplace(value, '([A-Z]+)([A-Z][a-z])', '$1_$2', 'all');
		 underscored = REReplace(underscored, '([a-z\d])([A-Z])', '$1_$2', 'all');
		 return LCase(underscored.replace('-', '_') );
    }   
	
	//--------------------------------------------------------------------------
    //
    //  Private methods
    //
    //--------------------------------------------------------------------------
    
	/**
     * @hint Returns an array of irregular regular expression replacement 
     * strings to pluralize or singularize a string.
     */
    private Array function getIrregularInflections()
    {
        return [ ['person', 'people'],
                 ['man', 'men'],
                 ['child', 'children'],
                 ['sex', 'sexes'],
                 ['move', 'moves'],
                 ['cow', 'kine'] ];
	}
	
	/**
     * @hint Returns an array of plural regular expression replacement 
     * strings to pluralize a string.
     */
    private Array function getPluralInflections()
    {
	   var result =  [ ['$', 's'], 
		             ['s$', 's'],
	                 ['(ax|test)is$', '$1es'],
	                 ['(octop|vir)us$', '$1i'],
	                 ['(alias|status)$', '$1es'],
	                 ['(bu)s$', '$1ses'],
	                 ['(buffal|tomat)o$', '$1oes'],
	                 ['([ti])um$', '$1a'],
	                 ['sis$', 'ses'],
	                 ['(?:([^f])fe|([lr])f)$', '$1$2ves'],
	                 ['(hive)$', '$1s'],
	                 ['([^aeiouy]|qu)y$', '$1ies'],
	                 ['(x|ch|ss|sh)$', '$1es'],
	                 ['(matr|vert|ind)(?:ix|ex)$', '$1ices'],
	                 ['([m|l])ouse$', '$1ice'],
	                 ['^(ox)$', '$1en'],
	                 ['(quiz)$', '$1zes'] ];
				 
        result.addAll( getIrregularInflections() );
        return result;
	}
	
	/**
     * @hint Returns an array of singular regular expression replacement 
     * strings to singularize a string.
     */
    private Array function getSingularInflections()
    {
        var result = [ ['s$', ''],
			         ['(n)ews$', '$1ews'],
	                 ['([ti])a$', '$1um'],
	                 ['((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$', 
	                    '$1$2sis'],
	                 ['(^analy)ses$', '$1sis'],
	                 ['([^f])ves$', '$1fe'],
	                 ['(hive)s$', '$1'],
	                 ['(tive)s$', '$1'],
	                 ['([lr])ves$', '$1f'],
	                 ['([^aeiouy]|qu)ies$', '$1y'],
	                 ['(s)eries$', '$1eries'],
	                 ['(m)ovies$', '$1ovie'],
	                 ['(x|ch|ss|sh)es$', '$1'],
	                 ['([m|l])ice$', '$1ouse'],
	                 ['(bus)es$', '$1'],
	                 ['(o)es$', '$1'],
	                 ['(shoe)s$', '$1'],
	                 ['(cris|ax|test)es$', '$1is'],
	                 ['(octop|vir)i$', '$1us'],
	                 ['(alias|status)es$', '$1'],
	                 ['^(ox)en', '$1'],
	                 ['(vert|ind)ices$', '$1ex'],
	                 ['(matr)ices$', '$1ix'],
	                 ['(quiz)zes$', '$1'],
	                 ['(database)s$', '$1'] ];
		var inflections = getIrregularInflections();
		
        for (i=1;i LTE ArrayLen(inflections);i=i+1) 
        {
            ArrayAppend( result, ArraySwap( inflections[i], 1, 2) );
        }			 
		return result;
    }
	
	/**
     * @hint Returns an array of uncountable names.
     */
    private Array function getUncountableInflections()
    {
        return [ 'equipment', 
                 'information', 
                 'rice', 
                 'money', 
                 'species', 
                 'series', 
                 'fish', 
                 'sheep' ];    
    }	
	
    
    /**
     * @hint Inflects a string to its plural version.
     */
    private string function inflectPlural(String value)
    {
	   var inflections = APPLICATION.pluralInflections;
       var result = name;
       
	   for (i=1;i LTE ArrayLen(inflections);i=i+1) 
       {
            value = REReplaceNoCase(value, inflections[i][1], 
                inflections[i][2], 'all');
				
		    if (NOT value eq result)
			{
                break;
			}
       }
       
       return result;
    }
    
    /**
     * @hint Inflects a string to its singular version.
     */
    private string function inflectSingular(String value)    
    {
       var inflections = APPLICATION.singularInflections;
       var result = value;
       var replace = 1;
       var replaceWith = 2;
       
       for (i=1;i LTE ArrayLen(inflections);i=i+1) 
       {
            value = REReplaceNoCase(value, inflections[i][1], 
                inflections[i][2], 'all');
				
			if (NOT value eq result)
            {
                break;
            }
       }
       
       return result;
    }
    
    /**
     * @hint Determines whether a string is uncountable or not.
     */
    private boolean function isUncountableInflection(String value)	
	{
	   var inflections = APPLICATION.uncountableInflections;
	   var result = value;
	   var isUncountable = false;
	   
	   for (i=1;i LTE ArrayLen(inflections);i=i+1) 
	   {
		    result = REReplaceNoCase(result, inflections[i], "", 'all');
			
			if (NOT value eq result)
            {
                return true;
            }
	   }
	   
	   return false;
	}		 
}