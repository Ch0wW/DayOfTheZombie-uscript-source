// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * ACTION_OpenMenu
 *
 * @author  Jesse LaChapelle (jesse@digitialextremes.com)
 * @version $Revision: #2 $
 * @date    Dec 2003
 ****************************************************************
 */
class ACTION_OpenTitleMenu extends ScriptedAction;

var(Action) localized string MainTitleText;
var(Action) localized string SmallText;
//var(Action) float DisplayTime;

/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

   local AdvancedPlayerController pc;

   pc = AdvancedPlayerController(c.Level.GetLocalPlayerController());

   GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
           .OpenMenu("DOTZMenu.DOTZTitleMenu",MainTitleText,SmallText);

//   DOTZTitleMenu(GuiController.TopPage).TimeRemaining = DisplayTime;
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
