// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*******************************************************************************
 * AdvancedWeapon - adds a bunch of fancy weapon features to the base unreal
 *      system, including:
 *          - aimed mode
 *          - mountable
 *          - movement affected accuracy
 *
 * @Rev$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class AdvancedWeapon extends Weapon
     config(user)
     implements( HudDrawable );



var bool brenderlog;

var string PawnAnimationPackage;
var name FireAnimName;
var name StandIdleAnimName;
var name CrouchIdleAnimName;
var name HitAnimName;

var class<Ammo> AmmoPickUpClass;

var bool bFirstTick;

var(Action) enum EWeaponMode{
    WM_Rapid,
    WM_Single
} WeaponMode;

var bool bRenderWeaponMesh;
var float SingleFireRate;
var float RapidFireRate;

var class<Emitter> TraceEmitterClass;
var class<Emitter> MuzzleFlashEmitterClass;
var class<Emitter> ThirdPersonMuzzleFlashClass;
var class<Emitter> BulletEjectEmitterClass;

var() float MinTimeBetweenEffects;
var float lastEffectTime;
var Emitter MuzzleFlashEmitter;
var Emitter ThirdPersonMuzzleFlashEmitter;


var (Events) editconst const Name GeneralZeroAmmoEvent;

var int NumShakes;
var bool bInfiniteAmmo;
var Sound ReloadSound;
var Sound EmptySound;
var bool bAllowedToAutoSwitch;

var bool bWeaponKicks;
var rotator WeaponKickDir;
var int WeaponKickMag;

var int EffectiveRange;

var vector MountedOffset, MountedFireOffset;

//accuracy related variables
const iMaxInaccuracy = 0.5;    //worst it can get
var float iMinInaccuracy;
var float iInaccuracy;       //current local inaccuracy value
var float iInaccuracyDelta;  //rate of increase
var float iInaccuracyRate;  //number of ticks before increase
var int iInaccCount;        //'tick' counter
var float iAccuracyAffector; //other things effect
var float iInaccuracyDecline;

//multipliers
var float iMountAccuracyModifier;
var float iAimingAccuracyModifier;
var bool bCanDamageSelf;

// range (in UU) at which weapon spread applies.
const c = 1000;
// diameter (in UU) in which the hits from this weapon will
// land, at a range of c UU.
var float HitSpread;

//aimed features
//
//TODO: should probably have specific anims for aimed-mode, to allow for
//      view-offset differences.
var bool     bAimable;
var() vector AimedOffset;
var int      AimedFOV;
var float    AimedWalkingSpeed;
var bool bAiming;

var name FireAnim;
var name ReloadAnim;
var name SelectAnim;
var name DeselectAnim;
var name IdleAnim;
var name MountedIdleAnim;

// hud stuff
var Material StaticReticule;
var int ReticuleSize;
var float reticuleScale;

var Material AccuracyIndicator;
var int AccyIndicatorSize;
// the inventory icon...
var Material icon;
var Material AmmoBackGround;
var int AmmoBackWidth;
var int AmmoBackLength;
var int AmmoBackX;
var int AmmoBackY;


// size of the material (in texels)
var int IconWidth;
var int IconHeight;
// offset of the top-left corner of the icon
var int IconOffsetU;
var int IconOffsetV;
var Localized String OfficialName;

//var bool bSecondaryAudioMode;
var Sound SecondaryAudioSound;

var bool bExcludeFromWeaponCycle;
var name TraceFireBone;
var name MuzzleFlashBone;
var name BulletEjectBone;
var byte bLastFireState;

// evil alt-fire hacks.
var bool bIgnoreNextAltFire;
var bool bAltFireDoesntFire;

//
var struct TargetInfo {
    var Actor  target;     // the actual actor
    var float  updateTime; // time of last update (in secs since level start)
    var String caption;    // a caption, suitable for display to player
    var String actionTip;  // the actionable item tip
} TargetActorInfo;

const TargetLossDelay = 0.5;
const MAX_TARGET_DIST = 150;
const TARGET_UPDATE   = 92838;
var int AMMO_CENTER;
var int AMMO_Y;
const NUM_CHANNELS    = 16;

var localized string InfiniteAmmoTxt;
var travel bool bGaveAmmo;

var bool bTravelling;
var vector debugstart;
var vector debugend;
var bool bDrawdebug;


function TravelPreAccept(){
   bTravelling = true;
   super.TravelPreAccept();
}

function TravelPostAccept(){
  if ( self == Pawn(Owner).Weapon )
        BringUp();
    else GotoState('');

   bTravelling = false;
}


/*****************************************************************
 * GiveAmmo
 * Overridden to fix the travel situation when the system seems
 * to re-give ammunition defaults at the beginning of each level
 *****************************************************************
 */
function GiveAmmo(Pawn Other){

    local ammunition tempAmmo;
    if ( AmmoName == None ) return;
    tempAmmo = Ammunition(Other.FindInventoryType(AmmoName));
    if (tempAmmo != none){
      AmmoType = tempAmmo;
    }
    //don't spawn ammo for travelled weapons
    if ( AmmoType == None && bTravelling == false){
       AmmoType = Spawn(AmmoName);
       Other.AddInventory(AmmoType);                         // and add to player's inventory
       AmmoType.AmmoAmount = PickUpAmmoCount;
    }
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
   iInaccuracy = iMinInaccuracy;
   Super.PostBeginPlay();

   // fall back to the 1st person tracer
  // if ( ThirdPersonMuzzleFlashClass == None ) {
//       ThirdPersonMuzzleFlashClass = TraceEmitterClass;
   //}
}


function PostNetBeginPlay(){

    if (iInaccuracy == 0){
        iInaccuracy = iMinInaccuracy;
    }
}

/*****************************************************************
 * PostLoad
 * Try to patch things up after a save game is loaded.
 *****************************************************************
 */
function PostLoad() {
    local int i;
    local AdvancedPawn ap;

    // and this little hack is to un-stick any WaitForAnimEnds...
    for ( i = 0; i < NUM_CHANNELS; ++i ) {
       AnimEnd(i);
    }

    //hack to ensure that the first person weapon has the correct
    //offsets if the game is loaded while it is mounted.
    ap = AdvancedPawn(Level.GetLocalPlayerController().Pawn);
    if (ap.objMount!=None){
       if (ap.objMount.WeaponToMount == self){

          //Log ("PlayerViewOffset for weapon was: " $ PlayerViewOffset);
         // Log ("Mount's PVO: "$ ap.objMount.PlayerViewOffset);
          //Log ("Mounted off set for weapon is: " $ MountedOffset);


          PlayerViewOffset = default.PlayerViewOffset +
              ap.objMount.PlayerViewOffset +
             MountedOffset;

          //Log ("PlayerViewOffset for weapon is: " $ PlayerViewOffset);

       }
    }
}

/**
 * Spawn emitters for use throughout the lifetime of this weapon.
 */
