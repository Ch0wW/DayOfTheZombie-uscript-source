// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Comparator - encapsulates a particular comparison method.
 *    Typically subclassed for specific object types, so that they can
 *    be sorted.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class Comparator extends Object
   abstract;

/**
 * Compares its two arguments for order. Returns a negative integer,
 * zero, or a positive integer as the first argument is less than,
 * equal to, or greater than the second. 
 */
function int compare( Object lhs, Object rhs );

defaultproperties
{
}
