// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AdvancedPawn - The game specific pawn class, mostly ripped from desert
 *     thunder stuff
 *
 * @version $Revision: #10 $
 * @author  Jesse (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Nov 2003
 */
class AdvancedPawn extends Pawn
   abstract
   implements( HudDrawable )
   implements( SaveHandler )
   HideDropDown;

var class<TeamIndicator> RedTeamIndicator;
var class<TeamIndicator> BlueTeamIndicator;
var name TeamBoneName;
var TeamIndicator teamInd;


var int WEAPON_NAME_CENTRE;
var int WEAPON_NAME_Y;




var travel int kills;
var travel bool bDisplayKills;
var int RandVal;


//talking hack for cinematics
var bool bOpeningMouth;
var rotator DeltaPoint;
var float delta;


var vector SwayBob;

enum E_HitPart {
    HIT_Chest,
    HIT_Back,
    HIT_Head,
    HIT_Left,
    HIT_Right
};

enum E_SHADOWTYPE{
   SHADOW_NONE,
   SHADOW_PROJ,
   SHADOW_BLOB,
   SHADOW_FAKE,
};

// info about areas of the pawn that can be specially damaged
struct SpecialDamageInfo{
   var name BoneName;
   var int ReqMinHitDistance;
   var vector Offset;
   var class<emitter> DamageEmitter;
   var class<AdvancedSkeletalEmitter> AdvancedEmitter;
   var bool bCompleted;
   var array<Name> SubDamageBones;
   var float DamageMod;                 // modifier applied to damage
   var bool bFatal;                     // cause enough dmg to kill pawn
};

//so LD's can stick crap to pawns placed in the level
struct AttachedActors{
   var() name BoneName;
   var() name ActorTag;
};


// 10 channels used by movement
const RESTINGPOSECHANNEL   = 0;
const FALLINGCHANNEL       = 1; //? thought 10 channels were for movement
const IDLECHANNEL          = 12;
const TAKEHITCHANNEL       = 13;
const FIRINGCHANNEL        = 14;
const SPECIAL_FIRE_CHANNEL = 15;

const FOCUSCHANNEL         = 20;
const NUM_CHANNELS         = 20;

//directional consts
const FORWARD  = 0;
const BACK     = 32768;
const LEFTDIR  = 16384;
const RIGHTDIR = 49152;

const WEAPON_NAME  = 321777;
const GRENADE_HACK = 99321;
const GRENADE_RELEASE = 224;
const FOOTSTEP_ID = 222222;
const FOOTSTEP_INTERVAL = 0.4;
const BORED_TIMER = 4343;
const SHADOW_OPTIMIZER = 2323;
const WEAPON_INIT_TIMER = 1111;


//-----------------------------
// Animation set specification
//-----------------------------

var() array<AttachedActors> MyAttachedActors;

struct AnimInfo
{
   var() string AnimName;
   var bool bAdded;
   var MeshAnimation ObjRef;
};


var() array<string> AdditionalAnimationPkg;//for backward compatibility NOT used!
var() array<AnimInfo> AdditionalAnimPkg;


//Spawning
//------------
var array<name> AnimSpawn;
var bool bPlayingSpawn;

//Standing
//------------
//walks
var const Name AnimWalkTurnLeft;
var const Name AnimWalkTurnRight;
var Name AnimWalkForward;
var const Name AnimWalkBack;
var const Name AnimWalkLeft;
var const Name AnimWalkRight;
//runs
var const Name AnimRunTurnLeft;
var const Name AnimRunTurnRight;
var const Name AnimRunForward;
var const Name AnimRunBack;
var const Name AnimRunLeft;
var const Name AnimRunRight;
//jumps
var const Name AnimJump;
var const Name AnimJumpForward;
var const Name AnimJumpBack;
var const Name AnimJumpLeft;
var const Name AnimJumpRight;
//idles

var const Name AnimStandIdle;
var array<name> BoredStandingAnimList;
//hits
var const array<Name> AnimStandHitRight;
var const array<Name> AnimStandHitLeft;
var const array<Name> AnimStandHitBack;
var const array<Name> AnimStandHitHead;
var const array<Name> AnimStandHitFront;
//shoots
var const Name AnimStandFire;
//deaths
var const Name AnimStandDeathBack;
var const Name AnimStandDeathForward;
var const Name AnimStandDeathLeft;
var const Name AnimStandDeathRight;


//Crouching
//------------
var const Name AnimCrouchTurnLeft;
var const Name AnimCrouchTurnRight;
var const Name AnimCrouchIdle;
var const Name AnimCrouchForward;
var const Name AnimCrouchBack;
var const Name AnimCrouchLeft;
var const Name AnimCrouchRight;
//crouch idles

var array<name> BoredCrouchingAnimList;
//hits
var const array<Name> AnimCrouchHitRight;
var const array<Name> AnimCrouchHitLeft;
var const array<Name> AnimCrouchHitBack;
var const array<Name> AnimCrouchHitHead;
var const array<Name> AnimCrouchHitFront;
//shoots
var const Name AnimCrouchFire;
//deaths
var const Name AnimCrouchDeathBack;
var const Name AnimCrouchDeathForward;
var const Name AnimCrouchDeathLeft;
var const Name AnimCrouchDeathRight;


//Crawling
//------------
var const Name AnimCrawlTurnLeft;
var const Name AnimCrawlTurnRight;
var const Name AnimCrawlForward;
var const Name AnimCrawlBack;
var const Name AnimCrawlLeft;
var const Name AnimCrawlRight;
//idles
var const Name AnimCrawlIdle;
var array<name> BoredCrawlAnimList;
//hits
var const array<Name> AnimCrawlHitRight;
var const array<Name>  AnimCrawlHitLeft;
var const array<Name> AnimCrawlHitBack;
var const array<Name> AnimCrawlHitHead;
var const array<Name> AnimCrawlHitFront;
//shoots
var const Name AnimCrawlFire;
//deaths
var const Name AnimCrawlDeathBack;
var const Name AnimCrawlDeathForward;
var const Name AnimCrawlDeathLeft;
var const Name AnimCrawlDeathRight;


//others
//-----------------------------
var const Name AnimFallForward;
var const Name AnimFallBackWard;
var const Name AnimFallLeft;
var const Name AnimFallRight;


// currently active animations
// not to be overridden in subclasses
//-----------------------------
var Name Idle;
var name WeaponIdle;
var Name LastWeaponIdle;

var name AnimFire;
var array<Name> HitRight;
var array<Name> HitLeft;
var array<Name> HitBack;
var array<Name> HitHead;
var array<Name> HitFront;
var name DeathBack;
var name DeathForward;
var Name DeathLeft;
var Name DeathRight;
var name FallDownAnim;

var name FIRINGBLENDBONE;
var name LOOKINGBLENDBONE;

//crawling stuff
//----------------
var() float CrawlingPct; //percentage of running speed
var float CrawlingCollisionHeight;
var float CrawlingCollisionRadius;

// weapon stuff
//-------------------------
var vector  GameObjOffset;
var rotator GameObjRot;

// audio
//-------------------------
var class<emitter> BloodEmitter;
var class<emitter> SplutEmitter;

//boredom animation system
//-------------------------
//the number of seconds to wait between boredom anims
var int BoredomThreshold;
var int BoredomDeviation;
//the list of anims to chose from when you are bored
var array<name> BoredAnimList;
//an reminder of whether we set a timer already
var bool BoredomTimerActive;
//the bored anim that we should play (from the list)
var int BoredAnimNum;
//used by multitimer to identify our timer

// ragdoll
//-------------------------
//maximum life time of ragdoll
var(Karma) float         RagdollLifeSpan;
//'spin' ragdoll gets on death
var(Karma) float         RagInvInertia;
//speed ragdoll moves on death
var(Karma) float         RagDeathVel;
//strength of shot on ragdoll
var(Karma) float         RagShootStrength;
//propensity to spin around z
var(Karma) float         RagSpinScale;
//upward kick on death
var(Karma) float         RagDeathUpKick;
var(Karma) material      RagConvulseMaterial;
//ragdoll impact sounds
var(Karma) array<sound>  RagImpactSounds;
var(Karma) float         RagImpactSoundInterval;
var(Karma) float         RagImpactVolume;
var transient float      RagLastSoundTime;
//ragdoll file name
var string               RagdollOverride;
//name of the skeleton
var string               RagSkelName;

//footstep system
//-------------------------
var float FootStepVolume;
var array<Sound> FootStepSound;
var array<Sound> FootStepDirt;
var array<Sound> FootStepMetal;
var array<Sound> FootStepPlant;
var array<Sound> FootStepRock;
var array<Sound> FootStepWater;
var array<Sound> FootStepWood;
var array<Sound> FootStepIce;
var array<Sound> FootStepSnow;
var array<Sound> FootStepGlass;

var bool bDoFootsteps;

//Inventory slot Policies
//-------------------------
struct  InventoryLimitInfo{
    var int Limit;
    var name className;
};

var array<InventoryLimitInfo> InvLimit;

// noises
//------------------------
var Array<Sound> HitSounds;
var Array<Sound> DeathSounds;
var bool bPlayedDeathSound;
var array<Sound> gibSound;

//arm specific stuff
//------------------------
var Name CurrentArmAnim;
var Arms MyArms;
var class<Arms> ArmClass;
var bool bWantsArms;

//grenade throw
//------------------------
var() class<Projectile> GrenadeClass;
var name    GrenadeThrowAnim;
var int     GrenadeAnimLength;
var Rotator GrenadeDirection;
var Vector  GrenadeVelocity;
var bool    bHackGrenadeVelocity;

//location specific damage information
//------------------------
var array<SpecialDamageInfo> SpecialDamage;
var bool bUseSpecialDamage;
var bool bDoHeadShots;
var Emitter CurrentSpecialDamageEmitter;

// configurable...
//------------------------
var(Pawn)   bool bInfiniteAmmo;
var(Pawn)   localized String HudCaption;
var(Events) const Name OnKilledEvent;
var(Pawn)   bool bRenderOnRadar;
var(Pawn)   bool bSplutsByPlayerVehicle;
var() name  WeaponBone;
var() name  DeathActorTag;

// internal
var bool        bFreezeMovement;    // i.e. PHYS_None on purpose
var bool        bWasGodMode;        //management for focuesdanimations
var float       iAnimRate;           //global anim rate for focusedanimations
var name        FocusedAnimName;
var bool        bTakesDamageInFocused;
var bool        bAlwaysPlayDying;
var bool        bGodMode;
var float       tweentime;

var String      hudWeaponName;       //name to draw on the hud...
var bool        bShowInventory;
var bool        WeaponDowned;        //for use with arms housekeeping
var bool        bDamageKicksView;    //view shake when damaged
var int         ViewKickMagnitude;   //severity of view shake
var int         NumActiveRagdolls;   //optimization
var MountPoint  objMount;            //The mount when you are mounted.
var bool        bFirstLand;          //footstep management
var float       LastFootStep;        //footstep management
var localized string HeadShotTxt;
var float       hitblend;
var bool        bPlayingFall;
var float       FallDownAnimRate;
var string      SwappedAnimSet;
var() bool bAllowedToFall;
var int bLastFlagStatus;

//client side bone reduction
var byte      LastDamagedBoneIndex;
var bool      bClientFocused;

// character shadows
var transient ShadowProjector FancyShadow;
var ShadowImpostor FakeShadow;
var class<ShadowImpostor> ShadowImpostorClass;
var(Pawn) config E_SHADOWTYPE iUseShadows;
var(Pawn) int ActiveShadowDistance;

var() array<Material> HeadTextures;
var() array<Material> BodyTextures;

//old values to check against replicated stuff
var bool LastFlashToggle;
var int OldAimedPitch;
var string LastAddAnimPkg;
var string LastCurrentAddAnimPkg;

var int iBodyTexture;
var int iHeadTexture;

//lazily calculate the amount of time played
var int StartPlayTime;
var travel int PlayTime;


//Difficulty settings
var float DiffDamageMultiplier;
var int   DifficultyLevel;


var() int MinimumDamageThreshold;

/*****************************************************************
 * PreBeginPlay
 *****************************************************************
 */
function PreBeginPlay(){
   local int i;

    if (Role == Role_Authority){
      //link in all additional animation packages specified in defaults
       for (i=0; i< AdditionalAnimPkg.Length; i++){
         AddAnimationPackage(AdditionalAnimPkg[i].AnimName);
       }
    }

   super.PreBeginPlay();
}

/*****************************************************************
 * BaseChange
 *****************************************************************
 */
 singular function BaseChange () {
    if (objMount != none){
        Super.BaseChange ();
    }
}

/*****************************************************************
 * BeginPlay
 *****************************************************************
 */
function BeginPlay() {
    Super.BeginPlay();
    ZoneChange( region.zone );
    bShowInventory = true;
}

simulated function vector CalcDrawOffset(inventory Inv)
{
    local vector DrawOffset;

    if ( Controller == None )
        return (Inv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0,0,1);

    DrawOffset = ((0.9/Weapon.DisplayFOV * 100 * ModifiedPlayerViewOffset(Inv)) >> GetViewRotation() );
    if ( !IsLocallyControlled() )
        DrawOffset.Z += BaseEyeHeight;
    else
    {
        DrawOffset.Z += EyeHeight;
        if( bWeaponBob )
            DrawOffset += WeaponBob(Inv.BobDamping);
    }
    return DrawOffset;
}

function PossessedBy(Controller C){
   if (Level.NetMode != NM_CLIENT){
    xGamerTag = PlayerController(C).GamerTag;  // (C.PlayerReplicationInfo.gamertag);
   }
   super.PossessedBy(C);

}

simulated function SetTeamAttachments(){
   if (PlayerReplicationInfo == none) { return; }

   //team indicators
   if (PlayerReplicationInfo.Team != none){
      if (teamInd == none ||
          (TeamInd.Class == BlueTeamIndicator && PlayerReplicationInfo.Team.TeamIndex == 0) ||
          (TeamInd.class == RedTeamIndicator && PlayerReplicationInfo.Team.TeamIndex == 1)){

         //remove the old one
         if (teamInd != none){
            teamInd.Destroy();
         }

         //make a new one
         if (PlayerReplicationInfo.Team.TeamIndex == 0){
            teamInd = Spawn( RedTeamIndicator );
         } else if (PlayerReplicationInfo.Team.TeamIndex == 1){
            teamInd = Spawn( BlueTeamIndicator );
         }
      }
      if (teamInd !=None){
         AttachToBone(teamInd, TeamBoneName);
      } else {
         Log("Could Not find a team for " $ self);
      }
   }
}



/*****************************************************************
 *
 *****************************************************************
 */
simulated function CleanupMultiplayerAttachments(){
   local TeamIndicator temp;

   //destroy any team markers
   foreach BasedActors(class'TeamIndicator', temp){
     temp.Destroy();
   }
}

/*****************************************************************
 * GetActionableMessage
 * Added so that multiplayer characters can have a name on the HUD
 *****************************************************************
 */
function string GetActionableMessage(Controller C){
/*
   if (PlayerReplicationInfo != none &&
      PlayerReplicationInfo.Gamertag != ""){
         return DecodeStringURL(PlayerReplicationInfo.Gamertag);
   }
   */
   return "";
}

/*****************************************************************
 * Decode a string from the command line
 *****************************************************************
 */

function string DecodeStringURL(string s) {
    local string r;
    local string c;
    local int i;

    for (i = 0; i < Len(s); ++i) {
        c = Mid(s,i,1);
        if (c == "_") {
            r = r $ " ";
        } else {
            r = r $ c;
        }
    }
    return r;
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay() {
    local int i;


    if (Role < Role_Authority){
      //link in all additional animation packages specified in defaults
       for (i=0; i< AdditionalAnimPkg.Length; i++){
         AddAnimationPackage(AdditionalAnimPkg[i].AnimName);
       }
    }

   if (bDoFootSteps){
      SetMultiTimer( FOOTSTEP_ID, FOOTSTEP_INTERVAL, true);
   }

   if (bWantsArms){
      MyArms = Spawn(ArmClass);
      MyArms.bHidden = true;
   }

   SetMultiTimer(SHADOW_OPTIMIZER, 1, true);
   AttachItems();
   StartPlayTime = Level.TimeSeconds;

   if (Level.NetMode == NM_StandAlone){
      UpdateDifficultyLevel( AdvancedGameInfo(Level.Game).iDifficultyLevel );
   }


   SetPhysics(PHYS_Falling);
   SetBoredomTimer(true);

   Super.PostBeginPlay();

}


/*****************************************************************
 * PostNetBeginPlay
 * the client is not ready when it is spawned to bring up the weapon
 * giver a few to settle before commanding it up.
 *****************************************************************
 */
simulated function PostNetBeginPlay(){
   local int i;
   super.PostNetBeginPlay();

   WEAPON_NAME_CENTRE = 1170;
   WEAPON_NAME_Y = 780;

  // if (Level.NetMode == NM_Client && PlayerController(Controller)!=None){
      //Controller.ClientSwitchToBestWeapon();
//   }

   SetTeamAttachments();
   CheckShadow();
   //Add any animations pre-specified by the pawn type
   for (i=0; i< AdditionalAnimPkg.Length; i++){
      AddAnimationPackage(AdditionalAnimPkg[i].AnimName);
   }
   //Also add the current weapon to get things primed
   AddAnimationPackage(CurrentAddAnimPkg);
   ClientPlayWeaponIdle();
   bHidden = false;
   if (Level.NetMode == NM_Client){
      if (bLoopingAnim){
         LoopAnim(AnimAction,,0);
      } else {
         PlayAnim(AnimAction,,0);
      }
   }
   SetMultiTimer(WEAPON_INIT_TIMER,2,false);

}

/*****************************************************************
 * PostNetReceive
 * Here we handle when data from the server comes in. In particular
 * when bones have been blown off.
 *****************************************************************
 */
simulated event PostNetReceive(){

   local rotator temp;

   SetTeamAttachments();

   //replicate damaged bones
    if (LastDamagedBoneIndex != iDamagedBoneIndex){
        SetBoneScale(iDamagedBoneIndex,0.001,SpecialDamage[iDamagedBoneIndex].BoneName);
        LastDamagedBoneIndex = iDamagedBoneIndex;
    }
     //replicate new animation packages
    if ((NetAddAnimPkg != LastAddAnimPkg)){
       AddAnimationPackage(NetAddAnimPkg);
       LastAddAnimPkg = NetAddAnimPkg;
    }
    if ((CurrentAddAnimPkg != LastCurrentAddAnimPkg)){
       AddAnimationPackage(CurrentAddAnimPkg);
       LastCurrentAddAnimPkg = CurrentAddAnimPkg;
    }

   //set the weapon specific idle
   if (LastWeaponIdle != NetWeaponIdle){
      LastWeaponIdle = NetWeaponIdle;
      ClientPlayWeaponIdle();
   }

   if (iNetHeadTexture != iHeadTexture){
      iHeadTexture = iNetHeadTexture;
      SetCustomTexture(HeadTextures[iNetHeadTexture],1);
   }

   if (iNetBodyTexture != iBodyTexture){
      iBodyTexture = iNetBodyTexture;
      SetCustomTexture(BodyTextures[iNetBodyTexture],0);
   }

   //bone rotation
   if (OldAimedPitch != AimedPitch){
       temp.Yaw = -AimedPitch;
       OldAimedPitch = AimedPitch;
       SetBoneRotation(LOOKINGBLENDBONE, temp);
    }

   //@@@ sample test crap that should be cut at your earliest convenience
    if (LastFlashToggle != FlashToggle && Level.NetMode != NM_ListenServer){
      LastFlashToggle = FlashToggle;
//      Log(NetAtt $ " attempt to toggle");
      if(NetAtt !=None){
         AttachToBone(NetAtt, WeaponBone);
         AdvancedWeaponattachment(NetAtt).ClientThirdPersonFX();
         //NetAtt.ThirdPersonEffects();
      }
   }

    super.PostNetReceive();
}

/*****************************************************************
 * SetCustomTexture
 *****************************************************************
 */
simulated function SetCustomAppearance(int Head, int Body){
   //swap on a body
  if (BodyTextures.length >= Body && Body !=0){
      SetCustomTexture(BodyTextures[Body],0);
      iNetBodyTexture=Body;
  }
   //swap on a head
  if (HeadTextures.length >= Head && Head !=0){
      SetCustomTexture(HeadTextures[Head],1);
      iNetHeadTexture=Head;
  }
}

/*****************************************************************
 * SetCustomTexture
 * Puts a texture on a given skin channel.
 *****************************************************************
 */
simulated function SetCustomTexture(Material CustomTexture, int Channel){
  if (Skins.length == 0){
     CopyMaterialsToSkins();
  }
  if(Skins.length >= Channel){
   Skins[Channel] = CustomTexture;
  } else {
    log("!!!!!!! SERIOUS CLUSTER!!!!!!!!");
  }
}

/*****************************************************************
 * AttachItems
 * Puts the items on the bones
 *****************************************************************
 */
function AttachItems(){

   local int i;
   local actor temp;
   local bool error;
   local bool found;

   //look through the list of attached actors
   for (i=0; i < MyAttachedActors.Length; i++){
      error = false;
      found = false;
      //find them in the level
      ForEach AllActors(class'Actor', temp, MyAttachedActors[i].ActorTag){
        found = true;
         //attach them to the listed bones
        temp.SetCollision(false,false,false);
        temp.bHardAttach = true;
        error = AttachToBone(temp, MyAttachedActors[i].BoneName);
        if (error == false){
            Log ("ERROR: Could not attach : " $ temp $ " to : " $ MyAttachedActors[i].BoneName $ " on actor : " $ self);
        }
      }
      if (found == false){
        Log ("ERROR: Could not find : " $ MyAttachedActors[i].ActorTag $ " to attach to : " $ self);
      }
   }
}




/*****************************************************************
 * AddAnimationPackages
 * This method dynamically loads additional animation packages. If
 * the name of animations in the packages are distinct then the animations
 * are appended. If the name of the animations are identical than (seinsibly)
 * the last package loaded defines the behaviour of the animation.
 * PLEASE: make sure that the skeleton is the same for all packages used.
 *****************************************************************
 */
simulated function AddAnimationPackage(string AnimPackage, optional bool bForce){

    local MeshAnimation AdditionalAnims;
    local int i;

   if (AnimPackage == ""){
      return;
   }

   NetAddAnimPkg = AnimPackage;

    if (!bForce){
       //if you have added this then forget it;
       for (i=0; i<AdditionalAnimPkg.length; i++){
         if (AnimPackage == AdditionalAnimPkg[i].AnimName &&
             AdditionalAnimPkg[i].bAdded == true){
            return;
         }
       }
    }
    AdditionalAnims = MeshAnimation( DynamicLoadObject(AnimPackage,
                                            class'MeshAnimation') );
    if ( AdditionalAnims!= none ) {

       //update the list of animations you are linked to
       for (i=0; i<AdditionalAnimPkg.length; i++){
         if (AnimPackage == AdditionalAnimPkg[i].AnimName){
             AdditionalAnimPkg[i].bAdded = true;
             LinkSkelAnim( AdditionalAnims );
            // Log(self $ "The additional animation package: " $ AnimPackage $ " ADDED!");
             return;
         }
       }

        //trying to append the animations added to the complete list
        AdditionalAnimPkg.length = AdditionalAnimPkg.Length + 1;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].AnimName = AnimPackage;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].bAdded = true;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].ObjRef = AdditionalAnims;

        LinkSkelAnim( AdditionalAnims );
    }  else {
        Log(self $  "The additional animation package: " $ AnimPackage $ " is missing.");
    }
}