//simulated function InitEffects() {
simulated function ClientMuzzleFlash(){

    local int i;
       // this is cheap, so we don't need to limit it...
    if ( MuzzleFlashEmitter != None ) {
        MuzzleFlashEmitter.Trigger( self, none );
    }
    else if ( MuzzleFlashEmitterClass != None ) {
        MuzzleFlashEmitter = Spawn( MuzzleFlashEmitterClass,,,GetBoneCoords(MuzzleFlashBone).Origin );
        for ( i = 0; i < MuzzleFlashEmitter.emitters.length; ++i ) {
            MuzzleFlashEmitter.emitters[i].ResetOnTrigger  = true;
            MuzzleFlashEmitter.emitters[i].AutoDestroy     = false;
            MuzzleFlashEmitter.emitters[i].TriggerDisabled = false;
        }
        MuzzleFlashEmitter.AutoDestroy = false;
        AttachToBone(MuzzleFlashEmitter, MuzzleFlashBone);
    }
   //TODO @@@ add tracer here attached to the first person weapon?

}

/*****************************************************************
 * SetInfiniteAmmo
 *****************************************************************
 */
function SetInfiniteAmmo(bool onOff){
   bInfiniteAmmo = onOff;
}

/**
 * Cycle aimed modes.
 */
simulated function ToggleAimedMode() {

 //   Log ("ToggleAimedMode");

    if ( !bAiming ) {
        StartAimedMode();

    } else {
       EndAimedMode();
    }
}



/**
 * Put the controller/pawn/weapon into aimed-mode, intended to
 * represent the player steadying their aim and peering down the
 * sights of the weapon.
 *
 * @param AimedFOV  The FOV to zoom to.  When omitted, uses the
 *                  weapon's AimedFOV.
 */
simulated function StartAimedMode( optional int AimedFOV ) {
    local AdvancedPlayerController pc;
    pc = AdvancedPlayerController( instigator.controller );
    if ( pc == None ) return;

    if (AimedFOV <= 0) AimedFOV = self.AimedFOV;
    bAiming = true;
    pc.StartZoomEx( AimedFOV );
    pc.SetSensitivityTemp(1);
    PlayerViewOffset = default.PlayerViewOffset + AimedOffset;
    FireOffset = default.FireOffset + AimedOffset;

    instigator.GroundSpeed = AimedWalkingSpeed;
    iAimingAccuracyModifier = default.iAimingAccuracyModifier * 0.5;
    WeaponMode = WM_Single;
    TraceDist = default.TraceDist * 2;
}

/**
 * Puts the controller/pawn/weapon into the default, non-aimed mode.
 */
simulated function EndAimedMode() {
    local AdvancedPlayerController pc;
    pc = AdvancedPlayerController( instigator.controller );
    if ( pc == None ) return;

    bAiming = false;
    pc.StartUnZoom();
    pc.SetSensitivityTemp(class'PlayerInput'.default.MouseSensitivity);
    PlayerViewOffset = default.PlayerViewOffset;
    FireOffset = default.FireOffset;

    instigator.GroundSpeed = instigator.default.GroundSpeed;
    FireOffset = default.FireOffset;
    iAimingAccuracyModifier = default.iAimingAccuracyModifier;
    WeaponMode = default.WeaponMode;
    TraceDist = default.TraceDist;
}


/****************************************************************
 * BotFire
 ****************************************************************
 */
function bool BotFire(bool bFinished, optional name FiringMode){
 AdvancedAmmunition(AmmoType).bUnderBotControl = true;
   return Super.BotFire(bFinished, FiringMode);
}

/*****************************************************************
 * Fire
 * Overridden to set infinite ammo in the ammo, you don't have ammo
 * when you first get the weapon, so we reconsider everytime we fire
 * the weapon
 *****************************************************************
 */
simulated function Fire(float Value){

    //Log(self $ "AdvancedWeapon fire");

    // if you press fire while alt-fire is down, you get an extra
    // alt-fire call, which can confuse things...
    if ( instigator.controller.bAltFire == 1 ) bIgnoreNextAltFire = true;

   //Done before the call to super cause super does the subtraction of
   //ammo, so we want to know if we are infinite before!
   if (AmmoType == None){
      Log("ERROR: This weapon has no ammo type");
      return;
   }
   AdvancedAmmunition(AmmoType).Infinite = bInfiniteAmmo;

   if (EmptySound != None && !HasAmmo() && !bInfiniteAmmo){
      PlaySound(EmptySound, SLOT_None, 1.0);
   }

   //************************
   // Super.Fire,
   // need to control when reload count is decremented
   //*************************
   if ( !HasAmmo() && !bInfiniteAmmo){
      return;
   } else if (HasAmmo() && ReloadCount == 0){
      GotoState('reloading');
      return;
   }


   if ( !RepeatFire() ){
      ServerFire();
      GotoState('NormalFire');
   } else if ( StopFiringTime < Level.TimeSeconds + 0.3 ){
         StopFiringTime = Level.TimeSeconds + 0.6;
         ServerRapidFire();
   }
   if ( Role < ROLE_Authority ){
      if (!bInfiniteAmmo){   //<- here
//         ReloadCount--;
      }
      LocalFire();
      GotoState('ClientFiring');        //@@@
   }

   //let anyone know that the gun is out of ammo
   if ( !HasAmmo() && !bInfiniteAmmo){
      TriggerEvent( GeneralZeroAmmoEvent, self, None);
   }
}

/*****************************************************************
 *
 *****************************************************************
 */
simulated function AltFire( float Value ) {
                // Log( self @ "ALTFIRE:" @ value @ instigator.controller.bAltFire  )    ;
    if ( bAimable ) ToggleAimedMode();
    //if not aiming then do parent stuff
    if ( !bAltFireDoesntFire ) super.AltFire(Value);
    ServerAltFire();
}

/*****************************************************************
 *
 *****************************************************************
 */
function ServerAltFire() {
   if ( bIgnoreNextAltFire ) {
       bIgnoreNextAltFire = false;
       return;
   }
//   if ( bAimable ) ToggleAimedMode();
   Super.ServerAltFire();
}

/*****************************************************************
 * WeaponKick
 * If you don't provide a direction then offset is random
 *****************************************************************
 */
simulated function WeaponKick(int Magnitude, rotator Direction){

   local rotator HitOffset;
   local AdvancedPlayerController apc;

   if (Magnitude <= 0 || bWeaponKicks == false
       || !Instigator.IsHumanControlled()){
      return;
   }

   apc = AdvancedPlayerController(Instigator.Controller);

   if (Direction.Pitch ==0 && Direction.Yaw == 0){
      HitOffset.Pitch = FRand() * 2 * Magnitude - Magnitude;
      HitOffset.Yaw   = FRand() * 2 * Magnitude - Magnitude;
      apc.SetRotation(apc.GetViewRotation() + HitOffset);
   } else {
      apc.SetRotation(apc.GetViewRotation() +
                             Magnitude * HitOffset);
   }

}


/*****************************************************************
 * NeedsToReload
 * Overridden for obvious reasons
 *****************************************************************
 */
simulated function bool NeedsToReload(){
   if (bInfiniteAmmo || reloadcount == default.reloadcount){
      return false;
   }
   return Super.NeedsToReload();
}

/*****************************************************************
 * ServerFire
 * Overridden to better control the reload count
 *****************************************************************
 */
function ServerFire()
{
   if ( AmmoType == None ){
      // ammocheck
     // log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAmmo(Pawn(Owner));
   }
   if ( HasAmmo() || bInfiniteAmmo){
      GotoState('NormalFire');
      if (!bInfiniteAmmo){
         ReloadCount--;
      }
      if ( AmmoType.bInstantHit ){
         TraceFire(TraceAccuracy,0,0);
      }else{
         ProjectileFire();
      }
      LocalFire();
   }
}

