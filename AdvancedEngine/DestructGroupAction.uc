// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * The interface for actions performed on DestructEffectsGroups.  You cannot
 * use this class directly, since it is abstract.
 *
 * TODO:
 *  - switch over to dynamic array of actions, rather than nesting.
 *    Easier for LDs to work with.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    June 2003
 */
class DestructGroupAction extends Object
   abstract
   hidecategories(Object)
   collapsecategories
   editinlinenew;


//===========================================================================
// Editable properties
//===========================================================================

// an additional action to perform after this one.
var() editinline DestructGroupAction NextAction;
// produce debugging info in the game log
var() bool bDebugLogging;


//===========================================================================
// DestructGroupAction interface
//===========================================================================

/**
 * Called once per game by the DestructEffectsGroup.
 */
function init();

/**
 * Called by the DestructEffectsGroup to perform an action on the
 * DestructEffectsActors in the group.
 */
function doAction( DestructEffectsGroup g ) {
    if ( NextAction != None ) NextAction.doAction( g );
}

/**
 * Called to restore the group to it's original state.
 */
function reset() {
    if ( NextAction != None ) nextAction.reset();
}

/**
 * Handy debugging helper.
 */
function DebugLog( coerce String s, optional name tag ) {
    if ( bDebugLogging ) Log( s @ self, 'DEA' );
}

defaultproperties
{
}
