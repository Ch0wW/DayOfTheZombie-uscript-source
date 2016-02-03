// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ObjectiveBase - base class for all kinds of objectives that LDs can
 *     define.
 *
 * @version $Rev$
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class ObjectiveBase extends Object
    abstract
    hidecategories(Object)
    collapsecategories
    editinlinenew;




//===========================================================================
// Editable properties
//===========================================================================

// text to display to the player
var(Objective) localized String ObjectiveText;
// triggered when this objective is completed successfully
var(Objective) Name OnSuccessEvent;
// name of the event that will reveal this objective (un-hide it)
var(Objective) Name RevealTag;
// show in the current objectives list?
var(Objective) bool StartRevealed;
// un-reveal when completed?
var(Objective) bool HideOnCompletion;


//===========================================================================
// Internal data
//===========================================================================

var bool isComplete;
var EventDispatcher myDispatcher;
var MessageDispatcher myMsgDispatcher;
// if this is a sub-objective, this refers to the parent
var ObjectiveBase   myParent;
var bool bHidden;
var const int VSPACE, INDENT_WIDTH;

//TODO triggered if this objective fails
var Name OnFailEvent;
var Localized String NewObjectiveTxt;


struct ObjText {
    var int indentLevel;
    var String Text;
    var bool isComplete;
};


//===========================================================================
// Implementation
//===========================================================================

/**
 *
 */
function init( EventDispatcher ed, MessageDispatcher md ) {

   //   local string Package;
   //   local string Section;

    myDispatcher    = ed;
    myMsgDispatcher = md;
    bHidden = !StartRevealed;


    /* Rember you said you would put this stuff back when you were
    done development and ready to localize? Remember?
    Package = Left(string(Self), InStr(string(Self),"."));
    Section = Right(string(Self), (Len(string(Self)) - InStr(string(Self),"."))-1);
    ObjectiveText = Localize(Section, "ObjectiveText", Package);
    */
}

/**
 * Add the events I want to be notified of to the list...
 */
function getEvents( out Array<Name> events ) {
   //                // Log( self @ "Getting events from" @ self  )    ;
    events[events.length] = revealTag;
}

/**
 * May be called whenever an event occurs for one of the objectives in
 * the level.  Return true if the event is for this objective, false
 * otherwise.
 */
function bool handleEvent( Name event ) {
    if ( event == '' ) return false;
    if ( event == RevealTag ) {
        bHidden = false;
        if ( myMsgDispatcher != None ) {
            myMsgDispatcher.DispatchMessage( NewObjectiveTxt );
        }
        return true;
    }
    else {
        return false;
    }
}

/**
 * The objective has been succesfully completed.  Handle bookkeeping
 * and such here.
 */
function success() {
    isComplete = true;
    if ( HideOnCompletion ) bHidden = true;
    myDispatcher.dispatchEvent( onSuccessEvent );
    if ( myParent != None ) myParent.notifyOfSuccess( self );
}

/**
 * Analogous to success() when this objective has failed.
 */
function failure() {
    isComplete = true;
    if ( HideOnCompletion ) bHidden = true;
    myDispatcher.dispatchEvent( onFailEvent );
    if ( myParent != None ) myParent.notifyOfFailure( self );
}

/**
 * Called if a sub-objective fails, in case that effects this
 * objective.
 */
function notifyOfFailure( ObjectiveBase o );

/**
 * Called if a sub-objective succeeds, in case that effects this
 * objective.
 */
function notifyOfSuccess( ObjectiveBase o );

/**
 * Add this objective's info to a list, and info for any
 * sub-objectives.
 */
function getObjListText( out Array<ObjText> objsText, int indentLevel ) {
    local ObjText myInfo;
    if ( bHidden ) return;
    myInfo.text        = objectiveText;
    myInfo.indentLevel = indentLevel;
    myInfo.isComplete  = isComplete;
    objsText[objsText.length] = myInfo;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     StartRevealed=True
     VSPACE=128
     INDENT_WIDTH=64
     NewObjectiveTxt="New objective!"
}