/*****************************************************************
 * Called right before the game is saved.
 *****************************************************************
 */
 function PreSave() {
    DestroyShadows();
}

/*****************************************************************
 * After saving is complete (broken).
 *****************************************************************
 */
function PostSave() {
    CheckShadow();
}

/****************************************************************
 * Tick
 * NOTE: since we're not using mount points in DOTZ, we don't need to worry
 *      about this.  The FreezeMovement stuff has been replaced by PHYS_None,
 *      which interacts better with the movement animation system.
 ****************************************************************
 */
function Tick( float Delta ){
   if (objMount != None){
      Acceleration.X = 0;
      Velocity.X = 0;
      Acceleration.Y = 0;
      Velocity.Y = 0;
      Acceleration.Z = 0;
      Velocity.Z = 0;
      SetPhysics(PHYS_NONE);
      SetLocation(objMount.Location);
   }
   super.Tick(Delta);
}

/*****************************************************************
 * PostLoad
 * Try to patch things up after a save game is loaded.
 *****************************************************************
 */
function PostLoad() {
    local ScriptedController sc;
    local int i;

    //NOTE: must do this BEFORE super.PostLoad()
    SwapAnimationSet( SwappedAnimSet );
    //link in all additional animation packages specified in defaults
    for (i=0; i< AdditionalAnimPkg.Length; i++){
      AddAnimationPackage(AdditionalAnimPkg[i].AnimName,true);
    }
    super.PostLoad();
    // this little hack gets the mov't anims working after loading...
    bInitializeAnimation = false;
    // and this one is for the neutral pose...
    if (Controller.bControlAnimations == true){
      sc = ScriptedController(Controller);
      if (sc != none && sc.CurrentAnimation.bLoopAnim == true){
         LoopAnim(sc.CurrentAnimation.BaseAnim,
                  sc.CurrentAnimation.AnimRate,
                  sc.CurrentAnimation.BlendInTime);
      } else {
         PlayAnim(sc.CurrentAnimation.BaseAnim,
                  sc.CurrentAnimation.AnimRate,
                  sc.CurrentAnimation.BlendInTime);
      }
    } else {
      ChangeAnimation();
    }

    // and this little hack is to un-stick any WaitForAnimEnds...
    for ( i = 0; i <= NUM_CHANNELS; ++i ) {
       AnimEnd(i);
    }

    for (i=0; i< SpecialDamage.length; i++){
        if (SpecialDamage[i].bCompleted == true){
           SetBoneScale(i,0.001,SpecialDamage[i].BoneName);
        }
    }


    if (Level.NetMode == NM_StandAlone){
      UpdateDifficultyLevel( AdvancedGameInfo(Level.Game).iDifficultyLevel );
    }
    CheckShadow();

    if (Controller == None) {
        // you're dead, so go away.
        if ( health <= 0 ) {
            Destroy();
        }
        else {
                        // Log( self @ "####### NO CONTROLLER ON POSTLOAD:" @ self  )    ;
        }
    }
    else if ( Controller.Pawn != self ) {
                    // Log( self @ "####### CONTROLLER/PAWN MISMATCH:" @ self @ Controller @ Controller.pawn  )    ;
    }
}

