// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*
 * HGRailShooter -
 *
 * It's a mover so it can move, also takes damage and that sort of stuff.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class RailShooter extends Mover
   editinlinenew
   implements( HudDrawable );



//===========================================================================
// Event data
//===========================================================================

//Events created
var(Events) Name VehicleDestroyedEvent;

//Events handled
var(Events) editconst const Name hSound1;
var(Events) editconst const Name hSound2;
var(Events) editconst const Name hSound3;
var(Events) editconst const Name hMesh1;
var(Events) editconst const Name hMesh2;
var(Events) editconst const Name hMesh3;
var(Events) editconst const Name hShowHealthBar;
var(Events) editconst const Name hHideHealthBar;

//Damage is represented by an emitter (ie smoke), a relative location
//to spawn that emitter and an absolute damage value that the emitter
//becomes active at.
struct DamageStruct{
   var bool bCompleted;
   var() class<Emitter> DamageEmitter;
   var() vector         SpawnLocation;
   var() int            DamageRequirement;
   var() StaticMesh     DamageMesh;
   var() Sound          DamageSound;
};

//===========================================================================
// LD set variables
//===========================================================================


var() bool bRenderOnRadar;
//list of things that happen when vehicle is damaged
var() array<DamageStruct> DamageEffects;
//the amount of damage the vehicle can take
var() int DamageCapacity;
//the default sound of the engine
var() Sound EngineSound;
//whether to delete the vehicle when it is blown up
var() bool bDeleteVehicle;
//scaling for engine pitch / velocity
var() float EnginePitchScale;
//minimum pitch engine can reach
var() float EnginePitchMinimum;
//whether to scale the engine pitch when moving
var() bool bPitchChangeOnVelocity;
//if this vehicle can be damaged
var() bool bTakesDamage;
//how much to do to those riding on it
var() int DamageToRiders;
var() int MomentumToRiders;
var() int DamageRadius;
//alternative meshes that can be swapped in by events
var() StaticMesh VehicleMesh2;
var() StaticMesh VehicleMesh3;
//alternative sounds that can be swapped in by events
var() Sound EngineSound2;
var() Sound EngineSound3;
//takes damage from the player
var() bool bTakesDamageFromPlayer;
// minimum amount of damage required to affect this actor
var() int MinDamageThreshold;


// HUD display stuff
var() editinline HudQuantity HealthBar;
var() Material Icon;
// location of the top-left corner of the icon (on 1280x960 canvas)
var() int IconPositionX;
var() int IconPositionY;
// drawable region of the texture, in texels.
var() int IconWidth;
var() int IconHeight;

var int DifficultyLevel;

//===========================================================================
// Internal Stuff
//===========================================================================

const ENGINE_TIMER = 364463; //ENGINE
const HUD_HACK     = 2838754;
//keep track of ones that are already spawned in case we need to
//delete them later
var array<Emitter> CurrentEmitters;
var bool bVehicleDestroyed;
var float EnginePitchMaximum;
var bool bShowHealth;
var int iInitialDamageCapacity;
var config float iDamageCapacityMultiplier;


/****************************************************************
 * SetInitialState
 ****************************************************************
 */
function SetInitialState(){
   //Not sure why this doesn't work
   Super.SetInitialState();
   DifficultyLevel = AdvancedGameInfo(Level.Game).iDifficultyLevel;
   //the LD set maximum value!!
   iInitialDamageCapacity = DamageCapacity;
   DamageCapacity = DiffToHealth(DifficultyLevel);

   UpdateDifficultyLevel(DifficultyLevel);
}

/****************************************************************
 * PostBeginPlay
 ****************************************************************
 */
function PostBeginPlay(){
   Super.PostBeginPlay();
   MoveAmbientSound = EngineSound;
   SetMultiTimer(ENGINE_TIMER, 0.2, true);
   //   iInitialDamageCapacity = DamageCapacity; //the LD set number
   //   DamageCapacity =

   //   DamageCapacity = float(iInitialDamageCapacity) * default.iDamageCapacityMultiplier;
   //default.iInitialDamageCapacity = float(DamageCapacity);// *

                                                  // float(default.iDamageCapacityMultiplier);
}


/****************************************************************
 * UpdateDifficultyLevel
 * 0=Easy
 * 1=Standard
 * 2=Difficult
 ****************************************************************
 */
function UpdateDifficultyLevel(int NewDifficulty){

   local float HealthRatio;
   local int MaxHealth;

   if (!bTakesDamageFromPlayer){
      HealthRatio = float(DamageCapacity)/DiffToHealth(DifficultyLevel);
      MaxHealth = DiffToHealth(NewDifficulty);
      DamageCapacity = HealthRatio * MaxHealth;
      DifficultyLevel = NewDifficulty;
      ShowHealth(bShowHealth);
      class.static.StaticSaveConfig();
   }
}

