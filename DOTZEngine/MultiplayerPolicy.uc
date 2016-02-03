// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MultiplayerPolicy extends InfinitePolicy;

/*****************************************************************
 * ShouldCreate
 * If shouldCreate returns true then an opponent appears so you should
 * increase the bot count before you leave cause there an
 *****************************************************************
 */
function bool shouldCreate() {
   if (theFactory.Level.Game.TooManyBots(none)){
       return false;
   }
   return super.shouldCreate();
}

/*****************************************************************
 * opponentKilled
 *****************************************************************
*/
function opponentKilled() {
   AdvancedMPGameBase(theFactory.Level.Game).NotifyRemoveBot();
   super.opponentKilled();
}

/*****************************************************************
 * opponentCreated
 *****************************************************************
 */
function opponentCreated(){
   AdvancedMPGameBase(theFactory.Level.Game).NotifyAddBot();
   super.OpponentCreated();
}

defaultproperties
{
}