/*****************************************************************
 * Destroyed
 *****************************************************************
 */
simulated function Destroyed() {
    DestroyShadows(); // ...or else you'll get a dangling pointer in projector.
    if ( Physics == PHYS_KarmaRagdoll ) {
        default.NumActiveRagdolls = default.NumActiveRagdolls - 1;
    }
    if ( CurrentSpecialDamageEmitter != none ) {
        CurrentSpecialDamageEmitter.destroy();
    }
    Super.Destroyed();
}

/****************************************************************
 * MultiTimer
 ****************************************************************
 */
function MultiTimer( int timerID ) {

    //if (Role == Role_Authority){
       switch ( timerID ) {

       case WEAPON_NAME:
           hudWeaponName = "";
           bShowInventory = false;
           break;

       case GRENADE_HACK:
           TossGrenade( Rot(8192,0,0) );
           break;

       case GRENADE_RELEASE:
           ReleaseGrenade();
           break;

       case FOOTSTEP_ID:
           DoFootStep();
           break;

       case BORED_TIMER:
           BoredAnimNum = FRand() * BoredAnimList.Length;
           BoredomTimerActive = false;
           break;

       case SHADOW_OPTIMIZER:
           OptimizeShadow();
           break;

       case WEAPON_INIT_TIMER:
           //Controller.ClientSwitchToBestWeapon();
           break;

       default:
           super.MultiTimer( timerID );
       }
}

/*****************************************************************
 * Landed
 * Try and do a footstep when you land
 *****************************************************************
 */
event Landed(vector x){
   Super.Landed(x);
   if (!bFirstLand){
      DoFootStep();
   }
   bFirstLand = false;
}


/*****************************************************************
 * ZoneChange
 * Make necessary adjustments so that bots can't see through the fog.
 *****************************************************************
 */
event ZoneChange( ZoneInfo NewZone ) {

    super.ZoneChange( newZone );

    if ( newZone.bDistanceFog ) {
        sightradius = NewZone.DistanceFogStart
            + ( (NewZone.DistanceFogEnd - NewZone.DistanceFogStart) * 0.7 );
    }
    else {
        sightRadius = default.sightRadius;
    }
                // Log( self @ self @ "sight radius in" @ newZone @ "is" @ sightradius  )    ;
}


/****************************************************************
 * Mount
 * controller has decided to mount the gun on something...
 ****************************************************************
 */
function Mount() {
    //bSpecialCalcView = true;
}


/****************************************************************
 * UnMount
 * controller has decided to run around freely again...
 ****************************************************************
 */
function Unmount() {
    SetPhysics(PHYS_WALKING);
    //bSpecialCalcView = false;
    BaseEyeHeight = default.BaseEyeHeight;
}

/****************************************************************
 * ChangedWeapon
 ****************************************************************
 */
function ChangedWeapon() {
    local AdvancedWeapon aw;

//    Log(self $ " ChangeWeapon - Currentweapon: " $ weapon $ " pending: " $ pendingweapon);
    super.ChangedWeapon();
    aw = AdvancedWeapon( weapon );
    if ( aw != None ) hudWeaponName = aw.OfficialName;
    SetMultiTimer( WEAPON_NAME, 2, false );
    bShowInventory = true;

}


/*****************************************************************
 * Fire - Overloads the Pawn Fire to ensure that we play the firing
 * animation when the pawn fires the weapon
 ******************************************************************
 */
function Fire( optional float F )
{
   Super.Fire(F);
}


//===========================================================================
//===========================================================================
// SHADOW FUNCTIONS
//===========================================================================
//===========================================================================


/*****************************************************************
 * CheckShadow
 *****************************************************************
 */
function CheckShadow() {
   DestroyShadows();

   if (Level.NetMode == NM_StandAlone){
      switch (Class'AdvancedGameInfo'.default.iUseShadows){
      case AdvancedGameInfo(Level.game).E_ShadowType.SHADOW_NONE:
         break;      //nothing to do

      case AdvancedGameInfo(Level.game).E_ShadowType.SHADOW_FAKE:
         CreateFakeShadow();
         break;

      case AdvancedGameInfo(Level.game).E_ShadowType.SHADOW_BLOB:
         SpawnProjectorShadow(true); //use blob
         break;

      case AdvancedGameInfo(Level.game).E_ShadowType.SHADOW_PROJ:
         SpawnProjectorShadow(false); //use stencil
         break;
      }
   }
}


/*****************************************************************
 * CreateFakeShadow
 *****************************************************************
 */
simulated function CreateFakeShadow(){
   FakeShadow = Spawn( ShadowImpostorClass, None,,
                      location + vect(0,0,-1) * (CollisionHeight -1) );
   FakeShadow.SetCollision( false, false, false );
   FakeShadow.SetBase( self );
}


/*****************************************************************
 * CleanUpOldShadows
 *****************************************************************
 */
simulated function DestroyShadows(){

   //if you were using a projector
   if (FancyShadow != None){
      FancyShadow.ShadowActor = none;
      FancyShadow.Destroy();
      FancyShadow = none;
   }

   //if you were using a mesh
   if (FakeShadow !=None){
      FakeShadow.Destroy();
      FakeShadow = none;
   }
}

/*****************************************************************
 * SpawmShadow
 *****************************************************************
 */
simulated function SpawnProjectorShadow(bool blob) {
    if ( fancyShadow == none ) {
        FancyShadow = Spawn(class'AdvancedShadowProjector', self, '', location);
        FancyShadow.ShadowActor        = self;
        FancyShadow.LightDirection     = Normal(vect(0,0,1));
        FancyShadow.LightDistance      = 380;
        FancyShadow.MaxTraceDistance   = 350;
        FancyShadow.bBlobShadow        = blob;
        FancyShadow.bShadowActive      = true;
        FancyShadow.bProjectStaticMesh = false;
        FancyShadow.bProjectParticles  = false;
        FancyShadow.InitShadow();
    }
}

/*****************************************************************
 * Optimize
 *****************************************************************
 */
function OptimizeShadow(){
   local Pawn ap;
   local int Distance;

   //must be running as a server
   if ( Level.GetLocalPlayerController() == None){
       if (FancyShadow != None){
         FancyShadow.bShadowActive = true;
       }
       return;
   }

   //something is seriously wrong
   ap = Level.GetLocalPlayerController().Pawn;
   if ( ap == None ) return;

   //check if shadow is in need of optimization
   Distance = Vsize(ap.Location - Location);
   if ( FancyShadow != None){
      if (Distance < ActiveShadowDistance){
         FancyShadow.bShadowActive = true;
      } else {
         FancyShadow.bShadowActive = false;
      }
   }
}


/*****************************************************************
 * StartCrouch
 * Adjust shadow to match standing foot position.
 *****************************************************************
 */
function StartCrouch( float adjust ) {
    super.StartCrouch( adjust );
    if ( FakeShadow != None ) {
        FakeShadow.SetBase( none );
        FakeShadow.SetLocation( location + vect(0,0,-1) * (CrouchHeight -1) );
        FakeShadow.SetBase( self );
    }
}


/*****************************************************************
 * EndCrouch
 * Adjust shadow to match standing foot position.
 *****************************************************************
 */
function EndCrouch( float adjust ) {
    super.EndCrouch( adjust );
    if ( FakeShadow != None ) {
        FakeShadow.SetBase( none );
        FakeShadow.SetLocation( location + vect(0,0,-1) * (CollisionHeight -1) );
        FakeShadow.SetBase( self );
    }
}


/*****************************************************************
 * StartCrawl
 * Handle your crawl struff here, collision changes, shadow changes...
 *****************************************************************
 */
function StartCrawl(){

   SetCollisionSize(CrawlingCollisionRadius,CrawlingCollisionHeight);
   GroundSpeed = CrawlingPct * default.GroundSpeed;
   Velocity *= CrawlingPct;

   if ( FakeShadow != None ) {
      FakeShadow.SetBase( none );
      FakeShadow.SetLocation( location + vect(0,0,-1) * (CrawlingCollisionHeight -1) );
      FakeShadow.SetBase( self );
   }
}

//===========================================================================
//===========================================================================
// INVENTORY FUNCTIONS
//===========================================================================
//===========================================================================




/*****************************************************************
 * SetInventoryLimit
 * Allows the game type to set the inventory limits to what is most
 * sensible for the type of gameplay you are trying to achieve
 *****************************************************************
 */
function SetInventoryLimit(int limit, name className){
    local int addIndex;
    addIndex = invLimit.Length;

    //increase array length
    InvLimit.length = InvLimit.length+1;
    InvLimit[addIndex].Limit = limit;
    InvLimit[addIndex].classname = classname;
}


/*****************************************************************
 * RemaningInventoryCapacity
 *****************************************************************
 */
function int RemainingInventoryCapacity(name groupClass){
   local int currentCount, i;

   currentCount = InventoryGroupCount(groupClass);
   for (i=0; i< InvLimit.Length; i++){
    if (InvLimit[i].className == groupClass){
        return InvLimit[i].Limit - currentCount;
    }
   }
   return -1;
}


function DeleteInventory( inventory Item )
{
    super.DeleteInventory( Item );
    //Log( "delete inventory: " $ item);

}

/*****************************************************************
 * InventoryGroupCount
 * A function that takes a class definition as a group type, and
 * enumerates the inventory list to determine the quantity.
 * An inventory item will match if it inherits from the given class
 * definition.
 *****************************************************************
 */
function int InventoryGroupCount(name groupClass){

   local Inventory Inv;
   local int count;
   for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
   {
      if( Inv.Isa(groupClass) == true  ){
         count = count + 1;
      }
   }
   return count;
}

/*****************************************************************
 * DeleteInventoryByGroup
 *
 * Takes a class definition and removes an inventory item from the
 * inventory list that matches the given type. An inventory item
 * will match if it inherits from the given class definition.
 *****************************************************************
 */
function DeleteInventoryByGroup(name groupClass){

   local Inventory Inv;

   //we favour dropping the weapon so the player can see what
   //is happening
  if(Weapon.IsA(groupClass) == true && IsInInventory(Weapon) == true){
//Log("DropFrom: " $ Weapon);
      Weapon.DropFrom(Location);
   } else {
     for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
      {
         if( Inv.Isa(groupClass) == true  ){

//           Log("DropFrom: " $ inv);
            Inv.DropFrom(Location);
         }
      }
   }
}

/*****************************************************************
 * FindInventoryByGroup
 *****************************************************************
 */
function Inventory FindInventoryByGroup(name groupClass){

   local Inventory Inv;
   for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
   {
      if( Inv.Isa(groupClass) == true  ){
         return Inv;
      }
   }
}

/*****************************************************************
 * AddInventory
 * Add Item to this pawn's inventory.
 * Returns true if successfully added, false if not.
 *****************************************************************
 */
function bool AddInventory( inventory NewItem )
{
    // Skip if already in the inventory.
    local inventory Inv;
    local int i;
    local actor Last;
    local int count;
    local AdvancedWeapon aw;

    Last = self;
    // The item should not have been destroyed if we get here.
    if (NewItem ==None ) {
                        // Log( self @ "tried to add none inventory to "$self )    ;
    }


    //Log("Attempting to add " $ NewItem $ "to inventory");

    for (i=0;i<InvLimit.length;i++){
        if (NewItem.IsA(InvLimit[i].className)){
          count = InventoryGroupCount(InvLimit[i].className);
                      // Log( self @ "You already have " $ count $ InvLimit[i].className )    ;
           if (count >= InvLimit[i].Limit) {
              //If so remove one of them
              DeleteInventoryByGroup(InvLimit[i].className);
           }
           //break;
        }
    }

    //Do normal addition for all other inventory types
    for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
    {
           if( Inv == NewItem ){
              return false;
           }
       Last = Inv;
    }

    // Add to back of inventory chain (so minimizes net
    // replication effect).
    NewItem.SetOwner(Self);
    NewItem.Inventory = None;
    Last.Inventory = NewItem;
    aw = AdvancedWeapon(NewItem);
    // force ammo to be infinite if desired by this pawn...
    if ( bInfiniteAmmo && aw != none ) {
        AdvancedWeapon(NewItem).SetInfiniteAmmo(true);
    }

    if ( Controller != None )
        Controller.NotifyAddInventory(NewItem);
    return true;
}



/*****************************************************************
 * IsInInventory
 *****************************************************************
 */
function bool IsInInventory(Inventory inv){
   local Inventory temp;

   temp = Inventory;
   while (temp != none){
      if (temp == inv) { return true; }
      temp = temp.inventory;
   }
   return false;
}

//===========================================================================
//===========================================================================
// DAMAGE RELATED FUNCTIONS
//===========================================================================
//===========================================================================



