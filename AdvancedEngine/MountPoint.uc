// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MountPoint -
 *
 * The interface to all mount points. This parent class takes care of
 * things that are common to all mount points (obviously). This is
 * stuff like ensuring the emitter exists when enabled, and that the
 * player can mount and unmount. Ensuring the emitter is destroyed
 * when the mount is disabled, as well as preventing any mounts. It
 * also have code to lock and unlock the mount so that the player can
 * not get out unless specfically allowed to.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
Class MountPoint extends Advancedactor
hidedropdown;


//===========================================================================
// Editable properties
//===========================================================================

//The weapon that this mount point will add to the player's inventory
//when they choose to mount, if this is 'none' then it will try and
//use the player's heavy weapon
var() class<FixedWeapon> objMountWeapon;
//The actor that this mount point should attach too. Likely this will
//be a mover of some sort if you want the mount point to move.
var() actor BaseActor;
//The field of fire specifier (the up and down bit)
var() int PitchRange;
//Field of fire specifer (the side to sidey bit)
var() int YawRange;
//The amount that a player should be set back with they unmount
var() vector UnMountOffset;
//The amount the weapon should be offset when viewed from within the mount
var() vector PlayerViewOffset;
//The location to spawn projectiles when inside the mount
var() vector FireOffset;
//If the player can get out of this mount point
var() bool LockPlayer;
//Used in Master/Slave points to identify that they are related
var() Name MountGroup;
//the message to let the player know how to operate this device
var() localized String MountMessage;
var() localized String UnMountMessage;
//mesh exists when not active or not
var() bool bMeshVisibleWhenDisabled;
//mesh exists when mounted or not
var() bool bMeshVisibleWhenMounted;
//the factor by which we adjust the damage for players that are in the mount
var() float DamageModifier;
//shake reduction for the weapon, mounted improves your stability
var() float ShakeModifier;
var AdvancedWeapon WeaponToMount;
var AdvancedWeapon OriginalWeapon;
var bool bInUse;
var bool bCanMount;

const MOUNT_DELAY    = 22323;
//===========================================================================
// Event data
//===========================================================================

//Events created
var(Events) Name MountedEvent;
var(Events) Name UnMountedEvent;

//Events handled (by checking the group)
var(Events) editconst const Name hEnableMount;
var(Events) editconst const Name hDisableMount;
//turns the lock on and off
var(Events) editconst const Name hEnableLock;
var(Events) editconst const Name hDisableLock;

//Sucks the player in no matter where they are
var(Events) editconst const Name hForceMount;

//===========================================================================
// Internal data
//===========================================================================

//The player that is inside you
var Pawn MountedPawn;
//The sparkly bit that lets you know the mount is active
var Emitter ActiveEmitter;
var() class<Emitter> EmitterType;

var() Shader ActiveShader;




/****************************************************************
 * PostBeginPlay
 * A call to hard attach to some other object, like a railshooter of
 * some sort.
 ****************************************************************
 */
function PostBeginPlay(){

  Super.PostBeginPlay ();

  if (!bMeshVisibleWhenDisabled){
     bHidden=true;
  }

  //glowing stuff
  CopyMaterialsToSkins();

  if (BaseActor != None){
     SetBase(BaseActor);
  }
}

/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller InitiatingController){

   //if not mounted then mount
   if (AdvancedPawn(InitiatingController.Pawn).objMount == None){
      DoMount(InitiatingController.Pawn);
   } else {
      DoUnMount();
   }
}

/****************************************************************
 * GetActionableMessage
 ****************************************************************
 */
function string GetActionableMessage(Controller C){

   //if it is on
   if (IsInState('Enabled') == true){
      //if you are not in it
      if (MountedPawn == None){
         //return the message to get in the mount
         return MountMessage;

      //if you can get out
      } else if (!LockPlayer) {
         return UnMountMessage;
      }
   }

   return "";

}

/****************************************************************
 * GetActionablePriority
 ****************************************************************
 */
function int GetActionablePriority(Controller C){
   return iActionablePriority;
}

/****************************************************************
 * DoMount
 * The function that makes the player mounted, provided that the
 * player has a heavy weapon or the mountpoint provides a fixed one.
 ****************************************************************
 */