/*****************************************************************
 * LocalFire
 * Overridden to provide additional shaking
 *****************************************************************
 */
simulated function LocalFire()
{
   local PlayerController P;
   local AdvancedPlayerController ap;
   bPointing = true;

   if ( (Instigator != None) && Instigator.IsLocallyControlled() ){
      P = PlayerController(Instigator.Controller);
      if (P!=None) {
         // P.ShakeView(ShakeTime,ShakeMag,ShakeVert,120000,ShakeSpeed, NumShakes);
      }

      ap = AdvancedPlayerController(P);
      if ( ap != None && ap.bSecondaryAudioMode==true
           && SecondaryAudioSound != none ) {
         PlaySound(SecondaryAudioSound, SLOT_None, 1.0);
      }

      else if ( FireSound != none) {
          PlaySound(FireSound, SLOT_None, 1.0);
      }
   }

   if ( Affector != None ) Affector.FireEffect();
   ClientMuzzleFlash();
   PlayFiring();


   if (WeaponMode == WM_Single && Instigator.IsHumanControlled()) {
      Instigator.Controller.bFire = 0;
   }

  // Instigator.Controller.bFire = 1; //cause this isn't replicated to the client
}

/*****************************************************************
 * ModifyShake
 *
 * So things like MountPoints can make it less shakey!
 *****************************************************************
 */
function ModifyShake(float shakeModifier){
   shaketime  = default.Shaketime  * shakeModifier;
   shakevert  = default.shakevert  * shakeModifier;
   shakespeed = default.shakespeed * shakeModifier;
   shakemag   = default.shakeMag   * shakeModifier;
   numshakes  = default.numShakes  * shakeModifier;
   iMountAccuracyModifier = shakeModifier;

   //less shake means more distance
   TraceDist = default.TraceDist * (1/shakeModifier);
}

/*****************************************************************
 * ToggleCrappyMode
 *****************************************************************
 */
//function ToggleCrappyMode(){
// bSecondaryAudioMode = !bSecondaryAudioMode;
//}

/*****************************************************************
 * WeaponChange
 * otherwise aimed mode persists after switching a weapon
 *****************************************************************
 */
 //NOTE: removed for now to allow sways to be stacked (e.g. infection sway +
 //      rifle sway).
//
// Change weapon to that specificed by F matching inventory weapon's Inventory Group.
simulated function Weapon WeaponChange( byte F, bool bSilent )
{
    local Weapon newWeapon;

    if ( InventoryGroup == F )
    {
        if ( !HasAmmo() )
        {
            if ( Inventory == None )
                newWeapon = None;
            else
                newWeapon = Inventory.WeaponChange(F, bSilent);
            if ( !bSilent && (newWeapon == None) && Instigator.IsHumanControlled() )
                Instigator.ClientMessage( ItemName$MessageNoAmmo );
            return newWeapon;
        }
        else
            return self;
    }
    else if ( Inventory == None )
        return None;
    else
        return Inventory.WeaponChange(F, bSilent);
}






/*****************************************************************
 *
 *****************************************************************
*/
function Finish()
{
    local bool bForce, bForceAlt;

    if (WeaponMode == WM_Rapid){
       WeaponKick(WeaponKickMag, WeaponKickDir);
    }

    if ( NeedsToReload() && Ammotype.HasAmmo() )
    {
        GotoState('Reloading');
        return;
    }

    bForce = bForceFire;
    bForceAlt = bForceAltFire;
    bForceFire = false;
    bForceAltFire = false;

    if ( bChangeWeapon )
    {
        GotoState('DownWeapon');
        return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
        GotoState('');
        return;
    }

    if ( !Instigator.IsHumanControlled() ){
      if (bAllowedToAutoSwitch){
         if ( !HasAmmo() ){
           Instigator.Controller.SwitchToBestWeapon();
           if ( bChangeWeapon )
               GotoState('DownWeapon');
           else
               GotoState('Idle');
           return;
        }
      }

       if ( AIController(Instigator.Controller) != None ) {
         if ( !AIController(Instigator.Controller).WeaponFireAgain(AmmoType.RefireRate,true) ) {
            if ( bChangeWeapon )
               GotoState('DownWeapon');
            else
               GotoState('Idle');
            }
            return;
       }

    }

    if (bAllowedToAutoSwitch == true){
      if ( !HasAmmo() && Instigator.IsLocallyControlled() ) {
        SwitchToWeaponWithAmmo();
        return;
      }
    }

    if ( Instigator.Weapon != self )
        GotoState('Idle');
    else if ( (StopFiringTime > Level.TimeSeconds) || bForce || Instigator.PressingFire() ){
        //Global.ServerFire();
    } else if ( bForceAlt || Instigator.PressingAltFire() )
        CauseAltFire();
    else
        GotoState('Idle');
}


/*****************************************************************
 *
 *****************************************************************
 */
function SwitchToWeaponWithAmmo(){
   if (bAllowedToAutoSwitch == true){
      super.SwitchToWeaponWithAmmo();
   }
}

/*****************************************************************
 * DropFrom
 * Overridden to allow the player to drop weapons, and the rest of the
 * NPCs to drop ammo.
 *****************************************************************
 */
function DropFrom(vector StartLocation){

   local Pickup P;

   //from Weapon
   AIRating        = Default.AIRating;
   bMuzzleFlash    = false;
   ReloadCount     = DetermineAmmoCount();
//   PickupAmmoCount = 0; handled in give ammo
   bInfiniteAmmo   = default.bInfiniteAmmo;

  //From Inventory
   if ( Instigator != None )
   {
      DetachFromPawn(Instigator);
      Instigator.DeleteInventory(self);
                  // Log( self @ "deleting inventory" )    ;
   }

   //turn off the tracing
   SetDefaultDisplayProperties();
   GotoState('');

   //weapon
   if (ShouldSpawnWeapon()){
      P = spawn(PickupClass,,,StartLocation);
   //ammo
   } else {
      P = spawn(AmmoPickupClass,,,StartLocation);
   }

               // Log( self @ "Spawned a pickup" )    ;
   if ( P == None )
   {
//      destroy(); if you destroy a weapon that doesn't spawn a pickup (like fists)
// than you end up destroying the weapon before a client can put it down in network play
      return;
   }

   Instigator = None;
   P.InitDroppedPickupFor(self);
   P.Velocity = Velocity;
   Velocity = vect(0,0,0);
}


/*****************************************************************
 * HandlePickupQuery
 *
 * Significantly simplified version of handlepickupQuery that
 * apparently returns true if it "handled" the pickup. Note, this is
 * overridden to allow the player to pickup all weapons even if they
 * already have one of the type they are attempting to pick up.
 *****************************************************************
 */
function bool HandlePickupQuery( Pickup Item ){

   if (Item.InventoryType == Class){
      Item.AnnouncePickup(Pawn(Owner));
      return false;
   }
   if ( Inventory == None ){
      return false;
   }

   return Inventory.HandlePickupQuery(Item);
}


/*****************************************************************
 * DetermineAmmoCount
 *
 *****************************************************************
 */