/*****************************************************************
 * TakeDamage
 * Like the normal take damage but doesn't add velocity to the player
 * if they are mounted in a mount point.
 *****************************************************************
 */
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                     vector momentum, class<DamageType> damageType)
{
    local AdvancedPlayerController apc;
    local E_HitPart hitPart;

    apc = AdvancedPlayerController(Controller);
    SetBoredomTimer(true);
    Spawn(BloodEmitter,,,HitLocation);


  //Log(Damage $ " Damage caused by: " $ instigatedBy);

    Damage = Damage * DiffDamageMultiplier;
    // SV:: fire damage gets set to 0 here, reset it to 1
    if(Damage < 1)
        Damage = 1;

    if (Damage < MinimumDamageThreshold){
      PlayHit(Damage,InstigatedBy, hitLocation, damageType, Momentum);
      Damage = 0; //still want momentum'n'stuff applied
    }

    //We only add the velocity to the player if they are NOT
    //mounted. This is to stop them from jumping around'n'stuff
    if ( apc != None && objMount != None ){
        momentum = vect(0,0,0);
    }


    if ( bUseSpecialDamage
            && damageType.default.bNoSpecificLocation==false
            && !bGodMode) {
        Damage = DoSpecialDamage(HitLocation,Momentum, Damage);
    }
    else if ( bDoHeadShots == true ) {
        hitPart = CalcHitPart( hitLocation );
        if ( hitPart == HIT_Head && TakeHeadShotsFrom(instigatedBy) ) {
            // head shots are really fatal!
            damage *= 100;
            Level.Game.Broadcast( instigatedBy, HeadShotTxt,
                                  class'AdvancedHud'.default.INFO );
        }
    }

    // ignore any fatal damage, after final damage has been calculated...
    if ( bGodMode && damage >= health ) {
        if ( apc != None ) {
            apc.numFailures++;
        }
        health = default.health;
        damage = 0;
    }


    if ( apc != None ) apc.ClientFlash(0.5,vect(1000,0,0));
    Super.TakeDamage( Damage, instigatedBy, hitlocation,
                      momentum, damageType );

    //apply damage from the parent functions first
    if (VSize(Momentum) > 10000 && Health > 0 ){
       FallDown(Momentum);
       if(PlayerController(Controller) != none){
        AdvancedPlayerController(Controller).Fall(); // camera effect
       }

    }
}


/*****************************************************************
 * CalcPlayTime
 * Calculates the current playtime, and returns the updated value
 *****************************************************************
 */
function int CalcPlayTime(){
  PlayTime = PlayTime + Level.TimeSeconds - StartPlayTime;
  StartPlayTime = Level.TimeSeconds;
  return PlayTime;
}


/****************************************************************
 * DoSpecialDamage
 * Some times hitting close to a paricular bone should do special
 * damage.
      //Distance = VSize(HitLocation - SpecialBoneLoc);
 ****************************************************************
 */
function int DoSpecialDamage( vector Hitlocation, vector HitDirection,
                              int Damage ) {
   local vector SpecialBoneLoc;
   local int close;
   local float distance;
   local int i;
   local int BestDamageIndex;
   local float BestDistance;

   BestDamageIndex = -1;
   BestDistance = -1;

   if (Damage <= 0){
      return Damage;
   }

   //look at all special damage
   for (i=0; i< SpecialDamage.length; i++){
      Close = SpecialDamage[i].ReqMinHitDistance;
      if (SpecialDamage[i].BoneName == 'Head' && Level.GetLocalPlayerController().Pawn.Weapon != none &&
      AdvancedWeapon(Level.GetLocalPlayerController().Pawn.Weapon).bAiming)
      {
        Close = Close * 2;
      }
      SpecialBoneLoc = GetBoneCoords(SpecialDamage[i].BoneName).Origin + SpecialDamage[i].Offset;
      Distance = PointLineDistance(SpecialBoneLoc, HitLocation, HitDirection);
                  // Log( self @ SpecialDamage[i].BoneName $ " : " $ SpecialBoneLoc $ " Distance:" $ Distance )    ;

      //found something that needs special damage applied
      if (Distance < Close && SpecialDamage[i].bCompleted == false){

                     // Log( self @ "Bone in range for damage is : " $ SpecialDamage[i].BoneName )    ;
         if (BestDistance == -1 || Distance < BestDistance){
            BestDamageIndex = i;
            BestDistance = Distance;
                        // Log( self @ "New Better bone : " $ SpecialDamage[i].BoneName )    ;
         }
      }
   }

    if (BestDamageIndex != -1) {
        Damage = Damage * SpecialDamageAtIndex(BestDamageIndex);
        //do any required subdamage here!
        for (i=0; i < SpecialDamage[BestDamageIndex].SubDamageBones.length; i++) {
                        // Log( self @ "Also blowing up : " $ SpecialDamage[BestDamageIndex].SubDamageBones[i]  )    ;
            SpecialDamageAtIndex(
                getSpecialDamageIndex( SpecialDamage[BestDamageIndex]
                                        .SubDamageBones[i] ) );
        }
    }

                // Log( self @ "Damage is :" $ Damage )    ;
    return Damage;
}

/**
 * returns the index of the specified bone from the special damage array, or
 * -1 if not present.
 */
function int getSpecialDamageIndex( name bone ) {
    local int i;

    for ( i = 0; i < SpecialDamage.length; ++i ) {
        if ( SpecialDamage[i].BoneName == bone ) return i;
    }
    return -1;
}

/*****************************************************************
 * SpecialDamageAtIndex
 *****************************************************************
 */
function float SpecialDamageAtIndex(int i) {

   local AdvancedSkeletalEmitter SkelEmit;

    if ( i < 0 || i >= SpecialDamage.length ) return 1;

    if (SpecialDamage[i].DamageEmitter != none){
        CurrentSpecialDamageEmitter
            = Spawn( SpecialDamage[i].DamageEmitter,,,
                     GetBoneCoords(SpecialDamage[i].BoneName).Origin );
        AttachToBone(CurrentSpecialDamageEmitter, SpecialDamage[i].BoneName);
    }

    if (SpecialDamage[i].AdvancedEmitter != none){
        SkelEmit = Spawn( SpecialDamage[i].AdvancedEmitter,,,
                     GetBoneCoords(SpecialDamage[i].BoneName).Origin, Rotation );
        //SkelEmit.SetPhysics(PHYS_Falling);
        //AttachToBone(SkelEmit, SpecialDamage[i].BoneName);
    }


    iDamagedBoneIndex = i;
    SetBoneScale(i,0.001,SpecialDamage[i].BoneName);
    SpecialDamage[i].bCompleted = true;
    if ( SpecialDamage[i].bFatal ) {
        return default.health;
    }
    else if (SpecialDamage[i].DamageMod > 0) {
        return SpecialDamage[i].DamageMod;
    }
    else {
        return 1;
    }
}



/*****************************************************************
 * PointLineDistance
 * Returns the distance to the closest point on a line from a given point
 *****************************************************************
 */
function float PointLineDistance(vector point, vector Line1, vector Line2){
   return Vsize((Line2 - Line1) cross (Line1 - Point)) /
                        Vsize(Line2 - Line1);
}


/*****************************************************************
 * ConfirmBonesUndamaged
 * Doing Special damage might make these melee attacks useless. We
 * check the list of required bones for the melee attack agaist the
 * list of damaged bones in the specialdamage list
 *****************************************************************
 */
function bool ConfirmBonesUndamaged(array<name> ReqBones){

   local int i,j;

   //check all the damage so far to see if your required bones are in
   //the list of damaged bones
   for (i=0;i<SpecialDamage.length;i++){
      for (j=0;j<ReqBones.length;j++){
         if (SpecialDamage[i].bCompleted == true &&
             SpecialDamage[i].BoneName == ReqBones[j]){
            return false;
         }
      }
   }
   return true;
}



/****************************************************************
 * TakeHeadShotFrom
 * Allow subclasses to chose who is allowed to get head shots on this
 * pawn.
 ****************************************************************
 */
function bool TakeHeadShotsFrom( Pawn instigator ) {
    return true;
}

/****************************************************************
 * Died
 ****************************************************************
 */
function Died( Controller killer, class<DamageType> damageType,
               vector hitLocation ) {
    local actor DeathActor;
    local AdvancedPawn advKiller;

    super.Died( killer, damageType, hitLocation );
    xGamerTag = "";
    advKiller = AdvancedPawn(killer.Pawn);
    if ( advKiller != none ) advKiller.kills++;

    //if ( FancyShadow != none ) FancyShadow.bShadowActive = false;

    //turn off all timers just in case
    SetMultiTimer( WEAPON_NAME, 0, false );
    SetMultiTimer( GRENADE_RELEASE, 0, false);
    SetMultiTimer( FOOTSTEP_ID, 0, true);


    AdvancedGameInfo(Level.Game).QueueEvent( onKilledEvent, self, killer.pawn );
    PlayDyingSound();

    CleanupMultiPlayerAttachments();

    //make it look like you dropped an item
    if (DeathActorTag != ''){
       ForEach AllActors(class'Actor', DeathActor, DeathActorTag){
          DeathActor.SetLocation(Location);
          DeathActor.SetPhysics(PHYS_FALLING);
       }
    }
}

/****************************************************************
 * CalcHitPart
 ****************************************************************
 */
function E_HitPart CalcHitPart( vector hitLocn ) {
    local vector X,Y,Z,Dir;
    GetAxes(Rotation,X,Y,Z);
    Dir = Normal(hitLocn - Location);

    if ( (Dir dot X) < 0 ) {
        return HIT_Back;
    }
    else if ( (Dir dot X) > 0
              && (hitLocn.Z > (Location.Z + CollisionHeight * 0.8)) ) {
        // Hit the head (i.e. Front, 90% or up)
        return HIT_Head;
    }
    else if ( ((Dir Dot X) > 0.7) || (hitLocn.Z < Location.Z) ) {
        return HIT_Chest;
    }
    else if ( (Dir Dot Y) > 0 ){
        return HIT_Right;
    }
    else {
        return HIT_Left;
    }
}


/*****************************************************************
 * TakeDrowningDamange
 *****************************************************************
 */
function TakeDrowningDamage() {
   local Vector SomePlace;
   SomePlace = Location + CollisionHeight *
      vect(0,0,0.5)+ 0.7 * CollisionRadius * vector(Controller.Rotation);
   TakeDamage(5, None, SomePlace, vect(0,0,0), class'Drowned');
}


/*****************************************************************
 * ChunkUp - Pawn was killed - detach any controller and die
 *****************************************************************
 */
function ChunkUp( Rotator HitRotation, class<DamageType> D ) {
    // this isn't deathmatch - no unneccessary chunking!
   //Prof - but you can get some problems if you don't destroy the
   //    pawn here. This is notification of damage after already dead.
   //    if ( Health <= 0 ) return;

    if (gibSound.Length > 0) {
       PlayOwnedSound (gibSound[Rand (gibSound.Length)], SLOT_None, 1);
    }
    PlayDyingSound ();

    if ((Level.NetMode != NM_Client) && (Controller != None)) {
        Controller.PawnDied(self);
    }

    bTearOff = true;
    HitDamageType = class'Gibbed'; // make sure clients gib also
    if ((Level.NetMode == NM_DedicatedServer)
        || (Level.NetMode == NM_ListenServer)) {
       GotoState ('TimingOut');
    }
    if (Level.NetMode == NM_DedicatedServer) { return; }
    if (class'GameInfo'.static.UseLowGore ()) {
        Destroy ();
        return;
    }
    SpawnGibs(HitRotation, D);
    if (Level.NetMode != NM_ListenServer) { Destroy (); }
}


/*****************************************************************
 * SpawnGibs - local not replicated
 *****************************************************************
 */
function SpawnGibs (Rotator HitRotation, class<DamageType> D) {
   Spawn( SplutEmitter );
}


/*****************************************************************
 * ShouldDoRagDoll
 *****************************************************************
 */
function bool ShouldDoRagDoll() {
    local int numRagDolls;
    local int limit;

    limit = 1;
    if ( Level.PhysicsDetailLevel == PDL_Medium ) {
        limit = 2;
    }
    else if ( Level.PhysicsDetailLevel == PDL_High ) {
        limit = 3;
    }

    numRagDolls = default.NumActiveRagdolls;
    if ( Level.bDropDetail || numRagdolls >= limit ) {
        return false;
    } else {
        return true;
    }
}


/*****************************************************************
 * DoRagDoll
 *****************************************************************
 */
function DoRagDoll(class<DamageType> DamageType){

    local float maxDim;
    local vector shotStrength;
    local vector shotDir;
    local KarmaParamsSkel skelParams;
    local vector hitLocRel;
    local vector deathAngVel;

   // if we managed to find a name, try and make a rag-doll slot availbale
   if (RagSkelName != "") KMakeRagdollAvailable();
   if ( KIsRagdollAvailable() && RagSkelName != "" ) {
      Velocity += 4*TearOffMomentum;
      skelParams = KarmaParamsSkel(KParams);
      skelParams.KSkeleton = RagSkelName;
      StopAnimating (true);

      if (DamageType != None && DamageType.Default.bKUseOwnDeathVel) {
         RagDeathVel = DamageType.Default.KDeathVel;
         RagDeathUpKick = DamageType.Default.KDeathUpKick;
      }

      shotDir = Normal (TearOffMomentum);
      shotStrength = Min (VSize (TearOffMomentum), RagDeathVel)*shotDir;
      hitLocRel = TakeHitLocation - Location;
      hitLocRel.X *= RagSpinScale + Frand()*20;
      hitLocRel.Y *= RagSpinScale+ Frand()*20;
      if (VSize (TearOffMomentum) < 0.01) {
         deathAngVel = VRand ()*18000.0;
      }
      else {
         deathAngVel = (hitLocRel Cross shotStrength);
      }
      skelParams.KStartLinVel.X = 0.6 * Velocity.X;
      skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
      skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
      skelParams.KStartLinVel  += shotStrength;

      // if not moving downwards, give extra upward kick
      if (Velocity.Z > -10) {
         skelParams.KStartLinVel.Z += RagDeathUpKick;
      }
      skelParams.KStartAngVel = deathAngVel;
      // deferred shot-bone impulse
      maxDim = Max (CollisionRadius, CollisionHeight);
      skelParams.KShotStart    = TakeHitLocation - (1*shotDir);
      skelParams.KShotEnd      = TakeHitLocation + (2*maxDim*shotDir);
      skelParams.KShotStrength = RagShootStrength;
      // karma collision for ragdoll.
      KSetBlockKarma(true);
      // set physics mode to ragdoll, Doesn't start immediate,
      // it is deferred to first tick.
      SetPhysics(PHYS_KarmaRagdoll);
      default.NumActiveRagdolls = default.NumActiveRagdolls + 1;
   }
}



