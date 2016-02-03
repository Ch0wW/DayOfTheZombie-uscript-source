// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MultiObjective - an objective that is completed by completing each
 *     of the subObjectives.
 *
 * @version $Rev$
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class MultiObjective extends ObjectiveBase;


//===========================================================================
// Editable properties
//===========================================================================
var(Objective) editinline Array<ObjectiveBase> SubObjectives;


//===========================================================================
// Internal data
//===========================================================================
var int numComplete;


//===========================================================================
// Implementation
//===========================================================================

/**
 */
function init( EventDispatcher ed, MessageDispatcher md ) {
    local int i;

    super.init( ed, md );
    numComplete = 0;
    for ( i = 0; i < subObjectives.length; ++i ) {
        subObjectives[i].init( ed, md );
        subObjectives[i].myParent = self;
    }
}

/**
 * Add my sub-objectives also.
 */
function getEvents( out Array<Name> events ) {
    local int i;
    super.getEvents( events );
    for ( i = 0; i < subObjectives.length; ++i ) {
        subObjectives[i].getEvents( events );
    }
}

/**
 * If all of my sub-objectives are now complete, then this objective
 * is complete.
 */
function notifyOfSuccess( ObjectiveBase o ) {
    local int i;
    for ( i = 0; i < subObjectives.length; ++i ) {
        if ( !subObjectives[i].isComplete ) return;
    }
    success();
}

/**
 * For now, we don't distinguish between success and failure, since
 * the game will probably be ended by any event that would trigger
 * failure.
 */
function notifyOfFailure( ObjectiveBase o ) {
    //TODO temp hack
    notifyOfSuccess( o );
}

/**
 * Add my info, and increase the indentation level for all
 * sub-objectives.
 */
function getObjListText( out Array<ObjText> objsText, int indentLevel ) {
    local int i;
    if ( bHidden ) return;
    if ( ObjectiveText != "" ) {
        super.getObjListText( objsText, indentLevel );
        ++indentLevel;
    }
    // else leave the subobjectives at the current indent level
    for ( i = 0; i < subObjectives.length; ++i ) {
        subObjectives[i].getObjListText( objsText, indentLevel );
    }
}

/**
 * Pass through to see if any sub-objectives can handle this event.
 */
function bool handleEvent( Name event ) {
    local int i;
    for ( i = 0; i < subObjectives.length; ++i ) {
        subObjectives[i].handleEvent( event );
    }
    return super.handleEvent(event);
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
