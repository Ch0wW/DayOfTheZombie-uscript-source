// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MessageQueue - handles queueing text messages (strings)
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class MessageQueue extends Object;


//===========================================================================
// Editable properties
//===========================================================================


//===========================================================================
// Internal data
//===========================================================================

// front of the queue is lowest index.
var private Array<String> elements;


//===========================================================================
// MessageQueue interface
//===========================================================================

/**
 * 
 */
function enqueueMessage( coerce String msg ) {
    elements[elements.length] = msg;
}

/**
 */
function String dequeueMessage() {
    local String result;
    if ( elements.length < 1 ) return "";

    result = elements[0];
    elements.remove( 0, 1 );

    return result;
}

/**
 */
function int length() {
    return elements.length;
}




//===========================================================================
// Implementation and helpers
//===========================================================================


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