//===========================================================================
//===========================================================================
// SOUND RELATED FUNCTIONS
//
// -Footstep noises
// -impact noises
// -death noises
//===========================================================================
//===========================================================================



/*****************************************************************
 * DoFootStep
 * Decides if you should do a footsteppy noise
 *****************************************************************
 */
function DoFootStep(){


   local float GroundSpeedRatio;
   local float timerAdjustment;

   //if you are in a cinematic, or controlled by an AI,
   //or not supposed to do it.
   if (Controller == None ||
       AIController(Controller) != None ||
       !bDoFootSteps){
      return;
   }

   GroundSpeedRatio = VSize(velocity * vect(1,1,0)) / GroundSpeed;
   if (GroundSpeedRatio == 0){
      SetMultiTimer( FOOTSTEP_ID, FOOTSTEP_INTERVAL, true);
   } else {
      timerAdjustment = (1 - GroundSpeedRatio) * 0.2;
      SetMultiTimer( FOOTSTEP_ID, FOOTSTEP_INTERVAL + TimerAdjustment, true);
   }

   //if you should do the footstep sound if you are walking or you
   //just landed from a jump
   if ((Controller.IsInState('PlayerWalking') &&
      (Velocity.X != 0 || Velocity.Y != 0) &&  Physics == PHYS_WALKING ||
       bJustLanded==true) &&
       Level.TimeSeconds - LastFootStep > 0.4 ){

         LastFootStep = Level.TimeSeconds;
        PlayFootStep();
   }
}

/*****************************************************************
 * PlayFootStep
 * Play the noise
 *****************************************************************
 */
function PlayFootStep(){

   local Material FloorMat;
   local vector hl,hn,Start,End;
   local Sound MatSpecSound;
   local Actor A;

         Start = Location - Vect(0,0,1)*CollisionHeight;
         End = Start - Vect(0,0,16);
         A = Trace(hl,hn,End,Start,false,,FloorMat);
         if (FloorMat !=None){

         switch (FloorMat.SurfaceType){
         case EST_DIRT:
            MatSpecSound = FootStepDirt[int(Frand()*FootStepDirt.length)];
            break;
         case EST_METAL:
            MatSpecSound = FootStepMetal[int(Frand()* FootStepMetal.length)];
            break;
         case EST_PLANT:
            MatSpecSound = FootStepPlant[int(Frand()* FootStepPlant.length)];
            break;
         case EST_ROCK:
            MatSpecSound = FootStepRock[int(Frand()* FootStepRock.length)];
            break;
         case EST_WATER:
            MatSpecSound = FootStepWater[int(Frand()* FootStepWater.Length)];
            break;
         case EST_WOOD:
            MatSpecSound = FootStepWood[int(Frand()* FootStepWood.length)];
            break;
         case EST_ICE:
            MatSpecSound = FootStepIce[int(Frand()* FootStepIce.length)];
            break;
         case EST_SNOW:
            MatSpecSound = FootStepSnow[int(Frand()* FootStepSnow.length)];
            break;
         case EST_GLASS:
            MatSpecSound = FootStepGlass[int(Frand()* FootStepGlass.length)];
            break;
         default:
            MatSpecSound = FootStepSound[int(Frand()* FootStepSound.length)];
         }
       }
      if (MatSpecSound == None){
         PlaySound(FootStepSound[int(Frand()* FootStepSound.length)], SLOT_NONE, FootStepVolume);
      } else {
         PlaySound(MatSpecSound, SLOT_NONE, FootStepVolume);
      }

      //for AI to hear you
      if ( bIsWalking) MakeNoise( 0.1 );
      else MakeNoise( 0.3 );

}


/*****************************************************************
 * KImpact - Called when in Ragdoll when we hit something over a
 * certain threshold velocity. Used to play impact sounds.
 *****************************************************************
 */
event KImpact (actor other, vector pos, vector impactVel, vector impactNorm) {

    local int numSounds;
    local int soundNum;

    numSounds = RagImpactSounds.Length;
    if (numSounds > 0&&Level.TimeSeconds>RagLastSoundTime+RagImpactSoundInterval){
        soundNum = Rand (numSounds);
        PlaySound (RagImpactSounds[soundNum], SLOT_Pain, RagImpactVolume);
        RagLastSoundTime = Level.TimeSeconds;
    }
}


/*****************************************************************
 * PlayDyingSound
 *****************************************************************
 */
function PlayDyingSound () {
    if (deathSounds.Length > 0 && !bPlayedDeathSound ) {
        bPlayedDeathSound = true;
        PlaySound( deathSounds[Rand(deathSounds.Length)], SLOT_None, 1 );
    }
}

/*****************************************************************
 * PlayHitSound
 *****************************************************************
 */
function PlayHitSound(){
    //make some death rattle
    if ( HitSounds.Length > 0 && Health > 0 ) {
        PlaySound(HitSounds[Frand() * HitSounds.length]);
    }
}


//===========================================================================
//===========================================================================
// VISUAL RELATED FUNCTIONS
//
// - HUD render stuff
// - view adjustment
//===========================================================================
//===========================================================================




/*****************************************************************
 * ViewKick
 * If you don't provide a direction then offset is random
 *****************************************************************
 */