function bool DoMount(Pawn PawnToMount){

    if (bCanMount == false){ return false; }

   SetMultiTimer(MOUNT_DELAY,0.5,false);
   bCanMount = false;
   //if there is an inventory item specified
   if (objMountWeapon != None){
      WeaponToMount = Spawn(objMountWeapon);
      WeaponToMount.GiveTo(PawnToMount);

   //Otherwise find the heavy weapon
   } else {
      WeaponToMount=AdvancedWeapon(AdvancedPawn(PawnToMount).FindInventoryByGroup('HeavyWeapon'));
   }

   //If there is a weapon to mount
  if (WeaponToMount != None) {


     OriginalWeapon = AdvancedWeapon(PawnToMount.Weapon);
     MountedPawn = PawnToMount;
     WeaponToMount.IdleAnim = WeaponToMount.MountedIdleAnim;

     WeaponToMount.ModifyShake(ShakeModifier);
     WeaponToMount.SetInfiniteAmmo(true);
     SetRotation(Rotation);
     //hide your mount indicator
     if (!bMeshVisibleWhenMounted){
        bHidden=true;
     }
     TurnShaderOnOff(false);
     if ( activeEmitter != None ) ActiveEmitter.Destroy();
     //Change the weapon
     PawnToMount.Controller.ClientSetWeapon(WeaponToMount.Class);
     //ChangeWeapon(PawnToMount, WeaponToMount);

     PawnToMount.WalkBob =vect(0,0,0);
     AdjustView();

     //Tell the Controller to keep track of this mountpoint
     AdvancedPlayerController(PawnToMount.Controller).DoMount(self);
     //AdvancedPlayerController(PawnToMount.Controller).objMount = self;

     PawnToMount.bBlockActors = false;
     PawnToMount.bBlockPlayers = false;
     PawnToMount.bCollideWorld = false;
     bBlockZeroExtentTraces = false;
     bInUse = true;

     // notify anyone who's interested
     TriggerEvent( MountedEvent, self, None );
     return true;
  }
  return false;
}

function PostLoad(){
   if (AdvancedPawn(Level.GetLocalPlayerController().Pawn).objMount == self){
      if (WeaponToMount.default.PlayerViewOffset == WeaponToMount.PlayerViewOffset){
         AdjustView();
      }
   }

   /*  CopyMaterialsToSkins();
   if (IsInState('Enabled')){
    TurnShaderOnOff(true);
   }
   */
}

function AdjustView(){

   if (WeaponToMount == None) return;

  // Log(PlayerViewOffset);
   //Log(WeaponToMount);
  // Log(WeaponToMount.PlayerViewOffset);

   WeaponToMount.PlayerViewOffset = WeaponToMount.PlayerViewOffset
      + PlayerViewOffset
      + WeaponToMount.MountedOffset;

   Log(WeaponToMount.PlayerViewOffset);

   WeaponToMount.FireOffset= WeaponToMount.FireOffset
      + FireOffset
      + WeaponToMount.MountedFireOffset;
}

/****************************************************************
 * DoUnMount
 * If a weapon was added to the inventory (ie Fixed weapon point) then
 * we need to remove that weapon now. Also we don't want to leave the
 * player weaponless so we switch back to the heavy weapon.
 ****************************************************************
 */
