// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * ACTION_OpenStoryMenu
 *
 * @author  Jesse LaChapelle (jesse@digitialextremes.com)
 * @version $Revision: #1 $
 * @date    Dec 2003
 ****************************************************************
 */
class ACTION_OpenStoryMenu extends ScriptedAction;

var(Action) string ChapterNumber;
var(Action) string PageNumber;
var(Action) string RevealledTo;

/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

   local AdvancedPlayerController pc;

   pc = AdvancedPlayerController(c.Level.GetLocalPlayerController());
   DOTZGameInfoBase(c.Level.Game).RevealChapter(int(ChapterNumber),int(RevealledTo));
   //DOTZGameInfoBase(c.Level.Game).bPauseWithMenu = false;
   //pc.setPause(true);
   //DOTZGameInfoBase(c.Level.Game).bPauseWithMenu = true;
   AdvancedGameInfo(c.Level.Game).NoMenuPause(true,pc);
   GuiController(pc.Player.InteractionMaster.GlobalInteractions[0])
           .OpenMenu("DOTZMenu.DOTZStoryPageMenu",ChapterNumber,PageNumber);

   return false;

}


/****************************************************************
 * DefaultProperties
 ****************************************************************
 */

defaultproperties
{
     RevealledTo="-1"
     ActionString="Open Story Menu"
}