function int DetermineAmmoCount(){

   local float clipCount;

   if (Instigator.Controller.bIsPlayer == true ){ //== Level.GetLocalPlayerController()){
      //player returns a real value
      return ReloadCount;
   } else {
      //bots return at least half a clip
      clipCount = (0.5 + FRand()) * default.ReloadCount;
      return int(clipCount);
   }
}

/*****************************************************************
 * ShouldSpawnWeapon
 *
 *****************************************************************
 */
function bool ShouldSpawnWeapon(){

   //are you the player?
   //  if (Instigator.Controller == Level.GetLocalPlayerController()){
      return true;
      //} else {
      //return false;
      //}
}



//===========================================================================
// Accessors
//===========================================================================



/*****************************************************************
 * SetMode
 *
 * Sets the mode of the weapon to single shot, or rapid fire,
 * implemented in those classes that have two fire modes.
 *****************************************************************
 */
function ToggleMode(){

   if (WeaponMode == WM_Rapid){
      WeaponMode = WM_Single;
   } else if (WeaponMode == WM_Single){
      WeaponMode = WM_Rapid;
   }

}


//===========================================================================
// Animation Functions
//===========================================================================



/*****************************************************************
 * PlaySelect
 * Defines the animation to play when the player selects the weapon
 *****************************************************************
 */
simulated function PlaySelect(){
   PlayAnim(SelectAnim);
   //Log(self $ " I am playing the select anim: " $ SelectAnim);
}


/*****************************************************************
 * HasAmmo
 * Overridden to allow the weapon to consider the fact that it has
 * some ammunition stored in it as well.
 *****************************************************************
 */
simulated function bool HasAmmo(){

   //Log(self $ " has ammotype " $ AmmoType $ " " $ ReloadCount);
   if ((AmmoType !=None && AmmoType.HasAmmo()) || ReloadCount > 0) return true;
   return false;
}

/*****************************************************************
 * PlayReload
 * Defines the animation to play when the player selects the weapon
 *****************************************************************
 */
simulated function PlayReloading(){

//   if (IsInState('ClientFiring')==true){ return;}
   //Log(self $ " PlayReloading");

   if (!bInfiniteAmmo){
      PlayAnim(ReloadAnim);
      if (ReloadSound !=None){
         PlaySound(ReloadSound);
      }
   } else {
      AnimEnd(0);
   }
}

simulated function ClientForceReload(){
   super.ClientForceReload();
  // Log(self $ " Client force reload");
}

/*****************************************************************
 * TweenDown
 *****************************************************************
 */
simulated function TweenDown()
{
    local name Anim;
    local float frame,rate;

  //  Log("Tween Down");

    if ( IsAnimating() && AnimIsInGroup(0,'Select') )
    {
        GetAnimParams(0,Anim,frame,rate);
        TweenAnim( Anim, frame * 0.4 );
    } else{
        PlayAnim(DeselectAnim);
    }
   EndAimedMode();
}


/*****************************************************************
 * IncrementFlashCount
 *****************************************************************
 */
simulated function IncrementFlashCount(){
 FlashCount++;
 if ( WeaponAttachment(ThirdPersonActor) != None )
    {
//        WeaponAttachment(ThirdPersonActor).FlashCount = FlashCount;
        WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
    }
}


/*****************************************************************
 * PlayFiring
 * Calls IncrementFlashCount which handles all the stuff
 * surrounding the firing, 3rd person animation, muzzle flashes,
 * spawning discharged shells ...
 *****************************************************************
 */
simulated function PlayFiring(){

   local float iAnimRate;

   if (WeaponMode == WM_Single) {
      //      Instigator.Controller.bFire = 0; moved to anim end on
      //      the weapon so that bots will work proper!
      WeaponKick(WeaponKickMag, WeaponKickDir);
      iAnimRate = SingleFireRate;
   } else {
      iAnimRate=RapidFireRate;
   }

   // Log (self $ " AdvancedWeapon PlayFiring: " $ FireAnim);

   PlayAnim(FireAnim, iAnimRate );
   IncrementFlashCount();
}


//once bots have had a chance to decide whether to fire again, shut
//down this weapon so you have to fire it explicitly
//function Finish(){
/*
moved to local fire so the network clients can calculate it. I think the added
check for human controlled is enough to correct the issue with this F-ing up bots
   if (WeaponMode == WM_Single && Instigator.IsHumanControlled()) {
      Instigator.Controller.bFire = 0;
   }
   */

//   Super.Finish();

//}

// Find the previous weapon (using the Inventory group)
simulated function Weapon PrevWeapon(Weapon CurrentChoice,Weapon CurrentWeapon)
{
   if (bExcludeFromWeaponCycle){
      return Inventory.PrevWeapon(CurrentChoice, CurrentWeapon);
   } else {

if ( (HasAmmo() && bAllowedToAutoSwitch==true) ||
        bAllowedToAutoSwitch == false)
  {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentChoice.InventoryGroup )
        {
            if ( InventoryGroup == CurrentWeapon.InventoryGroup )
            {
                if ( (GroupOffset < CurrentWeapon.GroupOffset)
                    && (GroupOffset > CurrentChoice.GroupOffset) )
                    CurrentChoice = self;
            }
            else if ( GroupOffset > CurrentChoice.GroupOffset )
                CurrentChoice = self;
        }
        else if ( InventoryGroup > CurrentChoice.InventoryGroup )
        {
            if ( (InventoryGroup < CurrentWeapon.InventoryGroup)
                || (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup) )
                CurrentChoice = self;
        }
        else if ( (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup)
                && (InventoryGroup < CurrentWeapon.InventoryGroup) )
            CurrentChoice = self;

   }
    if ( Inventory == None )
        return CurrentChoice;
    else
        return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);

   }
}

// Find the previous weapon (using the Inventory group)
simulated function Weapon NextWeapon(Weapon CurrentChoice,Weapon CurrentWeapon)
{
   if (bExcludeFromWeaponCycle){
      return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
   } else {

  if ( (HasAmmo() && bAllowedToAutoSwitch==true) ||
        bAllowedToAutoSwitch == false)
  {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentChoice.InventoryGroup )
        {
            if ( InventoryGroup == CurrentWeapon.InventoryGroup )
            {
                if ( (GroupOffset > CurrentWeapon.GroupOffset)
                    && (GroupOffset < CurrentChoice.GroupOffset) )
                    CurrentChoice = self;
            }
            else if ( GroupOffset < CurrentChoice.GroupOffset )
                CurrentChoice = self;
        }

        else if ( InventoryGroup < CurrentChoice.InventoryGroup )
        {
            if ( (InventoryGroup > CurrentWeapon.InventoryGroup)
                || (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup) )
                CurrentChoice = self;
        }
        else if ( (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup)
                && (InventoryGroup > CurrentWeapon.InventoryGroup) )
            CurrentChoice = self;
   }
    if ( Inventory == None )
        return CurrentChoice;
    else
        return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);

   }
}


/*****************************************************************
 * BringUp
 *****************************************************************
 */
simulated function bringUp( optional Weapon prevWeapon) {
    local Pawn p;

    super.bringUp( prevWeapon );
    // only activate target system when being used by the player
    p = Pawn( owner );
    //    if ( p != None && PlayerController( p.controller ) != None ) {
    //   SetMultiTimer( TARGET_UPDATE, 0.2, true );
    //    }
    //    else {
        targetActorInfo.target = None;
        //    }
}