function bool DoUnMount()
{
   local Inventory InventoryToRemove;
   local AdvancedWeapon WeaponToActivate;
   local Rotator PlaneRot;
   local Vector vectPlaneRot;

   if (bCanMount == false){ return false; }
   SetMultiTimer(MOUNT_DELAY,0.5,false);
   bCanMount = false;

   //if nobody is mounted or you are locked in then fail while it is
   //still active. Note, disabling the mount should eject you no
   //matter what
   if (MountedPawn == None ||
       (LockPlayer == true && isInState('Enabled'))){
      return false;
   }

   //bring back your mount indicators
   if (isInState('Enabled') == true){
      TurnIndicatorsOnOff(true);
      bHidden=false;
   }

   if (bMeshVisibleWhenDisabled){
      bHidden=false;
   }

   //remove the weapon from the inventory
   InventoryToRemove = MountedPawn.FindInventoryType(objMountWeapon);

   if (InventoryToRemove !=None){
      InventoryToRemove.DetachFromPawn(MountedPawn);
      MountedPawn.DeleteInventory(InventoryToRemove);
   }

   //switch back to the heavy weapon, if not already holding it
   if (MountedPawn.Weapon.IsA('HeavyWeapon') == false){
        if (OriginalWeapon != None){
            ChangeWeapon(MountedPawn, OriginalWeapon);
        }
   } else {
      //Change the Playerview offset back to what it was
      WeaponToMount.IdleAnim = WeaponToMount.default.IdleAnim;
      WeaponToActivate = AdvancedWeapon(MountedPawn.Weapon);
      WeaponToActivate.PlayerViewOffset = MountedPawn.Weapon.default.PlayerViewOffset;// - PlayerViewOffset;
      WeaponToActivate.FireOffset= MountedPawn.Weapon.default.FireOffset;// - FireOffset;
      WeaponToActivate.ModifyShake(1);
      WeaponToActivate.SetInfiniteAmmo(false);
   }


   //Step back the opposite direction of the mount
   PlaneRot.Yaw = Rotation.Yaw;
   PlaneRot.Pitch = 0;
   PlaneRot.Roll = 0;
   // PlaneRot.Yaw = MountedPawn.Rotation.Yaw;
   VectPlaneRot = vector(PlaneRot) + vect(1,1,1);
   MountedPawn.SetLocation(Location + (UnMountOffset >> PlaneRot));


   MountedPawn.Controller.SetLocation(MountedPawn.Location);
   MountedPawn.bBlockActors = MountedPawn.default.bBlockActors;
   MountedPawn.bBlockPlayers = MountedPawn.default.bBlockPlayers;
   MountedPawn.bCollideWorld = MountedPawn.default.bCollideWorld;
   bBlockZeroExtentTraces = true;
   AdvancedPlayerController(MountedPawn.Controller).DoUnMount();

   //Shout it loud, shout it proud, YOU'VE UNMOUNTED!
   TriggerEvent( UnMountedEvent, self, None );
   MountedPawn = None;
   bInUse = false;

   return true;
}

/****************************************************************
 * MultiTimer
 ****************************************************************
 */
function MultiTimer(int ID){
   if (ID == MOUNT_DELAY){
        bCanMount = true;
   }
   Super.MultiTimer(ID);
}
/****************************************************************
 * ChangeWeapon
 * This is here because I am not sure this is the best way to change
 * the weapon, so I thought I would centralize rather than spread my
 * ignorance across the code.
 ****************************************************************
 */
function ChangeWeapon(Pawn P, Weapon W){

   //Weapon is already up
   If (P.Weapon == W){
      return;
   } else {

      P.Weapon.PutDown();
      //Switch weapon
      P.PendingWeapon = W;
      P.ServerChangedWeapon(P.Weapon, W);
   }
}

/****************************************************************
 * DrawHUD
 * Just here so MasterMountPoints can draw their kill timer to the
 * screen to scare the player into action.
 ****************************************************************
 */
function DrawHUD(Canvas C){
   //Log ("Call to drawHUD in the mount point");
}


/****************************************************************
 * ForcedMount
 * Suck the player into the mount no matter where they be
 ****************************************************************
 */
function ForcedMount(){
      local AdvancedPlayerController pc;

      if (MountedPawn != None){
         return;
      }

      //turn it on
      GotoState('Enabled');

      //let the playercontroller do it's mount stuff
      pc = AdvancedPlayerController(Level.GetLocalPlayerController());
      pc.Pawn.SetLocation(Location);
      //      pc.DoMount(self);
      DoMount(pc.Pawn);
}


/****************************************************************
 * TurnEmitterOnOff
 ****************************************************************
 */
function TurnIndicatorsOnOff(bool Active){

   TurnEmitterOnOff(Active);
   TurnShaderOnOff(Active);
}

/****************************************************************
 * TurnEmitterOnOff
 ****************************************************************
 */
function TurnEmitterOnOff(bool Active){
    if (EmitterType == None) return;
    if (Active) {
        ActiveEmitter = Spawn(EmitterType);
        if ( ActiveEmitter != None ) {
            ActiveEmitter.bHardAttach = true;
            ActiveEmitter.SetBase(self);
        }
    } else {
        if ( ActiveEmitter != None ) {
            ActiveEmitter.Destroy();
        }
   }
}

