// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DGActionDestructAll - causes all intact actors in the group to start their
 * destruct sequence.
 *
 * @Author  Neil Gower (neilg@digitalextremes.com)
 * @Version $Rev: 5335 $
 * @Date    June 2003
 */
class DGActionDestructAll extends DestructGroupAction;


//===========================================================================
// Internal data
//===========================================================================

var bool bDestructed;


//===========================================================================
// DestructGroupAction hooks
//===========================================================================

/**
 * Destruct all of the actors in this group that are intact, and then
 * call the super class action to chain further actions.
 */
function doAction( DestructEffectsGroup g ) {
    local int i;
    local DestructEffectsActor d;

    if ( bDestructed ) return;
    bDestructed = true;
    DebugLog( "Destructing all actors");
    for ( i = 0; i < g.getNumDActors(); ++i ) {
        d = g.getDActor( i );
        DebugLog( "Destructing" @ d );
        if ( d.isInState('Intact') ) d.GotoState( 'Destructing' );
    }
    super.doAction( g );
}

/**
 */
function reset() {
    super.reset();
    bDestructed = default.bDestructed;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
}