function ViewKick(int Magnitude, optional rotator Direction){

   local rotator HitOffset;
   local AdvancedPlayerController apc;

   if (Magnitude <= 0 || bDamageKicksView == false
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

/****************************************************************
 * DrawHUD
 * A call from the HUD to do the draw stuff
 ****************************************************************
 */
function DrawToHUD( Canvas C, float scaleX, float scaleY ){
    local AdvancedWeapon aw;
    local float width, height;

    c.SetDrawColor( 255,255,255,0 );

    //kill counter
    if (bDisplayKills){
        c.SetPos( (1060 * scaleX) - width, 50 * scaleY );
        c.DrawText( "Kills: " $ kills );
    }

    if (weapon !=None){
        //Log("PAWN pre calls weapon");
    }
    // delegate to weapon...
    aw = AdvancedWeapon( weapon );
    if (aw != None) aw.drawToHud( c, scaleX, scaleY );

    // delegate to health bar...

    super.DrawHUD(C);
    //delegate to the arms
    if (MyArms !=None){
       MyArms.DrawToHud(C,scaleX,scaleY);
    }

    if ( bShowInventory ) {
        drawInventory( c, scaleX, scaleY );
        c.TextSize( hudWeaponName, width, height );
        c.SetPos( (WEAPON_NAME_CENTRE * scaleX) - width, WEAPON_NAME_Y * scaleY );
        c.DrawText( hudWeaponName );
    }



}

/****************************************************************
 * DrawInventory
 * Removed as it appears to crash the clients. Don't know if removing this
 * will fix the issue or just move it. I suspect move it, but then who has
 * time to actually look at issues. No one care how good your code is, just how
 * fast you fix stuff. Great! It's a wonder this industry got created in the first
 * place!!!
 ****************************************************************
 */
function DrawInventory( Canvas c, float scaleX, float scaleY ) {
   // local Inventory      Inv;
//    local HeavyWeapon    hweap;
//    local MediumWeapon   mweap;
//    local LightWeapon    lweap;
   // local AdvancedWeapon weap;
/*
    for ( Inv=Inventory; Inv!=None; Inv=Inv.Inventory ) {
        weap = AdvancedWeapon( inv );
        if ( weap == None ) continue;
        if ( weap.icon == None) continue;

        // setup highlighting...
        if ( weap == weapon ) c.SetDrawColor( 255, 255, 128, 0 );
        else c.SetDrawColor( 255,255,255, 128 );

        c.SetPos( 1240 * scaleX, 300 * scaleY );
        c.DrawText( "#4" );
        c.SetPos( 975 * scaleX, 270 * scaleY );
        c.DrawTile( weap.icon,
                    weap.iconWidth * scaleX, weap.iconHeight * scaleY,
                    weap.iconOffsetU, weap.iconOffsetV,
                    weap.iconWidth, weap.iconHeight );
    }
*/
    // restore a neutral draw color
    c.SetDrawColor( 255,255,255,0 );
}

/****************************************************************
 * DrawDebugToHud
 * A call from the HUD to do the draw stuff
 ****************************************************************
 */
function DrawDebugToHud( Canvas c, float scaleX, float scaleY ) {
    local string HealthLeft;
    local AdvancedWeapon aw;

    DrawDebugToHud( c, scaleX, scaleY );

    //draw remaining health...
    HealthLeft = String(Health);
    C.SetPos( 750 * scaleX, 100 * scaleY );
//    C.Font = C.SmallFont;
   C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
    C.DrawText("Health: "$ HealthLeft);

    // delegate to weapon...
    aw = AdvancedWeapon( weapon );
    if (aw != None) aw.drawDebugToHud( c, scaleX, scaleY );

}




//===========================================================================
//===========================================================================
// ANIMATION FUNCTIONS
//
// -lower level function relating to animation notification
// -functions relating to animation co-ordination
//===========================================================================
//===========================================================================

/**
 * e.g. "DOTZACharacters.Scuttler"
 */
function SwapAnimationSet( string AnimationSetName ) {
    local MeshAnimation Anim;
    // switch animation set
    Anim = MeshAnimation( DynamicLoadObject(AnimationSetName,
                                            class'MeshAnimation') );
    if ( Anim != none ) {
                    // Log( self @ "******* swapping" @ self @ AnimationSetName  )    ;
        SwappedAnimSet = AnimationSetName;
        LinkSkelAnim( Anim );
    }
}

/*****************************************************************
 * PlaySpawnAnim
 * Spawn anims are anims that are done before the pawn does anything
 * else. They make use of the focusedanimation tech to ensure that
 * nothing else interfers with this animation. The pawn is also
 * invinsible to prevent the player screwing with our nice looking animation.
 *****************************************************************
 */
function PlaySpawnAnim(){

   local int iSpawnIndex;
   //play a start up animation
   bHidden = false;
   if (AnimSpawn.Length > 0){
      iSpawnIndex = Frand() * AnimSpawn.Length;
      if (HasAnim(AnimSpawn[iSpawnIndex])){
         bPlayingSpawn = true;
         bWasGodMode = bGodMode;
         bGodMode = true;
         SetCollision(false,false,false);
         //PlayFocusedAnimation(AnimSpawn[iSpawnIndex]);
         AdvancedPlayAnim(AnimSpawn[iSpawnIndex],,,,false,true);
         SetPhysics(PHYS_Falling);
      }
   }
}

/*****************************************************************
 * SpawnAnimEnd
 * Focusedanimation calls this when it recieves its focusedanimend
 * call, we go back into normal pawn mode here.
 *****************************************************************
 */
function SpawnAnimEnd(){

   bPlayingSpawn = false;
   bGodMode = bWasGodMode;
   SetCollision(default.bCollideactors, default.bBlockActors,
                default.bBlockPlayers);
    // SV: forcing an idle animation seems to solve the T-pose issue
    //PlayWeaponIdle();
    AdvancedPlayAnim(Idle,,tweentime,,true);
}


/*****************************************************************
 * CheckLanding
 *****************************************************************
 */
function CheckLanding () {
    // stop animating
    if (Physics == PHYS_Falling) { TweenAnim ('Land', 9000.0); }
}



/*****************************************************************
 * SetMovementPhysics
 *****************************************************************
 */
function SetMovementPhysics () {
    if ( Physics == PHYS_Falling || bFreezeMovement ) {
        return;
    }
    else if (PhysicsVolume.bWaterVolume) {
        SetPhysics (PHYS_Swimming);
    }
    else SetPhysics (PHYS_Walking);
}



/*****************************************************************
 * PlayDying
 *****************************************************************
 */
function PlayDying (class<DamageType> DamageType, vector HitLoc) {
    bCanTeleport       = false;
    bPlayedDeath       = true;
    bReplicateMovement = false;
    bTearOff           = true;
    AmbientSound       = None;
    HitDamageType      = DamageType;
    TakeHitLocation    = HitLoc;
    AnimBlendParams(1, 0.0);
    LifeSpan           = RagdollLifeSpan;
    GotoState ('Dying');

    if ( Level.NetMode == NM_DedicatedServer ) return;

    // don't bother with death fanciness on guys that aren't in view...
    if ( Level.NetMode == NM_StandAlone && !bAlwaysPlayDying &&
       (Level.TimeSeconds - LastRenderTime) > 3) {
        Destroy ();
        return;
    }

    if ( shouldDoRagDoll() ) {
       DoRagDoll(DamageType);

    }
    else {
        SetCollision(false,false,false);
        // non-ragdoll death fallback
        Velocity     += TearOffMomentum;
        BaseEyeHeight = Default.BaseEyeHeight;
        SetPhysics(PHYS_Falling);

        AnimBlendToAlpha(FIRINGCHANNEL, 0, 0.1);
        AnimBlendToAlpha(TAKEHITCHANNEL, 0, 0.1);
        AnimBlendToAlpha(FALLINGCHANNEL, 0, 0.1);
        AnimBlendToAlpha(IDLECHANNEL, 0, 0.1);
        PlayDyingAnim(DamageType, HitLoc);
    }
}

/*****************************************************************
 * PlayDyingAnim
 *****************************************************************
 */
simulated function PlayDyingAnim(class<DamageType> DamageType,vector HitLoc){
   local float deathType;
   deathType = FRand();

   GroundSpeed = default.GroundSpeed;
   WalkingPct = 1;


   //mostly die backwards
   if ( deathType < 0.4 ){
      AdvancedPlayAnim(DeathBack,1,tweentime);
   } else if (deathType < 0.6) {
      AdvancedPlayAnim(DeathLeft,1,tweentime);
   } else if (deathType < 0.8 ){
      AdvancedPlayAnim(DeathRight,1,tweentime);
   } else {
      AdvancedPlayAnim(DeathForward,1,tweentime);
   }
}


/*****************************************************************
 * SetAnimation
 * ONLY runs clientside
******************************************************************
 */
simulated event SetAnimAction (name NewAction, bool bLoopingAnim, int iAnimChannel, bool bFocused) {

   local int i;

    if (Role < ROLE_Authority){     //client
      // log("playering " $ NewAction $ " on channel " $ iAnimChannel $ " " $ bFocused);

        //yes, a hack, because all calls that have a channel specified use this bone so far!
        if (iAnimChannel !=0){
           AnimBlendParams(iAnimChannel, 1, 0,, FIRINGBLENDBONE);
        }
        if (bFocused == true){
            //iAnimChannel = TAKEHITCHANNEL;
//            bClientFocused = true;
//            SetBoneRotation(LOOKINGBLENDBONE, rot(0,0,0));
            //StopAnimating(true);
            AnimBlendParams(FOCUSCHANNEL,1);
            //if (iAnimRate <= 0){
            //    iAnimRate = 1;
            //}
            // clear all other channels, since they won't get their AnimEnd
            // calls anyways...
            for ( i = 0; i < NUM_CHANNELS; ++i ) {
                if ( i != FOCUSCHANNEL ) {
                    AnimBlendToAlpha( i, 0, 0.05 );
                }
            }
        }


        if (bLoopingAnim==false){
            PlayAnim(AnimAction,1.1,0.2,iAnimChannel);
        } else {
            LoopAnim(AnimAction,1,0.2,iAnimChannel);
        }
        if (Health <= 0){
            CleanUpMultiplayerAttachments();
        }

    }
}

/*****************************************************************
 * AdvancedPlayAnim
 * The server side management of clien animations
 *****************************************************************
 */
function AdvancedPlayAnim( name Sequence, optional float Rate,
                           optional float TweenTime, optional int Channel,
                           optional bool bLoop, optional bool bFocus){
   bLoopingAnim = bLoop;
   AnimAction = Sequence;
   bFocused = bFocus;
   iAnimChannel = Channel;

   if (AnimAction == Sequence){
      bAnimAgainToggle = ! bAnimAgainToggle;
   }
    if (Rate == 0) { Rate = 1; } //zero rates are bad apparently
    //Log (sequence);
    if (bLoop){
      LoopAnim(Sequence, Rate, TweenTime, Channel);
    } else if (bFocus) {
      PlayFocusedAnimation(Sequence, Rate);
    }else {
      PlayAnim(Sequence, Rate, TweenTime, Channel);
    }
}




/*****************************************************************
 * SwitchToStanding
 * Do whatever needs to be done to make standing work right...
******************************************************************
 */
simulated function SwitchToStanding() {

    Idle         = AnimStandIdle;
    BoredAnimList    = BoredStandingAnimList;
    AnimFire     = AnimStandFire;
    HitRight     = AnimStandHitRight;
    HitLeft      = AnimStandHitLeft;
    HitFront     = AnimStandHitFront;
    HitBack      = AnimStandHitBack;
    HitHead      = AnimStandHitHead;

    //deaths
    DeathBack = AnimStandDeathBack;
    DeathForward = AnimStandDeathForward;
    DeathLeft = AnimStandDeathLeft;
    DeathRight = AnimStandDeathRight;

    if (bIsWalking) {

       TurnLeftAnim     = AnimWalkTurnLeft;
       TurnRightAnim    = AnimWalkTurnRight;
       MovementAnims[0] = AnimWalkForward;
       MovementAnims[1] = AnimWalkBack;
       MovementAnims[2] = AnimWalkLeft;
       MovementAnims[3] = AnimWalkRight;
    }
    //Do normal non-crouch non-walk move
    else {

       TurnLeftAnim     = AnimRunTurnLeft;
       TurnRightAnim    = AnimRunTurnRight;
       MovementAnims[0] = AnimRunForward;
       MovementAnims[1] = AnimRunBack;
       MovementAnims[2] = AnimRunLeft;
       MovementAnims[3] = AnimRunRight;
    }
}

/*****************************************************************
 * SwitchToCrawling
 * Do whatever needs to be done to crawling work right
******************************************************************
 */
simulated function SwitchToCrawling(){

    Idle         = AnimCrawlIdle;
    AnimFire     = AnimCrawlFire;
    HitRight     = AnimCrawlHitRight;
    HitLeft      = AnimCrawlHitLeft;
    HitFront     = AnimCrawlHitFront;
    HitBack      = AnimCrawlHitBack;
    HitHead      = AnimCrawlHitHead;

    TurnLeftAnim     = AnimCrawlTurnLeft;
    TurnRightAnim    = AnimCrawlTurnRight;
    BoredAnimList    = BoredCrawlAnimList;

    MovementAnims[0] = AnimCrawlForward;
    MovementAnims[1] = AnimCrawlBack;
    MovementAnims[2] = AnimCrawlLeft;
    MovementAnims[3] = AnimCrawlRight;

    //deaths
    DeathBack = AnimCrawlDeathBack;
    DeathForward = AnimCrawlDeathForward;
    DeathLeft = AnimCrawlDeathLeft;
    DeathRight = AnimCrawlDeathRight;


    //extra stuff that we must handle because this crawling state is
    //not part of the default code base
    StartCrawl();
}

/*****************************************************************
 * SwitchToCrouching
 * do whatever needs to be done to make crouching work right...
******************************************************************
 */
simulated function SwitchToCrouching() {

   if (!bCanCrouch){
      return;
   }
    Idle         = AnimCrouchIdle;
    BoredAnimList    = BoredCrouchingAnimList;
    AnimFire     = AnimCrouchFire;
    HitRight     = AnimCrouchHitRight;
    HitLeft      = AnimCrouchHitLeft;
    HitFront     = AnimCrouchHitFront;
    HitBack      = AnimCrouchHitBack;
    HitHead      = AnimCrouchHitHead;

    TurnLeftAnim     = AnimCrouchTurnLeft;
    TurnRightAnim    = AnimCrouchTurnRight;
    MovementAnims[0] = AnimCrouchForward;
    MovementAnims[1] = AnimCrouchBack;
    MovementAnims[2] = AnimCrouchLeft;
    MovementAnims[3] = AnimCrouchRight;

    //deaths
    DeathBack = AnimCrouchDeathBack;
    DeathForward = AnimCrouchDeathForward;
    DeathLeft = AnimCrouchDeathLeft;
    DeathRight = AnimCrouchDeathRight;

}

/*****************************************************************
 *
 *****************************************************************
 */
function FreezeMovement(bool freeze, optional bool usePhysics){
    if (freeze == true){
        bFreezemovement = true;
        // SV:: ground speed should not be set to 0 (locks up otherwise)
        groundspeed = 0.1;
        rotationrate = rot(0,0,0);
        if (usePhysics == false){
            //setting physics to none in multiplayer, means rotations still get replicated
            //and dudes can spin around in 3d, very dumb
            if (Level.NetMode == NM_StandAlone){
               SetPhysics(PHYS_NONE);
            }
        }
    } else {
        groundSpeed = default.GroundSpeed;
        rotationrate = default.RotationRate;
        bFreezeMovement = false;
    }
}



/*****************************************************************
 * ChangeAnimation
 *****************************************************************
 */
simulated event ChangeAnimation () {

//   Log( self $ "ChangeAnimation");

   if ( (Controller != None) && Controller.bControlAnimations ) return;
   // player animation - set up new idle and moving animations
   PlayWaiting();
   PlayMoving();
}



/*****************************************************************
 * AnimateStanding
 *****************************************************************
 */
function AnimateStanding () {

    // swap to crawling idles if necessary...
    if ( bIsCrawling ) {
        SwitchToCrawling();
    }
    // swap to crouch idles if necessary...
    else if ( bIsCrouched && bIsCrawling == false ) {
        switchToCrouching();
    }
    // swap to standing idles if necessary...
    else if ( !bIsCrouched && bIsCrawling == false ) {
        switchToStanding();
    }

    // if it's been enough time play an appropriate animation &&
    // not in a cinematic
    if (BoredAnimNum >= 0 && BoredAnimNum < BoredAnimList.length &&
        Level.GetLocalPlayerController() != none &&
        Level.GetLocalPlayerController().Pawn !=None){
        AdvancedPlayAnim(BoredAnimList[BoredAnimNum],,tweentime);
        BoredAnimNum = -1;

    } else {
      PlayWeaponIdle();
     // Log(self $ "Play idle animation ");
      AdvancedPlayAnim(Idle,,tweentime,,true);
      //PlayAnim(Idle,,tweentime);
    }

    //if in a cinematic quell the idles completely
    if (Level.GetLocalPlayerController() !=None &&
        Level.GetLocalPlayerController().Pawn ==None){
        BoredAnimNum = -1;
    }

    //turn on a bored timer
    if ( BoredomTimerActive == false ){
        //turn on the boredom timer
        SetBoredomTimer(True);
    }
}


exec function A(){
   PlayerController(Controller).ToggleBehindView();
}

exec function Q(){
   PlayWeaponIdle();
}

simulated function ClientPlayWeaponIdle(){

   //Log(self $ "client play weapon idel");

   if (NetWeaponIdle != ''){
      AnimBlendParams( IDLECHANNEL,1,,,FIRINGBLENDBONE);
      PlayAnim( NetWeaponIdle, 1, 0, IDLECHANNEL );
   }
//   Log(self $ " PlayWeaponIdle: " $ NetWeaponIdle);

}

//idles are based on current weapon  then couched/crawl state
function PlayWeaponIdle()
{
   //this function makes no sense if you don't have a weapon
   if (Weapon == none || AdvancedWeapon(Weapon)== none){
      return;
   }

   CurrentAddAnimPkg = AdvancedWeapon(Weapon).PawnAnimationPackage;
   NetWeaponIdle = GetWeaponIdle();
   if (NetWeaponIdle !=''){
      AnimBlendParams( IDLECHANNEL,1,,,FIRINGBLENDBONE);
      PlayAnim( NetWeaponIdle, 1, 0, IDLECHANNEL );
   }
}

/*****************************************************************
 * GetWeaponIdle
 *****************************************************************
 */
simulated function name GetWeaponIdle(){
   if (Weapon == none){
      return '';
   }
   //Crawling
   if (bIsCrawling == true){
     return '';
   //Crouched
   } else if (bIsCrouched == true){
     if (AdvancedWeapon(Weapon) != none){
         return AdvancedWeapon(Weapon).GetCrouchIdleAnim();
     }
   //Standing
   } else {
      if (AdvancedWeapon(Weapon) != none){
         return AdvancedWeapon(Weapon).GetIdleAnim();
      }
   }
   return '';
}

/*****************************************************************
 * AnimEnd
 *****************************************************************
 */
simulated event AnimEnd (int Channel) {

   //if you are moving...
   if (Velocity.X > 0 || Velocity.Y >0 || Velocity.Z>0){
      //turn off the boredom timer
      SetBoredomTimer(false);
   }
   if (Channel == IDLECHANNEL){
      AnimBlendToAlpha (IDLECHANNEL,0, 0.05);
      PlayWeaponIdle();
      ClientPlayWeaponIdle();
   }

   if (Channel == 0) {
      PlayWaiting ();
   }

    else if (Channel == FIRINGCHANNEL)
    {
        // FIRINGCHANNEL used for upper body (firing weapons, etc.)
        if (!bSteadyFiring) {
           AnimBlendToAlpha (FIRINGCHANNEL, 0, 0.05);
        }
    }
    else if (Channel == TAKEHITCHANNEL)
    {
       AnimBlendToAlpha (TAKEHITCHANNEL, 0, 0.2);
    }
    else if (Channel == FALLINGCHANNEL)
    {
        if (Physics != PHYS_Falling) {
            AnimBlendToAlpha (FALLINGCHANNEL, 0, 0.1);
            PlayWaiting ();
        }
        else { PlayFalling (); }
    }
    else if (Channel == FOCUSCHANNEL){
         FocusedAnimEnd();
//         bClientFocused = false;
   }
}


/*****************************************************************
 * AnimateLanding
 *****************************************************************
 */
function AnimateLanding () {
    AdvancedPlayAnim (Idle,,tweentime);
}


/*****************************************************************
 * PlayFiring
 *****************************************************************
 */
simulated function PlayFiring (float Rate, name FiringMode) {

   local name WeaponFireAnim;

   //turn off the boredom timer
   SetBoredomTimer(false);

   if (Weapon.ThirdPersonActor != none){
      NetAtt = WeaponAttachment(Weapon.ThirdPersonActor);
   }

   if (Weapon != none){
      WeaponFireAnim = AdvancedWeapon(Weapon).GetFireAnim();
   }

   // Swap animation sets if neccessary...
   if (bIsCrawling){
       switchToCrawling();
       AnimFire =AnimCrawlFire;
   } else if (bIsCrouched) {
       AnimFire = AnimCrouchFire;
       switchToCrouching();
   } else {
       AnimFire = AnimStandFire;
       switchToStanding();
   }

   if (WeaponFireAnim != ''){ AnimFire = WeaponFireAnim; }

   //Log("Playing Animation: " $ AnimFire);

   if (!IsAnimating(FIRINGCHANNEL)){
      AnimBlendParams(FIRINGCHANNEL,1,,,FIRINGBLENDBONE);
      AdvancedPlayAnim(AnimFire,1,0,FIRINGCHANNEL);
      if (Role == ROLE_Authority){
         //Log("Playanim has toggled the flash toggle too: " $ FlashToggle);
         FlashToggle = !FlashToggle;
      }
   }
}


/*****************************************************************
 * PlayWaiting
 *****************************************************************
 */
function PlayWaiting () {

    if (Physics == PHYS_Falling) {
        if (!IsAnimating (FALLINGCHANNEL)) { PlayFalling (); }
    }
    else if (bSteadyFiring) { PlayFiring (1.0, ''); }
    else if ( Controller == None || Controller.bControlAnimations == false){
       AnimateStanding ();
    }
}


/*****************************************************************
 * PlayHit
 *****************************************************************
 */
function PlayHit( float Damage, Pawn InstigatedBy,
                  vector HitLocation, class<DamageType> damageType,
                  vector Momentum ) {
   Super.PlayHit(Damage, InstigatedBy,HitLocation, damageType,Momentum);
   if ( Health > 0 ) return;
   StopAnimating();
}


/*****************************************************************
 * PlayTakeHit
 *****************************************************************
 */
function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType) {
   local name HitAnim;
   local E_HitPart hitPart;

   //player feedback
   Spawn(BloodEmitter,,,HitLoc);
   PlayHitSound();
   ViewKick(ViewKickMagnitude);

   //animation bookkeeping
   SetBoredomTimer(false);
   AnimBlendParams(TAKEHITCHANNEL,1,,,FIRINGBLENDBONE );

   //try and use a weapon specific hit animation first
   if (AdvancedWeapon(Weapon) != none){
      HitAnim = AdvancedWeapon(Weapon).GetHitanim();
   }

   //then based upon the hit direction if the weapon doesn't care
   if (HitAnim == ''){
      hitPart = calcHitPart( hitLoc );
      switch ( hitPart ) {
      case HIT_Back:
          HitAnim = HitBack[int(Frand()*HitBack.length)];
          break;
      case HIT_Head:
          HitAnim = HitHead[int(Frand()*HitHead.length)];
          break;
      case HIT_Chest:
          HitAnim = HitFront[int(Frand()*HitFront.length)];
          break;
      case HIT_Left:
          HitAnim = HitLeft[int(Frand()*HitLeft.length)];
          break;
      case HIT_Right:
      default:
          HitAnim = HitRight[int(Frand()*HitRight.length)];
          break;
      }
   }
   AdvancedPlayAnim(HitAnim,1,hitblend,TAKEHITCHANNEL);
}


/*****************************************************************
 * PlayFalling
 *****************************************************************
 */
simulated event PlayFalling() {
   local name OldAnim;
   local float frame,rate;
   if (objMount != none){
    GetAnimParams(0,OldAnim,frame,rate);
    if ( (OldAnim==AnimJumpForward) || (OldAnim==AnimJump) ) return;
    PlayJump();
   }
}

/*****************************************************************
 * PlayJump
 *****************************************************************
 */
simulated event PlayJump() {

   local int CurrentDir;
   //turn off the boredom timer
   SetBoredomTimer(false);
   if ( controller == None ) return;
   CurrentDir = Controller.GetFacingDirection();

   if (CurrentDir == LEFTDIR &&
       AnimJumpLeft != '' && HasAnim(AnimJumpLeft) &&
       (Velocity.X > 0 || Velocity.Y >0)) {
      AdvancedPlayAnim( AnimJumpLeft,
                FMax(0.35,
                     PhysicsVolume.Gravity.Z/PhysicsVolume.Default.Gravity.Z),
                0.06);
   }
   else if ( CurrentDir == RIGHTDIR &&
             AnimJumpRight != '' && HasAnim(AnimJumpRight) &&
             (Velocity.X > 0 || Velocity.Y >0)) {
       AdvancedPlayAnim( AnimJumpRight,
                 FMax(0.35,
                      PhysicsVolume.Gravity.Z/PhysicsVolume.Default.Gravity.Z),
                 0.06);
   }
   else if ( CurrentDir == BACK &&
             AnimJumpBack != '' && HasAnim(AnimJumpBack) &&
             (Velocity.X > 0 || Velocity.Y >0)) {
      AdvancedPlayAnim( AnimJumpBack,
                FMax( 0.35,
                      PhysicsVolume.Gravity.Z/PhysicsVolume.Default.Gravity.Z),
                0.06);
   }
   else if ( CurrentDir == FORWARD &&
             AnimJumpForward != '' && HasAnim(AnimJumpForward) &&
             (Velocity.X > 0 || Velocity.Y >0)) {
      AdvancedPlayAnim( AnimJumpForward,
                FMax( 0.35,
                      PhysicsVolume.Gravity.Z/PhysicsVolume.Default.Gravity.Z),
                0.06);
   }
   else {
      BaseEyeHeight =  0.7 * Default.BaseEyeHeight;
      if ( (Acceleration.X != 0 || Acceleration.Y != 0) &&
           AnimJumpForward != '' && HasAnim(AnimJumpForward)) {
         AdvancedPlayAnim(AnimJumpForward);
      }
      else if (AnimJump != '' && HasAnim(AnimJump)){
         AdvancedPlayAnim(AnimJump);
//         Log(AnimJump);
      }
   }
}


/*****************************************************************
 * PlayMoving
 * NOTE could update this more lazily to save some time...
 *****************************************************************
 */
simulated function PlayMoving(){

   //turn off the boredom timer
   SetBoredomTimer(false);

   //or handle the crouch seperately
   if (bIsCrawling) {
       SwitchToCrawling();
   } else if ( bWantsToCrouch ){
       SwitchToCrouching();
   } else {
       SwitchToStanding();
   }
}


/*****************************************************************
 * PlayLanded
 *****************************************************************
 */
function PlayLanded(float impactVel) {
   impactVel = impactVel/JumpZ;
   impactVel = 0.1 * impactVel * impactVel;
   BaseEyeHeight = Default.BaseEyeHeight;
   MakeNoise(0.3);
}


/*****************************************************************
 * PlayLandedAnimation
 *****************************************************************
 */
simulated event PlayLandingAnimation(float ImpactVel) {
   if ( (impactVel > 0.06) || IsAnimating(FALLINGCHANNEL) ) {
      PlayWaiting();
   }
   else if ( !IsAnimating(0) ) PlayWaiting();

   // SV:: reset this when colliding with another pawn
   BaseEyeHeight = Default.BaseEyeHeight;
}


/*****************************************************************
 * GetWeaponBoneFor
 *****************************************************************
 */
function name GetWeaponBoneFor (Inventory I) { return weaponBone; }



/*****************************************************************
 * PlayArmAnim
 *****************************************************************
 */
function PlayArmAnim(name ArmAnimName){
   if (ArmAnimName != ''){
      CurrentArmAnim = ArmAnimName;
      GotoState('DoingArmStuff');
   }
}

/*****************************************************************
 * ArmAnimEnd
 * Notification from the arms that they are done
 *****************************************************************
 */
function ArmAnimEnd(){}


/*****************************************************************
 * PlayFocusedAnimation
 * Plays this animation. There is no way to stop it until it is
 * done. No movement takes place during this animation.
 *****************************************************************
 */
function PlayFocusedAnimation(name AnimName, optional float Rate){
   FocusedAnimName = AnimName;
   if (Rate <= 0){
      iAnimRate = 1;
   } else {
      iAnimRate = Rate;
   }
   GotoState('FocusedAnimation');
}

/*****************************************************************
 * PlayAnimEnd
 * You should get a call to focusedanimend when the focused animation
 * ends.
 * IF, you set up code to do the following you can screw this system
 * up...
 * 1. Play a focusedanimation
 * 2. While the animation is proceeding switch the pawn's state
 * 3. Call focusedanimation
 *
 * this might clobber your first animation and prevent the animend from occuring.
 *****************************************************************
 */
function FocusedAnimEnd(){
   AnimBlendToAlpha(FOCUSCHANNEL, 0, 0.1);
   //spawns use focused anim tech
   if (bPlayingSpawn == true){
      SpawnAnimEnd();
   }

   if (bPlayingFall == true){
      FallDownAnimEnd();
   }
}


//===========================================================================
//===========================================================================
// HIGHLEVEL FEATURES
//
// -The grenade toss
// -Boredom behaviour
// -Difficulty Settings
//===========================================================================
//===========================================================================




/*****************************************************************
 * SetBoredomTimer
 *****************************************************************
 */
function SetBoredomTimer(bool turnOn){
    local int deviate;

    if (turnOn == true)
    {
        deviate = int (FRand() * BoredomDeviation);
        SetMultiTimer(BORED_TIMER, BoredomThreshold + deviate ,true);
        BoredomTimerActive = true;
    } else {
        SetMultiTimer(BORED_TIMER, 0, false);
        BoredomTimerActive = false;
    }
}


/****************************************************************
 * TossGrenade - called to initiate the act of throwing
 *
 * @param dir    relative direction to throw.
 * @param speed  override projectile's real speed with this.
 ****************************************************************
 */
function TossGrenade( Rotator dir, optional float speed ) {
    if ( grenadeClass == None ) return;
    grenadeDirection = dir;
    if ( speed > 0 ) {
                    // Log( self @ "using hack velocity on grenade:" @ speed  )    ;
        bHackGrenadeVelocity = true;
        grenadeVelocity = (speed * Vector(rotation + dir)) + velocity;
    }
    else bHackGrenadeVelocity = false;
                // Log( self @ "Toss grenade" )    ;
    SetMultiTimer( GRENADE_RELEASE, 0.7, false); //GrenadeAnimLength, true );
    //    GotoState('ThrowingGrenade');
    PlayFocusedAnimation(GrenadeThrowAnim);
}


/*****************************************************************
 * ReleaseGrenade
 * Actually spawns the grenade.
******************************************************************
 */
function ReleaseGrenade() {
    local Actor grenade;

    grenade = Spawn( grenadeClass, self,,, rotation + GrenadeDirection );
    if ( bHackGrenadeVelocity ) grenade.velocity = grenadeVelocity;
}


/*****************************************************************
 * UpdateDifficultyLevel
 *****************************************************************
 */
function UpdateDifficultyLevel(int NewDifficulty){
   DifficultyLevel = NewDifficulty;
   switch NewDifficulty{
      case 0:
      DiffDamageMultiplier = 0.25;
      break;
      case 1:
      DiffDamageMultiplier = 0.8;
      break;
      case 3:
      DiffDamageMultiplier= 2;
      break;
   }
}


/*****************************************************************
 * DiffToHealth
******************************************************************
 */
/*
function float DiffToHealth(int diff){

   switch diff {
   case 0:
      return  EASYHEALTH;
      break;
   case 2:
      return DIFFICULTHEALTH;
      break;
   default:
      return STANDARDHEALTH;
      break;
   }
}
 */

/*****************************************************************
 * HoldCarriedObject
 *****************************************************************
 */
function HoldCarriedObject (CarriedObject O, name AttachmentBone) {

    if (AttachmentBone == 'None') {
        O.SetPhysics (PHYS_Rotating);
        O.SetLocation (Location);
        O.SetBase (self);
        O.SetRelativeLocation (vect (0, 0, 0));
    }
    else {
        AttachToBone (O, AttachmentBone);
        O.SetRelativeRotation (GameObjRot);
        O.SetRelativeLocation (GameObjOffset);
    }
}

/*****************************************************************
 * FallDown
 *****************************************************************
 */
function FallDown(vector Momentum) {

    local vector X,Y,Z,HitDir;

    //prevent getting knocked down while jumping
    //if (Velocity.Z != 0){
      //return;
    //}

    GetAxes(Rotation,X,Y,Z);
    HitDir = Normal(Momentum);

    //FRONT
    if ( (HitDir dot X) >= 0.75 ){
       FallDownAnim = AnimFallForward;
    }
    //BACK
    else if ( (HitDir Dot X) < -0.75 ) {
       FallDownAnim = AnimFallBackward;
    }
    //RIGHT
    else if ( (HitDir Dot Y) > 0 ){
       FallDownAnim = AnimFallRight;
    }
    //LEFT
    else {
       FallDownAnim = AnimFallLeft;
    }

   if (FallDownAnim != '' && HasAnim(FallDownAnim)
       && !bIsCrouched && !bIsCrawling && bAllowedToFall==true){
      bPlayingFall = true;
      SetCollision(true,true,false); // this is the correct one!!!!
      //SetCollision(false,false,false);
      //SetCollisionSize(CrawlingCollisionRadius,CrawlingCollisionHeight-30);
      //falling takes place after the hit is already sent.
      //If you want the hit animation to ever end, you had better clear it out now
      AnimBlendToAlpha (TAKEHITCHANNEL, 0, 0.2);
      //PlayFocusedAnimation(FallDownAnim);
      AdvancedPlayAnim(FallDownAnim,FallDownAnimRate,,,false,true);
   }
}

/*****************************************************************
 * FallDownAnimEnd
 *****************************************************************
 */
function FallDownAnimEnd(){
   bPlayingFall = false;
   SetCollision(default.bCollideactors, default.bBlockActors,
                default.bBlockPlayers);
    if (PhysicsVolume.bWaterVolume == true)
    {
        SetPhysics(PHYS_Swimming);
    }
}




/*****************************************************************
 *  EyePosition
 * Called by PlayerController to determine camera position in first
 * person view.  Returns the offset from the Pawn's location at which
 * to place the camera
 *****************************************************************
 */
simulated function vector EyePosition()
{
/*
    local float temp;

    temp = -AdvancedPlayerController(Controller).SwayDelta *
           AdvancedPlayerController(Controller).SwayDelta;
  */
    //Log("Nor: " $ EyeHeight * vect(0,0,1) + WalkBob);
//    Log("Mod: " $ EyeHeight * vect(0,0,1) + WalkBob +  temp * vect(0,0,1));

    return EyeHeight * vect(0,0,1) + WalkBob + SwayBob;


}

/*****************************************************************
 * Notify_SetSpeed
 *****************************************************************
 */
function Notify_SetSpeed(float rate){
   GroundSpeed  = default.GroundSpeed * rate;
}


//===========================================================================
//===========================================================================
// STATES
//===========================================================================
//===========================================================================




//===========================================================================
// State FocusedAnimation
//
//===========================================================================
state FocusedAnimation{
    ignores AdvancedPlayAnim,PlayFocusedAnimation,Fire,PlayFiring,PlayMoving,PlayJump,PlayHit;

    /****************************************************************
     * BeginState
     ****************************************************************
     */
    function BeginState() {
        local int i;

        if (FocusedAnimName != '') {
            bIgnoreForces = true;
            FreezeMovement(true, false);
            AnimBlendParams(FOCUSCHANNEL,1);
            if (iAnimRate <= 0){
                iAnimRate = 1;
            }
            // clear all other channels, since they won't get their AnimEnd
            // calls anyways...
            for ( i = 0; i < NUM_CHANNELS; ++i ) {
                if ( i != FOCUSCHANNEL ) {
                    AnimBlendToAlpha( i, 0, 0.05 );
                }
            }

            PlayAnim(FocusedAnimName,iAnimRate,0,FOCUSCHANNEL);
        } else {
            LeaveState();
        }
    }

   /****************************************************************
    * AnimEnd
    ****************************************************************
    */
   simulated event AnimEnd(int Channel){
      if (Channel == FOCUSCHANNEL){
         LeaveState();
      } else {
        super.AnimEnd(Channel);
      }
   }

   /****************************************************************
    * LeaveState
    ****************************************************************
    */
   function LeaveState(){
      GotoState('');
      FreezeMovement(false);
      bIgnoreForces   = false;
//      SetCollision(default.bCollideactors, default.bBlockActors, default.bBlockPlayers);
      SetPhysics( PHYS_Falling );
      FocusedAnimEnd();
   }

   function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                     vector momentum, class<DamageType> damageType){
      if (bTakesDamageInFocused == true){
         global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
      }
   }


}