function float DiffToHealth(int Diff){

   local float multiplier;

      switch diff {
         //easy
      case 0:
         multiplier = 2;
         break;
         //standard
      case 1:
         multiplier = 1;
         break;
         //difficult
      default:
         multiplier = 0.75;
         break;
      }

      return multiplier * iInitialDamageCapacity;
}


/****************************************************************
 * PostLoad
 ****************************************************************
 */
function PostLoad() {
  local int diff;
                // Log( self @ "PostLoading with bShowHealth =" @ bShowHealth  )    ;
    //  diff = AdvancedGameInfo(Level.Game).iDifficultyLevel;
  diff = AdvancedGameInfo(Level.Game).iDifficultyLevel;
  UpdateDifficultyLevel(diff);
  SetMultiTimer( HUD_HACK, 0.2, false );
}


/****************************************************************
 * MultiTimer
 ****************************************************************
 */
function MultiTimer(int ID){
    switch ( ID ) {
    case ENGINE_TIMER:
        if (!bVehicleDestroyed) {
            PlayEngineSound();
        } else {
            SetMultiTimer(ENGINE_TIMER, 0, false);
        }
        break;

    case HUD_HACK:
        showHealth( bShowHealth );
        break;

    default:
        super.MultiTimer( ID );
    }
}



/****************************************************************
 * TakeDamage
 * Like the Pawn version of TakeDamage, this reduces the remaining
 * damage capacity by the given damage amount and destroys the thing
 * when it is at zero.
 ****************************************************************
 */
function TakeSomeDamage(int Damage, Actor Other){
   local int i;

   if (Level.GetLocalPlayerController().bGodMode){
      return;
   }

   //if not destroyed and is allowed to take damage
   if (!(!bVehicleDestroyed && bTakesDamage)){
      return;
   }

   //if you are the player and the player cannot damage this
   if (Other == Level.GetLocalPlayerController().Pawn &&
       Other != None &&
       !bTakesDamageFromPlayer){
      return;
   }

   // ignore damage less than the threshold.
   if ( damage < minDamageThreshold ) return;

   DamageCapacity = DamageCapacity - Damage;
   for (i = 0; i < DamageEffects.length; i++){
      if (float(DamageEffects[i].DamageRequirement) *
          class.default.iDamageCapacityMultiplier >= DamageCapacity){
         //Do your damage stuff
         if (DamageEffects[i].bCompleted != true){

            //Create an emitter
            if (DamageEffects[i].DamageEmitter != None){
               CurrentEmitters[i] = Spawn(DamageEffects[i].DamageEmitter,
                              ,, Location+DamageEffects[i].SpawnLocation);
               CurrentEmitters[i].bHardAttach=true;
               CurrentEmitters[i].SetBase(Self);
               DamageEffects[i].DamageEmitter = None;
            }
            //Play a sound
            if (DamageEffects[i].DamageSound != None){
               PlaySound(DamageEffects[i].DamageSound);
            }
            //swap meshes
            if (DamageEffects[i].DamageMesh != None){
               //swap the mesh
               SetStaticMesh (DamageEffects[i].DamageMesh);
            }
         }
      }
   }
   if (DamageCapacity <= 0){
      BlowUp();
   }
}


/****************************************************************
 * FinishedInterpolating
 * Yes we have to set the velocity to nothing when it stops moving,
 * apparently the engine felt that detail wasn't important
 ****************************************************************
 */
function FinishedInterpolation(){
 Super.FinishedInterpolation();
 Velocity = vect(0,0,0);
}


/****************************************************************
 * BlowUp
 ****************************************************************
 */
function BlowUp(){

   local int i;

   bVehicleDestroyed=true;
   bMovable = false;

   // notify anyone who's interested
   TriggerEvent( VehicleDestroyedEvent, self, None );

   //The optional remove from game
   if (bDeleteVehicle){
      for (i =0; i < CurrentEmitters.length; i++){
         CurrentEmitters[i].Destroy();
      }
      //Destroy();
      bHidden = true;
      bBlockActors = false;
      bBlockPlayers = false;
      bCollideWorld = false;
      bBlockZeroExtentTraces = false;
      AmbientSound = None;

   }
   HurtRadius(DamageToRiders,DamageRadius,none,MomentumToRiders, Location);
}


/****************************************************************
 * EncroachingOn
 * Overridden to prevent movers from killing the player while he/she
 * is in a cinematic and doesn't have a controller.
 ****************************************************************
 */
function bool EncroachingOn( actor Other )
{
   if (! (((Pawn(Other) != None) && (Pawn(Other).Controller == None)))){
      return Super.EncroachingOn(Other);
   }
   return false;
}


/****************************************************************
 * TriggerEx
 ****************************************************************
 */
