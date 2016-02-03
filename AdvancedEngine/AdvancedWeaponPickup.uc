// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * AdvancedWeaponPickUp -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class AdvancedWeaponPickup extends WeaponPickUp;


var() int PickUpAmmoOverride;
var() int ClipAmmoOverride;


var name WeaponType;
var bool bMustPressAction;
var localized string HeavyMessage, MediumMessage, LightMessage;
var localized string ActionPickupMessage;
var int SecondsToLive;
var bool bPickedUpHack;

var (Events) Name WeaponPickupEvent;
var (Events) editconst const Name GeneralWeaponPickupEvent;


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
simulated function PostBeginPlay(){
   //no rotating please!
   SetPhysics(PHYS_None);
}


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function AnnouncePickup( Pawn Receiver )
{
   //if placed then do the configurable event
   if (!bDropped){
      TriggerEvent( WeaponPickupEvent, self, None );
   }
   //always do a general one aswell
   TriggerEvent (GeneralWeaponPickupEvent ,self, None);
   Super.AnnouncePickup( Receiver );
}



/*****************************************************************
 * AdvancedValidTouch
 * Validate touch (if valid return true to let other pick me up and
 * trigger event).
 * Based on the pickup.validtouch()
 *****************************************************************
 */
function bool AdvancedValidTouch( actor Other )
{

   // make sure its a live player
   if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).Health <= 0) )
      return false;
   // make sure not touching through wall (or if a pawn, do the trace
   // from their eyes)
//   if ( !FastTrace(Other.Location, Location) &&
  //      !FastTrace(Pawn(Other).EyePosition() + Other.Location, Location) )
    //  return false;

   // make sure game will let player pick me up
   if( Level.Game.PickupQuery(Pawn(Other), self) )
      {
         TriggerEvent(Event, self, Pawn(Other));
         return true;
      }
   return false;
}



/*****************************************************************
 * OverrideAmmoCounts
 * For the rare special case where you want to start the player with
 * no/little ammunition. You can explictly set the values you would
 * like here. NOTE: that you will destroy any ammo that the player has
 * already accumulated for this weapon in his inventory when you call
 * this. This is a firm override.
 *****************************************************************
 */
function OverrideAmmoCounts(Pawn ThePawn){

   local Weapon NewWeapon;
   local Ammunition NewAmmunition;

   NewWeapon = Weapon(ThePawn.FindInventoryType(InventoryType));

   if (NewWeapon !=None){

      //adjust the clip in the weapon
      if (ClipAmmoOverride != -1){
         NewWeapon.ReloadCount = ClipAmmoOverride;
      }

      NewAmmunition = Ammunition(ThePawn.FindInventoryType(NewWeapon.AmmoName));
      if (NewAmmunition != None){
         if (PickUpAmmoOverride != -1){
            NewAmmunition.AmmoAmount = PickUpAmmoOverride;
         }
      }
   }
}

/*****************************************************************
 * SimDestroy
 * Might need to respawn this later, so don't really destroy it
 *****************************************************************
 */
function SimDestroy(){
    bHidden=true;
    bPickedUpHack=true;
    iActionablePriority=0;
}

/*****************************************************************
 * RespawnEffect
 * Make it look like it has come back
 *****************************************************************
 */
function RespawnEffect(){
    bPickedUpHack=false;
    iActionablePriority=default.iActionablePriority;
    bHidden=false;
}


/*****************************************************************
 * PickedUpByPawn
 *****************************************************************
 */
private function PickedUpByPawn(Pawn Taker){
         local Inventory Copy;
         bPickedUpHack = true;
         if ( Taker == None ) return;
         Copy = SpawnCopy(Taker);
         AnnouncePickup(Taker);
         OverrideAmmoCounts(Taker);
         SetRespawn();
         SimDestroy();
         if ( Copy != None ) Copy.PickupFunction(Taker);
}

//===========================================================================
// Actionable Interface
//===========================================================================


/*****************************************************************
 * GetActionablePriority
 *****************************************************************
 */
function int GetActionablePriority(Controller C){

    //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up
 //if (level.TimeSeconds - LastRenderTime <= 0.5 ){
    if (bPickedUpHack == true){
        return 0;
    }
    return iActionablePriority;
 //  }
}


/*****************************************************************
 * GetActionableMessage
 *****************************************************************
 */
simulated function string GetActionableMessage(Controller C){
   local AdvancedPlayerController thePlayer;
   local AdvancedPawn thePawn;

   thePlayer = AdvancedPlayerController(C);
   if (thePlayer == None){
      return "";
   }

   thePawn = AdvancedPawn(thePlayer.Pawn);
   if (thePawn == None){
      return "";
   }

   if (bPickedUpHack == true){
      return "";
   }

     //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up


    //if (level.TimeSeconds - LastRenderTime > 0.5 ){
      //  return "";
    //}
   //if the player has the slots filled for the given weapon type already
   //then put up the swap message for that type
   //or if the player must always press the swap button
   if (thePawn.RemainingInventoryCapacity(WeaponType) == 0 ||
       bMustPressAction ==  true){
         return ActionPickupMessage;
   }
}



