// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZMPGameBase extends AdvancedMPGameBase;


function string GetCurrentProfileName(){
   return DOTZPlayerControllerBase(Level.GetLocalPlayerController()).GetCurrentProfileName();
}


/*****************************************************************
 * GiveDefaultInventory
 *****************************************************************
 */
function GiveDefaultInventory(Pawn P){

   local int i;

   AdvancedPawn(P).SetInventoryLimit(1,'MeleeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'DOTZGrenadeWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'GlockWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'M16Weapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RevolverWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'RifleWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'ShotgunWeapon');
   AdvancedPawn(P).SetInventoryLimit(1,'SniperWeapon');
   AdvancedPawn(P).SetInventoryLimit(2,'DOTZGunWeapon');

   // give the player default weaponry
   if (level.GameSpecificLevelInfo == none ||
      MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).StartingWeapon.length == 0){
      P.GiveWeapon(DefaultInventory);
   //unless there are other specified in the level info
   } else {
      for( i=0; i < MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).StartingWeapon.Length; i++){
         P.GiveWeapon(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).StartingWeapon[i]);
      }
   }
   P.Controller.ClientSwitchToBestWeapon();

}

/*****************************************************************
 * EndGame
 *****************************************************************
 */
function EndGame(PlayerReplicationInfo Winner, string Reason){

   local OpponentFactory tempOP;
   foreach AllActors(class'OpponentFactory', tempOP){
      tempOP.theCreationPolicy.stop();
      tempOP.GotoState('Dormant');
   }
   GameReplicationInfo.bMatchHasBegun = false;
   super.EndGame(Winner,Reason);

}


/******************************************************************
 * ToggleObjectivesDisplay
 * Turns on/off the objectives list
 ******************************************************************
 */
//exec function ToggleObjectivesDisplay() {
    //if ( theObjMgr.showObjectives ) theObjMgr.Hide();
    //else theObjMgr.show();

    // Show player score instead
//}

defaultproperties
{
     RedTeamWins(0)=Sound'DOTZXAnnouncer.CTF.CTFRedWon'
     BlueTeamWins(0)=Sound'DOTZXAnnouncer.CTF.CTFBlueWon'
     FiveMinuteWarning(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning01'
     FiveMinuteWarning(1)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning02'
     FiveMinuteWarning(2)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning03'
     OneMinuteWarning(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning01'
     OneMinuteWarning(1)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning02'
     OneMinuteWarning(2)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning03'
     OneMinuteWarning(3)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning04'
     YouWin(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatchYouWin'
     YouLose(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatchYouLose'
     DefaultInventory="DOTZWeapons.FistWeapon"
     HUDType="DOTZGame.DOTZHud"
     DeathMessageClass=Class'AdvancedEngine.AdvancedDeathMessage'
     PlayerControllerClass=Class'DOTZEngine.DOTZPlayerController'
}