//===========================================================================
// State TimingOut
//
// Where gibbed pawns go to die (delay so they can get replicated)
//===========================================================================
state TimingOut {

    ignores BaseChange,
        Landed,
        AnimEnd,
        Trigger,
        Bump,
        HitWall,
        HeadVolumeChange,
        PhysicsVolumeChange,
        Falling,
        BreathTimer;

    /*****************************************************************
     * TakeDamage
     *****************************************************************
     */
    function TakeDamage (int Damage,Pawn instigatedBy,Vector hitlocation,
                         Vector momentum, class<DamageType> damageType) {}

   /*****************************************************************
    * BeginState
    *****************************************************************
    */
    function BeginState () {
        SetPhysics (PHYS_None);
        SetCollision (false, false, false);
        LifeSpan = 1.0;
        if (Controller != None) {
            Controller.PawnDied (self);
        }
    }
}





//===========================================================================
// State Dying
//===========================================================================
state Dying {

    ignores AnimEnd,
        Trigger,
        Bump,
        HitWall,
        HeadVolumeChange,
        PhysicsVolumeChange,
        Falling,
        BreathTimer;

   /*****************************************************************
    * Landed
    *****************************************************************
    */
    function Landed (vector HitNormal) {
        LandBob = FMin (50, 0.055 * Velocity.Z);
        if (Level.NetMode == NM_DedicatedServer) { return; }
        if ( FancyShadow != None) { FancyShadow.Destroy (); }
    }

   /*****************************************************************
    * BaseChange
    *****************************************************************
    */
    singular function BaseChange () {
        Super.BaseChange ();
        // fixme - wake up karma
    }

   /*****************************************************************
    * TakeDamage
    *****************************************************************
    */
    function TakeDamage (int    Damage,
        Pawn                    InstigatedBy,
        Vector                  Hitlocation,
        Vector                  Momentum,
        class<DamageType>       damageType)
    {

        local Vector PushLinVel;
        if (bPlayedDeath && Physics == PHYS_KarmaRagdoll) {
            PushLinVel = RagShootStrength*Normal (Momentum);
            KAddImpulse (PushLinVel, HitLocation);
            return;
        }

        Super.TakeDamage (Damage,
            InstigatedBy,
            Hitlocation,
            Momentum,
            damageType);
    }

   /*****************************************************************
    * BeginState
    *****************************************************************
    */
    function BeginState () {
        if ((LastStartSpot!=None)&&(Level.TimeSeconds-LastStartTime<7)){
           LastStartSpot.LastSpawnCampTime = Level.TimeSeconds;
        }
        SetCollision (true, false, false);
        if (bTearOff && (Level.NetMode == NM_DedicatedServer)) {
           LifeSpan = 1.0;
        }
        else  {
           SetTimer (2.0, false);
        }
        SetPhysics(PHYS_Falling);
        bInvulnerableBody = true;
        if (Controller != None) {
            Controller.PawnDied(self);
        }
    }
}