function TriggerEx(Actor Other, Pawn Instigator, Name Handler){
    switch( handler ) {
    //set the sound
    case hSound1:
        EngineSound = default.EngineSound;
        break;
    case hSound2:
        EngineSound = EngineSound2;
        break;
    case hSound3:
        EngineSound = EngineSound3;
        break;

    //set the mesh
    case hMesh1:
        SetStaticMesh (default.StaticMesh);
        break;
    case hMesh2:
        SetStaticMesh (VehicleMesh2);
        break;
    case hMesh3:
        SetStaticMesh (VehicleMesh3);
        break;

    // show health
    case hShowHealthBar:
        ShowHealth( true );
        break;

    // hide health
    case hHideHealthBar:
        ShowHealth( false );
        break;

    default:
        super.TriggerEx( other, instigator, handler );
    }
}

/****************************************************************
 * ShowHealth
 ****************************************************************
 */
function ShowHealth( bool makeVisible ) {
    local PlayerController pc;
    local AdvancedHud hud;

    pc = Level.GetLocalPlayerController();
    if ( pc == None ) return;
    hud = AdvancedHud( pc.myHud );
    if ( hud == None ) return;
    if ( makeVisible ) {
        hud.register( self );
        HealthBar.MaxQuantity = DiffToHealth(DifficultyLevel);
        bShowHealth = true;
    }
    else {
        hud.unregister( self );
        bShowHealth = false;
    }
}

//===========================================================================
// Sound Stuff
//===========================================================================



/****************************************************************
 * PlayEngineSound
 ****************************************************************
 */
function PlayEngineSound(){

   local float EnginePitch;
   local float scaledV;
   local float Range;

   if ( bPitchChangeOnVelocity){
      Range = EnginePitchMaximum - EnginePitchMinimum;
      scaledV = VSize(velocity)/EnginePitchScale;
      EnginePitch = EnginePitchMinimum + ((1 - (1 / (scaledV + 1))) * Range);
   } else {
      EnginePitch = EnginePitchMinimum;
   }

   SoundPitch = EnginePitch;
   AmbientSound = EngineSound;

}


/****************************************************************
 * KeyFrameReached
 ****************************************************************
 */
event KeyFrameReached(){
   Super.KeyFrameReached();
   //   AmbientSound =default.AmbientSound;
   AmbientSound = EngineSound;
}

/****************************************************************
 * MakeGroupStop
 ****************************************************************
 */
function MakeGroupStop(){
   Super.MakeGroupStop();
   AmbientSound = EngineSound;
   //AmbientSound = default.AmbientSound;
}

/****************************************************************
 * MakeGroupReturn
 ****************************************************************
 */
function MakeGroupReturn(){
   Super.MakeGroupReturn();
   AmbientSound = EngineSound;
   //AmbientSound = default.AmbientSound;
}


/****************************************************************
 * DrawToHud
 * Only gets called back while we're registered with the hud, so
 * someone needs to trigger the RailShooter first.
 ****************************************************************
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {
    // draw the health bar...
    if ( healthBar != None ) {
        healthBar.drawQuantity( damageCapacity, c, scaleX, scaleY );
    }
    // draw the icon...
    if ( icon == None ) return;
    c.SetPos( iconPositionX * scaleX, iconPositionY * scaleY );
    c.DrawTile( icon, iconWidth * scaleX, iconHeight * scaleY,
                0, 0, iconWidth, iconHeight );
}

/****************************************************************
 * DrawDebugToHud
 ****************************************************************
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY );


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     hSound1="ENGINE_SOUND_DEFAULT"
     hSound2="ENGINE_SOUND2"
     hSound3="ENGINE_SOUND3"
     hMesh1="VEHICLE_MESH_DEFAULT"
     hMesh2="VEHICLE_MESH2"
     hMesh3="VEHICLE_MESH3"
     hShowHealthBar="SHOW_HEALTH"
     hHideHealthBar="HIDE_HEALTH"
     DamageCapacity=4000
     EnginePitchScale=500.000000
     EnginePitchMinimum=64.000000
     bPitchChangeOnVelocity=True
     bTakesDamage=True
     DamageToRiders=2000
     MomentumToRiders=5000
     DamageRadius=1000
     bTakesDamageFromPlayer=True
     HealthBar=VQuantityBar'AdvancedEngine.RailShooter.RailShooterHealthBar0'
     IconPositionX=252
     IconPositionY=830
     IconWidth=128
     IconHeight=128
     DifficultyLevel=1
     EnginePitchMaximum=128.000000
     iDamageCapacityMultiplier=1.000000
     MoverEncroachType=ME_IgnoreWhenEncroach
     bHasHandlers=True
     SoundRadius=500.000000
     SoundVolume=244
}
