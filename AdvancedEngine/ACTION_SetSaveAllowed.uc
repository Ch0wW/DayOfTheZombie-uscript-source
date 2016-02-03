// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ACTION_SetSaveAllowed - allows LDs to prevent the player from using the
 *    save system in AdvancedGameInfo, and later re-enable it.
 *
 * @author  Neil Gower (neilg@digitialextremes.com)
 * @version $Rev: 5335 $
 * @date    Aug 2004
 */
class ACTION_SetSaveAllowed extends ScriptedAction;


// false to disable saving, true to enable it again...
var() bool SaveAllowed;


/**
 */
function bool InitActionFor( ScriptedController c ) {
   local AdvancedGameInfo g;

   g = AdvancedGameInfo( c.Level.Game );
   if ( g == none ) return false;

   g.bDisableSave = !SaveAllowed;
   return false;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ActionString="Save Allowed"
}