//===========================================================================
// Pickup Interface
//===========================================================================



/*****************************************************************
 * InitDroppedPickupFor
 *
 * Overridden to prevent the system from treating this as a dropped
 * item. This way it is not deleted.
 *****************************************************************
 */
function InitDroppedPickupFor(Inventory Inv)
{
   SetPhysics(PHYS_Falling);
   GotoState('FallingPickup');
   Inventory = Inv;

   if (AdvancedWeapon(inv) != none){
       AdvancedWeapon(inv).AmmoType = none; //@@@ maybe to allow respawned players to pick up
   }

   bAlwaysRelevant = false;
   bOnlyReplicateHidden = false;
   bUpdateSimulatedPosition = true;

   bDropped = true;
   LifeSpan = SecondsToLive;
   bIgnoreEncroachers=false; // handles case of dropping stuff on lifts etc
}



//===========================================================================
// FALLING PICKUP
//===========================================================================
state FallingPickup
{

   /*****************************************************************
    * DoActionableAction
    *****************************************************************
    */
   function DoActionableAction(Controller thecontroller){
      //do touch
      DoEquip(thecontroller.Pawn);
   }


   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other){
      if (bPickedUpHack == true){  return;   }
      if( AdvancedValidTouch(Other)==true ){
         PickedUpByPawn(Pawn(Other));
      }
   }



   /*****************************************************************
    * Touch
    *****************************************************************
    */
   function Touch( actor Other )
   {
      //only if we don't need to press action
      if (!bMustPressAction){
         // If touched by a player pawn, let him pick this up.
         DoEquip(Other);
      }
   }

   /*****************************************************************
    * BeginState
    *****************************************************************
    */
   function BeginState(){
    SetTimer(LifeSpan, false);
  }

}

//===========================================================================
// STATE PICKUP
//===========================================================================
auto state Pickup{

   /*****************************************************************
    * DoActionableAction
    *****************************************************************
    */
   function DoActionableAction(Controller thecontroller){
      //do touch
      DoEquip(thecontroller.Pawn);
   }


   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other){
      if (bPickedUpHack){  return;  }
      if( AdvancedValidTouch(Other)==true){
         PickedUpByPawn(Pawn(Other));
      }
   }



   /*****************************************************************
    * Touch
    *****************************************************************
    */
   function Touch( actor Other )
   {
      //only if we don't need to press action
      if (!bMustPressAction){
         // If touched by a player pawn, let him pick this up.
         DoEquip(Other);
      }
   }

   /*****************************************************************
    * BeginState
    *****************************************************************
    */
   function BeginState(){
      if ( bDropped ){
         AddToNavigation();
         SetTimer(LifeSpan, false);
      }
   }

}


//===========================================================================
// Event data
//===========================================================================
state FadeOut{

   /*****************************************************************
    * DoActionableAction
    *****************************************************************
    */
   function DoActionableAction(Controller thecontroller){
      //do touch
      DoEquip(thecontroller.Pawn);
   }

   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other){
      if (bPickedUpHack == true){ return; }
      if( AdvancedValidTouch(Other)==true ){
         PickedUpByPawn(Pawn(Other));
      }
   }



  /*****************************************************************
    * Touch
    *****************************************************************
    */
   function Touch( actor Other )
   {
      //only if we don't need to press action
      if (!bMustPressAction){
         // If touched by a player pawn, let him pick this up.
         DoEquip(Other);
      }
   }
}


//===========================================================================
// Sleeping
//===========================================================================
State Sleeping{
    /*****************************************************************
     * GetActionablePriority
     *****************************************************************
     */
    function int GetActionablePriority(Controller C){
        return 0;
    }

    /*****************************************************************
     * GetActionableMessage
     *****************************************************************
     */
    function string GetActionableMessage(Controller C){
        return "";
    }

}

//===========================================================================
// Event data
//===========================================================================

defaultproperties
{
     PickUpAmmoOverride=-1
     ClipAmmoOverride=-1
     bMustPressAction=True
     ActionPickupMessage="Press Action to pick up this weapon"
     SecondsToLive=40
     GeneralWeaponPickupEvent="GEN_WEP_PICKUP_EVENT"
     bWeaponStay=False
     iActionablePriority=1
     bNetInitialRotation=True
     bProjTarget=True
     bUseCylinderCollision=False
     AmbientGlow=0
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