function UpdateTarget(){

    local vector hitLocn, hitNorm, startTrace, endTrace, X, Y, Z;
    local Actor hitActor;
    local bool bValidTarget;
    local AdvancedPawn ap;
    local Controller c;

    //don't do the trace while in a mountpoint.
    if (Instigator == none){ return; }
    c = Instigator.Controller;
    if ( c == None ) return;
    ap = AdvancedPawn(c.Pawn);
    if ( ap == None || ap.objMount != None ) return;

    // do a trace into the scene to see if the weapon is pointed at
    // something interesting...
    GetAxes( Instigator.GetViewRotation(), X, Y, Z );
    //StartTrace = GetFireStart( X, Y, Z );
    StartTrace = GetTraceStart(X,Y,Z);
    EndTrace   = StartTrace + X * MAX_TARGET_DIST;
    hitActor   = Trace(hitLocn, hitNorm, endTrace, startTrace, true);
    bValidTarget = false;
    if ( hitActor == None ) {
       // bValidTarget is still false
    }
    else if ( isRelevantTarget(hitActor) ) {
       bValidTarget = true;
       targetActorInfo.target     = hitActor;
       targetActorInfo.updateTime = Level.timeSeconds;
       setTextFields( targetActorInfo, hitActor );
    }

    if ( ! bValidTarget ) {
       // don't forget the old target right away...
       if ( Level.timeSeconds - targetActorInfo.updateTime
            > TargetLossDelay ) {
          targetActorInfo.target = None;
          setTextFields( targetActorInfo, none );
            }
    }

}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer( int timerID ) {
   super.MultiTimer( timerID );
}


/*****************************************************************
 * IsRelevantTarget
 * Returns true if the actor is one that should be targeted by the weapon.
 *****************************************************************
 */

function bool isRelevantTarget( Actor a ) {
  return ( Pawn(a) != None || a.getActionablePriority(Instigator.Controller) >= 0 );
}


/*****************************************************************
 * SetTextFields
 * Sets the various text fields in targetInfo to appropriate values
 * for the targeted actor.
 *****************************************************************
 */
function setTextFields( out TargetInfo targetInfo, Actor a ) {
    local AdvancedPawn ap;

    // handle actionable actors...
    if ( a != None && a.getActionablePriority(Instigator.Controller) >= 0 ) {
        targetInfo.actionTip = a.getActionableMessage(Instigator.Controller);
    }
    else {
        targetInfo.actionTip = "";
    }
    // handle pawns w/ names...
    ap = AdvancedPawn( a );
    if ( ap != None ) {
        targetInfo.caption = ap.HudCaption;
    }
    else {
        targetInfo.caption = "";
    }
}

/*****************************************************************
 * AffectAccuracy
 * One slot to affect the accuracy, currently the controller is the
 * only thing that uses this.
 *****************************************************************
 */
simulated function AffectAccuracy(float Affector){
   iAccuracyAffector = Affector;
}


/*****************************************************************
 * SetAccuracy
 *****************************************************************
 */
simulated function SetAccuracy(){


    //Log("SetAccuracy: " $ iInaccuracy);

   //half comes from Weapon inaccuracy, half comes from the movement
   TraceAccuracy = iInaccuracy + iAccuracyAffector;

   //The hit spread is affected by position and aiming
   HitSpread = default.HitSpread * iMountAccuracyModifier
    * iAimingAccuracyModifier;

}


/*****************************************************************
 * CanAttack
 * An idealized version of the actual shot, to see if it's worth
 * trying a real shot.
 *
 * Based on the Engine.Weapon version, but this one actually uses the
 * same vectors as TraceFire.
 *****************************************************************
 */
function bool CanAttack(Actor Other)
{
    local float MaxDist, CheckDist, rangeToTarget;
    local vector HitLocation, HitNormal,X,Y,Z;
    local vector start, end;
    local actor HitActor;

    if ( (Instigator == None) || (Instigator.Controller == None) )
        return false;

    if ( AdvancedPawn(Instigator).IsInState('ThrowingGrenade') == true){
       return false;
    }

    MaxDist       = MaxRange;
    rangeToTarget = VSize(Instigator.Location - Other.Location);
    // check that the target is within visual range
    if ( rangeToTarget > instigator.sightRadius ) {
                    // Log( self @ "target" @ other @ "beyond visual range" @ rangeToTarget @ instigator.sightRadius  )    ;
        return false;
    }
    // check that target is within range
    if ( AmmoType.bInstantHit ) MaxDist = TraceDist;
    if ( rangeToTarget > MaxDist ) return false;

    // check that can see target
    //FIXME if ( !Instigator.Controller.LineOfSightTo(Other) ) return false;

    // check that would hit target, and not a friendly
    GetAxes(Instigator.GetViewRotation(), X, Y, Z);
    start = GetTraceStart(X,Y,Z);
    end   = GetTraceFireEnd( X, Y, Z, start, 0 );
    if ( AmmoType.bInstantHit ) {
        HitActor = Trace( HitLocation, HitNormal, end, start, true );
    }

    else {
        // for non-instant hit, only check partial path (since others
        // may move out of the way)
        CheckDist = FClamp( AmmoType.ProjectileClass.Default.Speed,
                            600, VSize(Other.Location - Location) );
        HitActor
            = Trace( HitLocation, HitNormal,
                     end,
                     //start + CheckDist
                     //  * Normal(Other.Location + Other.CollisionHeight * vect(0,0,0.7) - Location),
                     start, true );
    }

    if ( (HitActor == None) || (HitActor == Other)
         || ( (Pawn(HitActor) != None)
              && !Instigator.Controller.SameTeamAs(Pawn(HitActor).Controller) ) ) {
        return true;
    }
    return false;
}

/*****************************************************************
 * Slight variation on basic trace fire, that makes the effect of the
 * accuracy parameter the same regardless of the weapon's range.
 *
 * @param inaccuracy - [0..1] representing the proportion of the
 *                     weapon's spread the randomize this shot over.
 *****************************************************************
 */
function TraceFire( float inaccuracy, float yOffset, float zOffset ) {
    local vector hitLocation, hitNormal, startTrace, endTrace;
    local vector X, Y, Z;
    local actor Other;
    local Material HitMaterial;

    Owner.MakeNoise(1.0);
    GetAxes(Instigator.GetViewRotation(), X, Y, Z);
    StartTrace = GetTraceStart(X, Y, Z);
    endTrace   = getTraceFireEnd(X, Y, Z, startTrace, inaccuracy);
    Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,,HitMaterial);

    AdvancedAmmunition(AmmoType).ProcessTraceHitOnMat(self,Other,HitLocation,
                             HitNormal,X,Y,Z,HitMaterial);
}

/*****************************************************************
 * GetTraceStart
 *****************************************************************
 */
function vector GetTraceStart(vector X, vector Y, vector Z)
{
   return (Instigator.Location + Instigator.EyePosition());
}



/*****************************************************************
 * GetTraceFireEnd
 * @param X,Y,Z      - local basis vectors of instigator
 * @param startTrace - location in worldspace that the shot starts from
 * @param useInaccuracy - add randomness to the shot.
 *****************************************************************
 */