//===========================================================================
// State DoingArmStuff
//
//===========================================================================
State DoingArmStuff{

   /*****************************************************************
    * BeginState
    *****************************************************************
    */
   function BeginState(){
      if (Weapon !=None){
         WeaponDowned = false;
         Weapon.PutDown();
      } else {
         LeaveState();
      }
   }

   /*****************************************************************
    * ChangedWeapon
    *****************************************************************
    */
   function ChangedWeapon(){
      WeaponDowned = true;
      MyArms.bHidden = false;
      MyArms.PlayAnim(CurrentArmAnim);
   }

   /*****************************************************************
    * ArmAnimEnd
    *****************************************************************
    */
   function ArmAnimEnd(){
      if (WeaponDowned == true){
         LeaveState();
      }
   }

   /*****************************************************************
    * LeaveState
    *****************************************************************
    */
   function LeaveState(){
      if (Weapon !=None){
         Weapon.BringUp();
      }
      MyArms.bHidden = true;
      GotoState('');
   }
}


//===========================================================================
// State Talking
//===========================================================================
state Talking{

   function InterpToTalkPoint()
   {
      if (!bOpeningMouth){
        delta = delta + 1;
      } else {
        delta = delta - 1;
      }
      DeltaPoint.Pitch = delta * 150 + (Frand() * 20);
      DeltaPoint.Yaw = (Frand() * 50);
      SetBoneRotation('Jaw', DeltaPoint);

      if (delta > randVal || delta < -randVal){
         bOpeningMouth = !bOpeningMouth;
         if (!bOpeningMouth){
            randVal = FRand() * 5;
         }
      }
   }


BEGIN:
   DeltaPoint.Pitch = 0;
   DeltaPoint.Yaw = 0;
   DeltaPoint.Roll = 0;
   delta = 0;
   randVal = FRand() * 5;

CONT:
   InterpToTalkPoint();
   Sleep(0.01);
   GotoState('Talking', 'CONT');

}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     TeamBoneName="ArrowSocket"
     AnimWalkTurnLeft="TurnL"
     AnimWalkTurnRight="TurnR"
     AnimWalkForward="WalkF"
     AnimWalkBack="WalkB"
     AnimWalkLeft="WalkL"
     AnimWalkRight="WalkR"
     AnimRunTurnLeft="TurnL"
     AnimRunTurnRight="TurnR"
     AnimRunForward="RunF"
     AnimRunBack="RunB"
     AnimRunLeft="RunL"
     AnimRunRight="RunR"
     AnimJump="Jump"
     AnimJumpForward="JumpF"
     AnimJumpBack="JumpB"
     AnimJumpLeft="JumpL"
     AnimJumpRight="JumpR"
     AnimStandIdle="StandIdle"
     AnimStandHitRight(0)="HitRightSide"
     AnimStandHitLeft(0)="HitLeftSide"
     AnimStandHitBack(0)="HitBack"
     AnimStandHitHead(0)="HitHead"
     AnimStandHitFront(0)="HitFront"
     AnimStandFire="Fire"
     AnimStandDeathBack="DeathB"
     AnimStandDeathForward="DeathF"
     AnimStandDeathLeft="DeathL"
     AnimStandDeathRight="DeathR"
     AnimCrouchTurnLeft="Crouch_TurnL"
     AnimCrouchTurnRight="Crouch_TurnR"
     AnimCrouchIdle="CrouchIdle"
     AnimCrouchForward="CrouchF"
     AnimCrouchBack="CrouchB"
     AnimCrouchLeft="CrouchL"
     AnimCrouchRight="CrouchR"
     AnimCrouchHitRight(0)="CrouchHitRightSide"
     AnimCrouchHitLeft(0)="CrouchHitLeftSide"
     AnimCrouchHitBack(0)="CrouchHitBack"
     AnimCrouchHitHead(0)="CrouchHitHead"
     AnimCrouchHitFront(0)="CrouchHitFront"
     AnimCrouchFire="Fire"
     AnimCrouchDeathBack="CrouchDeathB"
     AnimCrouchDeathForward="CrouchDeathF"
     AnimCrouchDeathLeft="CrouchDeathL"
     AnimCrouchDeathRight="CrouchDeathR"
     AnimCrawlTurnLeft="CrawlTurnL"
     AnimCrawlTurnRight="CrawlTurnR"
     AnimCrawlForward="CrawlF"
     AnimCrawlBack="CrawlB"
     AnimCrawlLeft="CrawlTurnL"
     AnimCrawlRight="CrawlTurnR"
     AnimCrawlIdle="CrawlIdle"
     AnimCrawlHitRight(0)="CrawlHitRightSide"
     AnimCrawlHitLeft(0)="CrawlHitLeftSide"
     AnimCrawlHitBack(0)="CrawlHitBack"
     AnimCrawlHitHead(0)="CrawlHitHead"
     AnimCrawlHitFront(0)="CrawlHitFront"
     AnimCrawlFire="Fire"
     AnimCrawlDeathBack="CrawlDeathB"
     AnimCrawlDeathForward="CrawlDeathF"
     AnimCrawlDeathLeft="CrawlDeathL"
     AnimCrawlDeathRight="CrawlDeathR"
     AnimFallForward="FallDownF"
     AnimFallBackWard="FallDownB"
     AnimFallLeft="FallDownL"
     AnimFallRight="FallDownR"
     Idle="StandIdle"
     AnimFire="Fire"
     FIRINGBLENDBONE="Spine"
     LOOKINGBLENDBONE="Spine1"
     CrawlingPct=0.600000
     CrawlingCollisionHeight=40.000000
     CrawlingCollisionRadius=34.000000
     BoredAnimNum=-1
     FootStepVolume=0.300000
     bRenderOnRadar=True
     iAnimRate=1.000000
     ViewKickMagnitude=1000
     bFirstLand=True
     HeadShotTxt="Headshot!"
     hitblend=0.080000
     FallDownAnimRate=1.000000
     bAllowedToFall=True
     iUseShadows=SHADOW_PROJ
     ActiveShadowDistance=2000
     DiffDamageMultiplier=1.000000
     DifficultyLevel=1
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     TurnLeftAnim="TurnL"
     TurnRightAnim="TurnR"
     bHidden=True
     bNetNotify=True
     DebugFlags=1
     SoundOcclusion=OCCLUSION_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=80.000000
}
