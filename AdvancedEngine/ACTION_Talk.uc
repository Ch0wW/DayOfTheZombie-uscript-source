// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * ACTION_AdvancedDisplayKills
 *
 * @author  Jesse LaChapelle (jesse@digitialextremes.com)
 * @version $Revision: #1 $
 * @date    Dec 2003
 ****************************************************************
 */
class ACTION_Talk extends ScriptedAction;

var() bool bTalk;


/****************************************************************
 * InitActionsFor
 ****************************************************************
 */
function bool InitActionFor( ScriptedController c ) {

   local AdvancedPawn Talker;
   Talker = AdvancedPawn(c.Pawn);

   if (bTalk){
      Talker.GotoState('Talking');
   } else {
      Talker.GotoState('');
   }
   return false;

}


/****************************************************************
 * DefaultProperties
 ****************************************************************
 */

defaultproperties
{
     bTalk=True
     ActionString="Talking"
}
