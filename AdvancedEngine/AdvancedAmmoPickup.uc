// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * HGWeaponPickUp -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class AdvancedAmmoPickup extends Ammo;



//var name WeaponType;
var bool bMustPressAction;
//var localized string HeavyMessage, MediumMessage, LightMessage;
var localized string ActionPickupMessage;
var int SecondsToLive;
var bool bPickedUpHack;
var (Events) name WeaponPickupEvent;
var() localized string FullAmmoMessage;

const TEMPNOACTIONTIMER = 22;
const STARTDELAY = 233;

enum DIFF_TYPE{
   DT_ANY,
   DT_EASY,
   DT_EASY_AND_NORMAL,
   DT_EASY_NORMAL_AND_HARD
};

var() DIFF_TYPE DifficultySetting;


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
   //no rotating please!
   super.PostBeginPlay();
   SetPhysics(PHYS_None);
   SetMultiTimer(STARTDELAY,1,false);
}

function DetermineDifficulty(){
   if (DifficultySetting != DT_ANY &&
      (DifficultySetting-1) < AdvancedGameInfo(Level.Game).iDifficultyLevel){
      SimDestroy();
   }
}

//simulated function PostNetBeginPlay(){
   //yes I know, magic number -1, shut up, no one cares!
//}

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
   // TriggerEvent (GeneralWeaponPickupEvent ,self, None);
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

   //NOTE: this causes problems between what the controller thinks it can pick up
   //and what this pickup thinks. Let the controller decide.

   //if ( !FastTrace(Other.Location, Location) &&
     //   !FastTrace(Pawn(Other).EyePosition() + Other.Location, Location) )
     // return false;



   // make sure game will let player pick me up
   if( Level.Game.PickupQuery(Pawn(Other), self) )
      {
         TriggerEvent(Event, self, Pawn(Other));
         return true;
      }

   return false;
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
   //}
}


/*****************************************************************
 * GetActionableMessage
 *****************************************************************
 */
function string GetActionableMessage(Controller C){
   local AdvancedPlayerController thePlayer;
   local AdvancedPawn thePawn;
   local Inventory ammocount;

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

    //can't pick up ammo if you are full
    ammocount = thePLayer.Pawn.FindInventoryType(InventoryType);
    if ( ammocount != None &&
         Ammunition(ammocount).AmmoAmount == Ammunition(Ammocount).MaxAmmo ){
         return FullAmmoMessage;
    }
   return ActionPickupMessage;
}


function MultiTimer(int ID){
    if (ID == TEMPNOACTIONTIMER){
        if (bPickedUpHack != true){
            iActionablePriority = default.iActionablePriority;
        }
    } else if ( ID == STARTDELAY){
      DetermineDifficulty();
    }
    super.MultiTimer(ID);
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
      if (iActionablePriority > 0){
         DoEquip(thecontroller.Pawn);
      }
   }


   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other) {
      local pawn otherPawn;
      local Inventory Copy;

      if (bPickedUpHack){
         return;
      }

      if( AdvancedValidTouch(Other)==true ){
         bPickedUpHack = true;
         otherPawn = Pawn(other);
         if ( other == None ) return;
         Copy = SpawnCopy(otherPawn);
         AnnouncePickup(otherPawn);
         SetRespawn();
         if ( Copy != None ) Copy.PickupFunction(otherPawn);
         SimDestroy();
      }
      iActionablePriority = 0;
      SetMultiTimer(TEMPNOACTIONTIMER, 2, false);

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
      if (iActionablePriority > 0){
         DoEquip(thecontroller.Pawn);
      }
   }


   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other){
      local pawn otherPawn;
      local Inventory Copy;

      if (bPickedUpHack){
         return;
      }
      if( AdvancedValidTouch(Other)==true){
         bPickedUpHack = true;
         log("The pickup is giving a weapon to the pawn and deleting itself");
         otherPawn = Pawn(other);
         if ( other == None ) return;
         Copy = SpawnCopy(otherPawn);
         AnnouncePickup(otherPawn);
         SetRespawn();
         SimDestroy();
         if ( Copy != None ) Copy.PickupFunction(otherPawn);
      }
      iActionablePriority = 0;
      SetMultiTimer(TEMPNOACTIONTIMER, 2, false);
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
      if (iActionablePriority > 0){
         DoEquip(thecontroller.Pawn);
      }
   }

   /*****************************************************************
    * DoEquip
    *****************************************************************
    */
   function DoEquip(actor Other){
      local pawn otherPawn;
      local Inventory Copy;

      if (bPickedUpHack == true){
         return;
      }
      if( AdvancedValidTouch(Other)==true ){
         bPickedUpHack = true;
         otherPawn = Pawn(other);
         if ( other == None ) return;
         Copy = SpawnCopy(otherPawn);
         AnnouncePickup(otherPawn);
         SetRespawn();
         if ( Copy != None ) Copy.PickupFunction(otherPawn);
         SimDestroy();
      }
      iActionablePriority = 0;
      SetMultiTimer(TEMPNOACTIONTIMER, 2, false);
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
// Default Properties
//===========================================================================

defaultproperties
{
     bMustPressAction=True
     ActionPickupMessage="Press Action to pick up this ammo"
     SecondsToLive=40
     FullAmmoMessage="Full of this ammo type"
     iActionablePriority=6
     bNetInitialRotation=True
     bProjTarget=True
     bUseCylinderCollision=False
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
