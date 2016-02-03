// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * ACTION_AdvancedFadeView
 * 
 * @author  Jesse LaChapelle (jesse@digitialextremes.com)
 * @version $Revision: #1 $
 * @date    Dec 2003
 ****************************************************************
 */
class ACTION_AdvancedFadeView extends ScriptedAction;


/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

   local AdvancedPlayerController Player;

   Player = AdvancedPlayerController(c.Level.GetLocalPlayerController());
   Player.Fade();

   return false;   

}


/****************************************************************
 * DefaultProperties
 ****************************************************************
 */

defaultproperties
{
     ActionString="Advanced Fade View"
}
