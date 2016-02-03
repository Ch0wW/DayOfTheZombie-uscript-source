// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * ACTION_OpenMenu
 *
 * @author  Jesse LaChapelle (jesse@digitialextremes.com)
 * @version $Revision: #1 $
 * @date    Dec 2003
 ****************************************************************
 */
class ACTION_OpenMenu extends ScriptedAction;

var(Action) string Menu;
var(Action) string MenuParam1;
var(Action) string MenuParam2;

/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

   local PlayerController pc;

   pc = c.Level.GetLocalPlayerController();
   GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
           .OpenMenu(Menu,MenuParam1,MenuParam2);

   return false;

}


/****************************************************************
 * DefaultProperties
 ****************************************************************
 */

defaultproperties
{
     ActionString="Open Menu"
}
