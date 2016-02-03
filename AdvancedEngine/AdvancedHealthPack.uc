// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005

/****************************************************************
 * HealthPack
 *
 * Things that you should touch to "get". They can be turned on and
 * look special.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 ****************************************************************
 */
class AdvancedHealthPack extends AdvancedPickUp
placeable;

var(HealthPack) float HealthAmount;
var(HealthPack) sound HealSound;
var(HealthPack) localized string FullHealthMessage;
var(HealthPack) localized string ActionMessage;

const TEMPNOACTIONTIMER = 22;


/*****************************************************************
 * RespawnEffect
 * Make it look like it has come back
 *****************************************************************
 */
function RespawnEffect(){
    bPickedUpHack=false;
    SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers);
    iActionablePriority=default.iActionablePriority;
    bHidden=false;
}


/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller C){

   local AdvancedPawn ap;

   if (bPickedUpHack == true){
      return;
   }

   ap = AdvancedPawn(C.Pawn);

   //don't work if you have full health
   //if (ap.Health == ap.DiffToHealth(ap.DifficultyLevel)){
   if (ap.Health == ap.default.Health){
      iActionablePriority = 0;
      SetMultiTimer(TEMPNOACTIONTIMER, 2, false);
      return;
   }

   //either the amount we normally give (multiplied by difficulty),
   // or the max
/*
   ap.Health = FMin(ap.Health + (ap.DiffToHealth(ap.DifficultyLevel)* (HealthAmount/100)),
                   ap.DiffToHealth(ap.DifficultyLevel));
*/
   bPickedUpHack= true;
   ap.Health = FMin(ap.Health + HealthAmount, ap.default.Health);
   PlayHealingSound(ap);
   SetRespawn();
   SimDestroy();
}

/****************************************************************
 * PlayHealingSound
 ****************************************************************
 */
function PlayHealingSound(AdvancedPawn theplayer){
   thePlayer.PlaySound( HealSound, SLOT_None, 1.0 );
   PlayerController(theplayer.controller).ClientFlash(0.5,vect(1000,1000,1000 ));
}


/*****************************************************************
 * GetActionableMessage
 * overriden to add a full health message
 *****************************************************************
 */
function string GetActionableMessage(Controller C){

   local AdvancedPawn ap;

   if (bPickedUpHack == true){
      return "";
   }

   ap = AdvancedPawn(C.Pawn);
   //don't work if you have full health
   //if (ap.Health == ap.DiffToHealth(ap.DifficultyLevel)){
   if (ap.Health == ap.default.Health){
      return FullHealthMessage;
   } else {
      return ActionMessage;
   }
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int ID){
    if (ID == TEMPNOACTIONTIMER){
        iActionablePriority = default.iActionablePriority;
    }
    super.MultiTimer(ID);
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     HealthAmount=100.000000
     FullHealthMessage="You have full health"
     ActionMessage="Press Action for medical attention"
     iActionablePriority=8
     DrawType=DT_StaticMesh
     bHasHandlers=True
     CollisionRadius=20.000000
     CollisionHeight=18.000000
}
