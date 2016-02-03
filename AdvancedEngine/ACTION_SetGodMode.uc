// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ACTION_SetGodMode - enables god mode on AdvancedPawns.
 *
 * @version $Rev: 5335 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Aug 2004
 */
class ACTION_SetGodMode extends ScriptedAction;

// turn god mode on?
var() bool bEnableGodMode;

/**
 */
function bool InitActionFor( ScriptedController c ) {
    local AdvancedPawn p;
    p = AdvancedPawn( c.Pawn );
    if ( p == None ) return false;
    p.bGodMode = bEnableGodMode;
    return false;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ActionString="SafePawnKill"
}
