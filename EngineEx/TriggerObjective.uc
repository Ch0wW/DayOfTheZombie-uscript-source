// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * TriggerObjective - an objective completed by the triggering of a
 *     particular event.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class TriggerObjective extends ObjectiveBase;


//===========================================================================
// Editable properties
//===========================================================================

// event that means the objective is complete
var(Objective) Name successTag;


//===========================================================================
// Internal data
//===========================================================================

//TODO event that means the objective has failed
var Name failTag;


//===========================================================================
// Implementation
//===========================================================================

/**
 * Add my tags to the event list...
 */
function getEvents( out Array<Name> events ) {
    super.getEvents( events );
    events[events.length] = successTag;
    events[events.length] = failTag;
}

/**
 *
 */
function bool handleEvent( Name event ) {
    if ( event == successTag ) success();
    if ( event == failTag ) myDispatcher.dispatchEvent( onFailEvent );
    return super.handleEvent( event );
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