function vector getTraceFireEnd( vector X, vector Y, vector Z,
                                 vector startTrace,
                                 optional float inaccuracy ) {
    local vector traceDir;
    local float error;
    if ( inaccuracy <= 0 ) error = 0;
    else error = 2 * AimError;
    X = Vector( Instigator.AdjustAim( ammoType, startTrace, error ) );
    traceDir = (c * X);
    if ( inaccuracy > 0 ) {
        traceDir = traceDir
            + (inaccuracy * (FRand()-0.5) * hitSpread) * Y
            + (inaccuracy * (FRand()-0.5) * hitSpread) * Z;
    }
    traceDir = Normal( traceDir );
    return (startTrace + (traceDir * TraceDist));
}


/*****************************************************************
 * UpdateAccuracy
 * Moved this stuff from the weapon tick, and have it called from
 * the playercontroller. Weapons do not get ticks on the client end
 * and we want the inaccuracy to be calculated by the local player controller.
 *****************************************************************
 */
simulated function UpdateAccuracy(float deltaTime){

/*
    if (Frand() > 0.9){
    Log(iMinInaccuracy);
//        Log(self $ " " $ Instigator $ " bFire:" $ Instigator.Controller.bFire $ " Inaccuracy: " $ iInaccuracy $ " iInaccuracyDelta: " $ iInaccuracyDelta $ " " $ deltaTime);
    }
  */

   //Accuracy calcs
   //-----------------------------------------------------
  if ((Instigator != None) &&
      (Instigator.Controller != None) &&
      (Instigator.Controller.bFire !=0) )
  {

     if (iInaccuracy < iMaxInaccuracy){
        iInaccuracy = iInaccuracy + (iInaccuracyDelta * deltaTime);
        iInaccuracy = Fmin(iInaccuracy, iMaxInaccuracy);
     }
   } else {
      if (iInaccuracy > iMinInaccuracy){
         iInaccuracy = iInaccuracy  - (iInaccuracyDecline * deltaTime);
         if (iInaccuracy < iMinInaccuracy) iInaccuracy = iMinInaccuracy;
      }
   }

   SetAccuracy();

}
/*****************************************************************
 * Tick
 * Currently used to provide weapon accuracy calcs which need to
 * happens all the time
 *****************************************************************
 */
function Tick(float deltaTime){

   if (bDrawdebug){
    drawdebugline(debugstart,debugend,255,0,0);
   }
   super.Tick(deltaTime);
   if (bFirstTick == false){
      bFirstTick = true;
      if (PawnAnimationPackage != ""){
        AdvancedPawn(Owner).AddAnimationPackage(PawnAnimationPackage);
      }
   }

}


/*****************************************************************
 * DrawToHud
 *****************************************************************
 */
simulated function DrawToHud( Canvas c, float scaleX, float scaleY ) {
    local float accySize, inaccuracyScale;
    local float textHeight, textWidth;

    c.SetDrawColor( 255,255,255, 0 );




    // render the weapon first, so that the indicators will get drawn
    // over it.
    if (Level.GetLocalPlayerController().Pawn.IsFirstPerson()) {
        drawFirstPersonWeapon( c, scaleX, scaleY );
    }

    // ammo/clips
    if (AmmoBackGround != None){
        c.SetPos( AmmoBackX * scaleX, AmmoBackY * scaleY );
        c.DrawTile(AmmoBackGround,AmmoBackWidth*ScaleX ,
                   AmmoBackLength*scaleY,0,0,
                   AmmoBackWidth,AmmoBackLength);
    }

    if (!bInfiniteAmmo){


       //c.font = c.MedFont;
      C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetStandardFontRef();
       c.TextSize( reloadCount, textWidth, textHeight );
       c.SetPos( (AMMO_CENTER - 8) * scaleX - textWidth, AMMO_Y * scaleY );
       c.DrawText( reloadCount );
       c.SetPos( 0, (AMMO_Y - 4) * scaleY );
       c.DrawVertical( (AMMO_CENTER) * scaleX, 48 * scaleY );
       c.SetPos( (AMMO_CENTER + 8) * scaleX, (AMMO_Y + 4) * scaleY );
//       c.font = c.smallFont;
      C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
       if (AmmoType !=None){
        c.DrawText( AmmoType.AmmoAmount );
       }
    } else {
       //c.font = c.smallFont;
      C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
       c.TextSize( InfiniteAmmoTxt, textWidth, textHeight );
       c.SetPos( (AMMO_CENTER + 50 ) * scaleX - textWidth, AMMO_Y * scaleY );
       c.DrawText( InfiniteAmmoTxt );
    }

    if (accuracyIndicator != none && class'AdvancedGameInfo'.default.bUseReticule){
       // draw the scaled accuracy indicator...
       inaccuracyScale = fmax( 0.1, (traceAccuracy * hitSpread * 0.75)
                               / accyIndicatorSize );
       accySize = accyIndicatorSize * inaccuracyScale;
       c.SetPos( (1260 - accySize) * scaleX / 2,
                 (940  - accySize) * scaleY / 2 );
       c.DrawTile( accuracyIndicator,
                   accySize * scaleX + 20 , accySize * scaleY + 20,
                   0, 0, accyIndicatorSize, accyIndicatorSize );
    }

    if (StaticReticule != None){
       // draw the static reticule over top...
       c.SetPos( (1260 - (reticuleSize * reticuleScale)) * scaleX / 2,
                 (960  - (reticuleSize* reticuleScale)) * scaleY / 2 );
       c.DrawTile( staticReticule,
                   reticuleSize * scaleX * reticuleScale, reticuleSize * scaleY * reticuleScale,
                   0, 0, reticuleSize, reticuleSize );
//       c.bCenter = true;
//       c.DrawTileScaled( staticReticule, ScaleX * 0.25, ScaleY* 0.25);
//       c.bCenter = false;
    }

    // draw text for whatever the player is targetting...
    if ( targetActorInfo.target != None ) {
        //c.Font = c.smallFont;
         C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
        c.SetPos( 550 * scaleX, 350 * scaleY );
        c.DrawText( targetActorInfo.caption );
        //c.SetPos( 550 * scaleX, 375 * scaleY );
        //c.DrawText( targetActorInfo.actionTip );
    }
}


/*****************************************************************
 * DrawDebugToHud
 *****************************************************************
 */
function DrawDebugToHud( Canvas canvas, float scaleX, float scaleY );



/*****************************************************************
 * DrawDebugHack
 * Some ugly code so that we can see where the weapon is aimed,
 * denoted with a yellow line.
 *****************************************************************
 */
function DrawDebugHack( HUD theHud ) {
    local vector start, end;
    local vector X, Y, Z;

    GetAxes( instigator.getViewRotation(), X, Y, Z );
    start    = GetTraceStart( X, Y, Z );
    end      = GetTraceFireENd( X, Y, Z, start, 0 );
    theHud.Draw3DLine( start, end,
                       class'Canvas'.static.makeColor(255, 255, 0) );
}

/*****************************************************************
 * Weapon rendering
 * Draw first person view of inventory
 * was RenderOverlays
 *****************************************************************
 */
