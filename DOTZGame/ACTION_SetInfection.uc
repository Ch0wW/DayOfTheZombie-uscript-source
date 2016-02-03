// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ACTION_SetInfection extends ScriptedAction;

// turn god mode on?
var() bool bInfected;

/**
 */
function bool InitActionFor( ScriptedController c ) {
    local PlayerPawnBase p;
    p = PlayerPawnBase( c.Pawn );
    if ( p == None ) return false;
    p.SetInfectionState(bInfected, true );
    return false;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ActionString=""
}