/****************************************************************
 * TurnShaderOnOff
 ****************************************************************
 */
function TurnShaderOnOff(bool Active) {
    local Material MatHolder;
    local int i;


    if (ActiveShader == None) return;
    CopyMaterialsToSkins();

    //if it should be turned on
    if (Active){
        for (i = 0; i < Skins.Length; ++i) {
            if (Skins[i] == None) { break; }
            //make a new material out of the glowing shader
            MatHolder = Skins[i];
            //make the diffuse channel of the shader into existing
            //skin
            if (MatHolder != ActiveShader){
               ActiveShader.Diffuse = MatHolder;
            }
            Skins[i] = ActiveShader;
        }
    }
    else {
        CopyMaterialsToSkins();
    }
    /*
    //otherwise turn it off
    else {
        for (i = 0; i < Skins.Length; ++i) {
            if (Skins[i] == None) break;
            current = Shader( Skins[i] );
            if ( current == None || current.diffuse == None ) break;
            Skins[i] = current.diffuse;
        }
    }
    */



}



//===========================================================================
// Events
//===========================================================================


/****************************************************************
 * Touch
 *
 ****************************************************************
 */
function Touch(actor Other){

   //if (IsInState('Enabled') == true){
   //   Other.Instigator.ClientMessage( MountMessage );
   //}
}


/****************************************************************
 * Trigger
 *
 ****************************************************************
 */
event TriggerEx( Actor Other, Pawn EventInstigator, Name Handler ) {

   Log (name $ ": " $ Handler);

   //Enable the mount
   if (Handler == hEnableMount) {
      GotoState('Enabled');
   }
   //disable the mount
   else if (Handler == hDisableMount){
      GotoState('Disabled');
   }

   //Suck the player in (if they are not in already)
   else if (Handler == hForceMount){
      ForcedMount();
   }

   //Turn the Player Lock on
   else if ( Handler == hEnableLock ) {
      LockPlayer = true;
   }

   // Turn the player lock off
   else if ( Handler == hDisableLock ) {
      LockPlayer = false;
   }
}



//===========================================================================
// States
//===========================================================================


/****************************************************************
 * Enabled
 ****************************************************************
 */
auto state() Enabled {


   /**********************************************************
    * BeginState
    **********************************************************
    */
   function BeginState(){
      TurnIndicatorsOnOff(true);
      bBlockZeroExtentTraces = true;
      bProjTarget = true;
      bHidden=false;
   }

 Begin:


}


/****************************************************************
 * Disabled
 ****************************************************************
 */
state() Disabled{

   /*************************************************************
    * DoMount
    * The function that makes the player mounted, provided that
    * the player has a heavy weapon or the mountpoint provides a
    * fixed one.
    *************************************************************
    */
   function bool DoMount(Pawn PawnToMount){
      log (name $ " Call to do mount while disabled");
      return false;
   }


   /**********************************************************
    * BeginState
    **********************************************************
    */
   function BeginState(){
      local AdvancedPlayerController thePlayer;

      //Eject the player when disabled, Note that we do this from
      //the controller to give it a chance to do it's part of the
      //unmount
      if (MountedPawn != None){
         thePlayer = AdvancedPlayerController(MountedPawn.Controller);
         if (thePlayer != None){
            thePlayer.DoUnMount();
            DoUnMount();
         }
      }

      TurnIndicatorsOnOff(false);
      bBlockZeroExtentTraces = true;
      bProjTarget = false;
      if (! bMeshVisibleWhenDisabled){
         bHidden=true;
      }
   }



 Begin:

}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     PitchRange=90
     YawRange=90
     UnMountOffset=(X=-100.000000,Z=100.000000)
     MountMessage="Press Action to enter mount."
     bMeshVisibleWhenDisabled=True
     DamageModifier=0.200000
     shakeModifier=0.500000
     bCanMount=True
     hEnableMount="ENABLE_MOUNT"
     hDisableMount="DISABLE_MOUNT"
     hEnableLock="ENABLE_LOCK"
     hDisableLock="DISABLE_LOCK"
     hForceMount="FORCE_MOUNT"
     iActionablePriority=10
     bHasHandlers=True
     bHardAttach=True
     bCollideActors=True
     bBlockPlayers=True
     bDirectional=True
}