simulated function drawFirstPersonWeapon( canvas Canvas, float scaleX, float scaleY )
{
    local rotator NewRot;
    local bool bPlayerOwner;
    local int Hand;
    local  AdvancedPlayerController PlayerOwner;
    local AdvancedPawn ap;
    local float ScaledFlash;
    local vector temp, temp2;
    local int a,b,c,d,e,f;

    DrawCrosshair(Canvas);

    if ( Instigator == None )  return;
    PlayerOwner = AdvancedPlayerController(Instigator.Controller);
    ap = AdvancedPawn(PlayerOwner.Pawn);

    if ( PlayerOwner != None ){
        bPlayerOwner = true;
        Hand = PlayerOwner.Handedness;
        if ( Hand == 2 ) return;
    }

    //Normal RenderOverlay stuff
    if ( bMuzzleFlash && bDrawMuzzleFlash && (MFTexture != None) ) {
        if ( !bSetFlashTime ) {
            bSetFlashTime = true;
            FlashTime = Level.TimeSeconds + FlashLength;
        }
        else if ( FlashTime < Level.TimeSeconds ) {
            bMuzzleFlash = false;
        }
        if ( bMuzzleFlash ) {
            ScaledFlash = 0.5 * MuzzleFlashSize * MuzzleScale
                            * Canvas.ClipX/640.0;
            Canvas.SetPos( 0.5*Canvas.ClipX - ScaledFlash + Canvas.ClipX
                           * Hand * FlashOffsetX, 0.5*Canvas.ClipY
                           - ScaledFlash + Canvas.ClipY * FlashOffsetY );
            DrawMuzzleFlash(Canvas);
        }
    } else {
        bSetFlashTime = false;
    }

    if (brenderlog){
      if(Frand() > 0.9){
         Log(self $ ": before Location: " $ self.location);
      }
    }
    if (SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) ) == false){
         SetLocation( Instigator.Location );
    }

    temp = Instigator.Location;
    a = temp.X;
    b = temp.Y;
    c = temp.Z;

    temp2 = instigator.CalcDrawOffset(self);

    d = temp2.X;
    e = temp2.Y;
    f = temp2.Z;


    if (brenderlog){
      if(Frand() > 0.9){
         Log(self $ ": after Location: " $ self.location);
      }
    }


    NewRot = Instigator.GetViewRotation();

    if ( Hand == 0 ) {
        newRot.Roll = 2 * Default.Rotation.Roll;
    } else {
        newRot.Roll = Default.Rotation.Roll * Hand;
    }

    setRotation(newRot);

    if (brenderlog){
      if(Frand() > 0.9){
         Log(self $ ": Instigator: " $ Instigator.location $ "calcdraw: " $ Instigator.CalcDrawOffset(self) $ "NewRot: " $ NewRot);
      }
    }

    //Clear the z buffer before rendering the weapon
    if (bRenderWeaponMesh) Canvas.DrawActor(self, false, true, DisplayFOV);
}

/*****************************************************************
 * PlayPostSelect
 * if you do not use idle anims then you will need to override this
 * function (as shown here), to prevent a bunch of superflous
 * notificaitons.
 *
 *****************************************************************
 */
//function PlayPostSelect(){
   //remove the nonsense about idle animations
//}



simulated function PlayIdleAnim(){
   if (IdleAnim != ''){
   PlayAnim(IdleAnim);
   }
}


/*****************************************************************
 * SwitchPrioriy
 * Overridden so the client can switch better, client doesn't have ammotype set
 * @@@ ammo doesn't get replicated until after this is called, damn inconvienient
 * if you ask me.
 *****************************************************************
 */
simulated function float SwitchPriority()
{
    if (Instigator == none) Instigator = Pawn(Owner);
   // Log( self $ " AmmoType: " $AmmoType $ " Instigator: " $ Instigator);

    if ( !Instigator.IsHumanControlled() ){
        return RateSelf();
    } else if (!HasAmmo()) {
        if ( Pawn(Owner).Weapon == self )
            return -0.5;
        else
            return -1;
    } else {
        return default.AutoSwitchPriority;
    }
}


/*****************************************************************
 * ClientFinish
 *****************************************************************
 */
simulated function ClientFinish(){
   // super.ClientFinish();

    //super
    if ( (Instigator == None) || (Instigator.Controller == None) ) {
        GotoState('');
        return;
    }
    if ( NeedsToReload() && AmmoType.HasAmmo() ) {
        GotoState('Reloading');
        return;
    }
    //modified
    if ( bAllowedToAutoSwitch == true && !HasAmmo() ){
        Instigator.Controller.SwitchToBestWeapon();
        if ( !bChangeWeapon ) {
            PlayIdleAnim();
            GotoState('Idle');
            return;
        }
    } else if (bAllowedToAutoSwitch == false && !HasAmmo()){
      PlayIdleAnim();
      GotoState('Idle');
      return;
    }
    if ( bChangeWeapon ) {   GotoState('DownWeapon'); }
    else if ( Instigator.PressingFire() ) {
         Global.Fire(0);
         GotoState('ClientFiring');
    }  else {
        if ( Instigator.PressingAltFire() ){
            Global.AltFire(0);
        } else {
            PlayIdleAnim();
            GotoState('Idle');
        }
    }
    if (WeaponMode == WM_Rapid){
      WeaponKick(WeaponKickMag, WeaponKickDir);
    }

}


/*****************************************************************
 *
 *****************************************************************
 */
function ProjectileFire(){
    local Vector Start, X,Y,Z;

    Owner.MakeNoise(1.0);
    GetAxes(Instigator.GetViewRotation(),X,Y,Z);
    Start = GetFireStart(X,Y,Z);
    AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError);
        //added some effects nonsense here
        //DrawTraceEffect(vect(0,0,0));
    AmmoType.SpawnProjectile(Start,AdjustedAim);
}


/*****************************************************************
 * DrawTraceEffect
 * Why would anyone do this here? Well if you look carefully you will
 * see that we have access to the hitlocation here. Really this is the
 * only time this value is accessible. That's why this is here and not
 * in the weapon.
 *****************************************************************
 */
function DrawTraceEffect(Vector HitLocation) {
   local vector StartTrace, FireDirection;
   local actor temp;
   local PlayerController pc;
   local float currentTime;
   local bool bEffectLimitReached;
//   local int i;


   currentTime = Level.TimeSeconds;
   if ( currentTime - lastEffectTime < MinTimeBetweenEffects ) {
       bEffectLimitReached = true;
   }
   else {
       lastEffectTime = currentTime;
       bEffectLimitReached = false;
   }

   //first person only the case if you are the player
   //-------------------------------------------------
   pc = PlayerController(Instigator.Controller);


   //third person
   //used to attach to the 3rd or first person weapon depending on render
   //mode, but in a multiplayer game you are actually both, so we pick a bone
   //on the pawn that looks good for both.
   //--------------------------------------------------
   if ( ThirdPersonActor != None && !bEffectLimitReached ) {

       if (HitLocation == vect(0,0,0)) {
           //HitLocation = ThirdPersonActor.Location
           //    + vector(ThirdPersonActor.Rotation) * vect(1000,1000,1000);
           HitLocation = Instigator.Location
               + vector(Instigator.Rotation) * vect(1000,1000,1000);
       }
       //StartTrace = Instigator.Weapon.GetBoneCoords(MuzzleFlashBone).Origin;
       //StartTrace = ThirdPersonActor.GetBoneCoords(MuzzleFlashBone).Origin;
       StartTrace = Instigator.GetBoneCoords('Weapon').Origin;
       FireDirection = HitLocation - StartTrace;

       //if there is something to spawn and you are rendering this
       if ( ThirdPersonMuzzleFlashClass != None ){
/*
           temp = Spawn(ThirdPersonMuzzleFlashClass,,,
                        ThirdPersonActor.GetBoneCoords('Flash01').Origin,Rotator(FireDirection));
               StartTrace,Rotator(FireDirection));
           Emitter(temp).AutoDestroy = true;
  */
        //if the emitter is lagging then we can try to attach it
         //later...as it stands it looks cool without this
         //ThirdPersonActor.AttachToBone(temp,MuzzleFlashBone);
       }

      if (TraceEmitterClass != none){
           temp = Spawn(TraceEmitterClass,,,
                        StartTrace,Rotator(FireDirection));
           Emitter(temp).AutoDestroy = true;

       }

   }


    // this is cheap, so we don't need to limit it...
                                          /*
    if ( ThirdPersonMuzzleFlashEmitter != None ) {
      ThirdPersonMuzzleFlashEmitter.Trigger( self, none );
    }
    else if ( ThirdPersonMuzzleFlashEmitterClass != None ) {

        ThirdPersonMuzzleFlashEmitter = Spawn( ThirdPersonMuzzleFlashEmitterClass );
        for ( i = 0; i < MuzzleFlashEmitter.emitters.length; ++i ) {
            MuzzleFlashEmitter.emitters[i].ResetOnTrigger  = true;
            MuzzleFlashEmitter.emitters[i].AutoDestroy     = false;
            MuzzleFlashEmitter.emitters[i].TriggerDisabled = false;
        }
        MuzzleFlashEmitter.AutoDestroy = false;
        AttachToBone(MuzzleFlashEmitter, MuzzleFlashBone);
    }

                                            */

}

//@@@ likely need to move this to get it working in MP
simulated function AttachToPawn(Pawn P){
   super.attachToPawn(P);
}


//}

//===========================================================================
// Pawn weapon specific animations
//===========================================================================


/*****************************************************************
 * GetFireAnim
 * Returns the fire animation to be played by the pawn when this
 * weapon is held
 *****************************************************************
 */
function name GetFireAnim(){
   return FireAnimName;
}


/*****************************************************************
 * GetIdleAnim
 * Returns the standing idle animation to be played by the pawn when
 * this weapon is held
 *****************************************************************
 */
function name GetIdleAnim(){
   return StandIdleAnimName;
}

/*****************************************************************
 * GetCrouchIdleAnim
 * Returns the crouching idle animation to be played by the pawn when
 * this weapon is held
 *****************************************************************
 */
function name GetCrouchIdleAnim(){
   return CrouchIdleAnimName;
}

/*****************************************************************
 * GetHitAnim
 * Returns the weapon specific animation to be played by the pawn when
 * the player is hit while holding this weapon
 *****************************************************************
 */
function name GetHitAnim(){
   return HitAnimName;
}



//===========================================================================
// STATE NORMALFIRE
//===========================================================================

state NormalFire{
   //once bots have had a chance to decide whether to fire again, shut
   //down this weapon so you have to fire it explicitly

   function CheckAnimating(){
      GotoState('Idle');
   }

   function ForceReload(){
      //Log(self $ " call to force reload on the server");
      super.ForceReload();
   }

   function AnimEnd(int Channel){
      if (WeaponMode == WM_Single && Instigator.IsHumanControlled() &&
          self.IsA('MeleeWeapon')==false) {
         Instigator.Controller.bFire = 0;
      }
      Finish();
      CheckAnimating();
   }
}

//===========================================================================
// STATE CLIENTFIRING
//===========================================================================
state ClientFiring
{
   simulated function ForceReload(){
      //PlayReloading();
      GotoState('Idle');
   }

    function CheckAnimating()
    {
      GotoState('Idle');
    }
}

//===========================================================================
// STATE IDLE
//===========================================================================

state Idle{
   simulated function ForceReload(){
      if (AmmoType.AmmoAmount > 0 && reloadCount != default.ReloadCount){
         ServerForceReload();
      }
   }

Begin:
    bPointing=False;
    if ( NeedsToReload() && AmmoType.HasAmmo() )
        GotoState('Reloading');
    if (bAllowedToAutoSwitch == true){
       if ( !HasAmmo() )
           Instigator.Controller.SwitchToBestWeapon();  //Goto Weapon that has Ammo
    }
    if ( Instigator.PressingFire() ) Fire(0.0);
    if ( Instigator.PressingAltFire() ) AltFire(0.0);
    PlayIdleAnim();

}



//===========================================================================
// STATE DOWNWEAPON
//===========================================================================

state DownWeapon
{
    function Fire( float Value ) {}
    function AltFire( float Value ) {}
    function ServerFire() {}
    function ServerAltFire() {}

    simulated function bool PutDown(){
        return true; //just keep putting it down
    }

    simulated function AnimEnd(int Channel){
        Pawn(Owner).ChangedWeapon();
    }

    simulated function BeginState(){
        OldWeapon = None;
        bChangeWeapon = false;
        bMuzzleFlash = false;
        TweenDown();
    }
}


//===========================================================================
// STATE RELOADING
//===========================================================================
state Reloading {
   simulated function BeginState(){

      local int TopUpAmount;

      if ( !bForceReload ){
         if ( Role < ROLE_Authority )
            ServerForceReload();
         else
            ClientForceReload();
      }
      bForceReload = false;
      PlayReloading();

      //the difference between your max, and current values: limited
      //by the available ammo
      TopUpAmount = Min((default.ReloadCount - ReloadCount), AmmoType.AmmoAmount);
      ReloadCount = ReloadCount + TopUpAmount;
      if (bInfiniteAmmo == false){
         AmmoType.AmmoAmount = AmmoType.AmmoAmount - TopUpAmount;
      }

   }

   //tweaked, not sure that there is a need to subclass anymore, no
   //time to investigate while commenting...
   simulated function AnimEnd(int Channel){
      if ( Role < ROLE_Authority )
         ClientFinish();
      else
         Finish();
      CheckAnimating();
   }

  function CheckAnimating() {
     if ( !IsAnimating() )
     GotoState('Idle');
  }

}





//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     bRenderWeaponMesh=True
     SingleFireRate=1.000000
     RapidFireRate=1.000000
     MinTimeBetweenEffects=0.350000
     GeneralZeroAmmoEvent="OUT_OF_AMMO_EVENT"
     NumShakes=1
     WeaponKickMag=150
     iInaccuracyDelta=0.500000
     iInaccuracyDecline=2.000000
     iMountAccuracyModifier=1.000000
     iAimingAccuracyModifier=1.000000
     HitSpread=512.000000
     AimedOffset=(Y=-18.000000,Z=-5.000000)
     AimedFOV=35
     AimedWalkingSpeed=170.000000
     reticuleScale=1.000000
     IconWidth=256
     IconHeight=84
     OfficialName="Unnamed"
     AMMO_CENTER=1100
     AMMO_Y=820
     PlayerViewOffset=(X=0.000000,Z=0.000000)
     bTravel=False
     DebugFlags=1
}
