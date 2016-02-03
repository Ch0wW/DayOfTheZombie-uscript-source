// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
 /**
 * DOTZPlayerControllerBase - previously HGPlayerControllerBase.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    May 2003
 */
class DOTZPlayerControllerBase extends AdvancedPlayerController;



var config string EndOfMatchMenuMP;
var config string PauseMenuMP;


const constINVERTY = "INVERTY";
const constDIFFLEVEL = "DIFFLEVEL";
const constSUBTITLES = "SUBTITLES";
//const constVOICETHRUSPEAKERS = "VOICETHRUSPEAKERS";
const constVOICEMASKING = "VOICEMASKING";
const constVIBRATION = "VIBRATION";
const constSENSITIVITY = "SENSITIVITY";

var int RunningCounter;

const RUNNING_COUNTER   = 222;
const RUNMAX            = 8;
const REFALL_TIMER      = 223;
const BREATH_INCREASE   = 35;
const BREATH_DECREASE   = 15;
const MIN_SPECTATE_TIME = 3;

var bool bReadyToDash;
var sound RunningSound;
var bool bWaitingToFall;
var float StartedSpectatingTime;
var travel bool KungFuMode;


var Weapon LastMeleeWeapon;
var Weapon CurrentMeleeWeapon;
var Weapon LastGunWeapon;
var Weapon CurrentGunWeapon;
var Weapon LastGrenadeWeapon;
var Weapon CurrentGrenadeWeapon;

struct MyPRI
{
   var() string Gamertag;
   var() string PlayerName;
   var() int Score;
   var() int Deaths;
   var() int TeamIndex;
   var() int TeamID;
   var() string xnaddr;
   var() string xuid;
   var() int Ranking;
   var() int Kills;
};
var array<MyPRI> pris;
var array<MyPRI> oldpris;
var int myPRIIndex;
var float lastRefreshTime;


var bool bUseVibration;
var bool bInvertLook;
var int  iDifficulty;
var bool bVoiceMask;
var int  iSensitivity;
var bool bSubtitles;
var bool bScriptDisabled;


exec function ReadyToSay(){
   if (Level.NetMode != NM_StandAlone){
     ClientOpenMenu("DOTZMenu.DOTZMPSay");
   }
}

/******************************************************************
 * ToggleObjectivesDisplay
 * Turns on/off the objectives list
 ******************************************************************
 */
exec function ToggleObjectivesDisplay() {

   if (Level.NetMode == NM_StandAlone){
     if ( DOTZGameInfoBase(Level.Game).theObjMgr.showObjectives ) {
          DOTZGameInfoBase(Level.Game).theObjMgr.Hide();
     } else {
       DOTZGameInfoBase(Level.Game).theObjMgr.show();
     }
   } else {
     Level.GetLocalPlayerController().ClientCloseMenu(true,true);
     Level.GetLocalPlayerController().ClientOpenMenu(default.EndOfMatchMenuMP);
   }
}


exec function ClientPause(){
   if (Level.NetMode == NM_StandAlone){
      Pause();
   } else {
      super.ClientPause();
      ClientOpenMenu(default.PauseMenuMP);
   }
}



function PostNetBeginPlay(){
   super.PostNetBeginPlay();
    //Set up static storage to persist across reboots
   if (Level.NetMode != NM_StandAlone){
      StopAllMusic( 0.0 );
   }
   DynamicLoadObject(default.PauseMenuMP,class'class');
   SetProfileConfiguration();

   //Moved to reboot manager
   //LoadProfile(GetProfileByName(class'DOTZPlayerControllerBase'.default.LastProfile));

    // Dont need this since SetProfileConfiguration() does it
   //if (AdvancedGameInfo(Level.Game).bUseSubtitles == true){
   //   AdvancedGameInfo(Level.Game).TheSubtitles = Spawn(Class'AdvancedSubtitleMgr');
   //}
}


function PostLoad(){
   super.PostLoad();

   // Moved to reboot manager
   //LoadProfile(GetProfileByName(class'DOTZPlayerControllerBase'.default.LastProfile));
}


simulated function InfectionEffect(bool on){

   if (self == Level.GetLocalPlayerController()){
//      Log("I am infecting the health bar --- " $ MyLifeBar);
      DOTZHealthBar(MyLifeBar).SetInfected( on );
      if (on == true && bIsBlurred == false){
//          log(self $ " motion blur is on");
          MotionBlurOn();
      } else if (on == false && bIsBlurred == true) {
//          log(self $ " motion blur is off");
           MotionBlurOff();
      }
   }
}


function Destroyed(){
   super.Destroyed();
}

/*****************************************************************
 * SameTeamAs
 *****************************************************************
 */
function bool SameTeamAs(Controller C){
   if (Level.NetMode == NM_StandAlone){
      //zombies return normal check, Otis checks to see if you are
      //a zombie
      return C.SameTeamAs(self);
   }
   return super.SameTeamAs(C);
}

//===========================================================================
// PUBLIC PROFILE INTERFACE
//===========================================================================


/*****************************************************************
 * SetProfileConfiguration
 * Update the active configuration to reflect the currently loaded profile.
 *****************************************************************
 */
private function SetProfileConfiguration(){
    local bool InvertY;
    //local bool VoiceThruSpeakers;
    local bool VoiceMasking;
    local bool bUseVibration;
    local int  Sensitivity;

    Log("Setting profile config from profile");

   //SET CURRENT PROFILE
   if (GetCurrentProfileName() != "" && IsLoadedProfileValid()){
      //Set your mouse look perference
      InvertY = bool(class'Profiler'.static.GetValue(constINVERTY));
      SetInvertLook(InvertY);

      //Set your voice thru speakers preference
      //VoiceThruSpeakers = bool(class'Profiler'.static.GetValue(constVOICETHRUSPEAKERS));
      //SetVoiceThruSpeakers(VoiceThruSpeakers);

      //Set your voice thru speakers preference
      VoiceMasking = bool(class'Profiler'.static.GetValue(constVOICEMASKING));
      SetVoiceMasking(VoiceMasking);

      //Set the difficulty level
      AdvancedGameInfo(Level.Game).iDifficultyLevel = int(class'Profiler'.static.GetValue(constDIFFLEVEL));
      SetDifficultyLevel(AdvancedGameInfo(Level.Game).iDifficultyLevel);


      //Set the difficulty level
      AdvancedGameInfo(Level.Game).bUseSubtitles = bool(class'Profiler'.static.GetValue(constSUBTITLES));

      //Log("Setting subtitles: " $ bUseSubtitles);
      SetUseSubtitles(AdvancedGameInfo(Level.Game).bUseSubtitles);

      bUseVibration = bool(class'Profiler'.static.GetValue(constVIBRATION));
      SetUseVibration(bUseVibration);

      Sensitivity = int(class'Profiler'.static.GetValue(constSENSITIVITY));
      SetControllerSensitivity(Sensitivity);

   //DEFAULTS
   } else {

        Log("Setting profile config from defaults");

      SetUseVibration(false);
      SetInvertLook(false);
      SetDifficultyLevel(1);
      //SetVoiceThruSpeakers(true);
      SetVoiceMasking(false);
      SetControllerSensitivity(6);

      AdvancedGameInfo(Level.Game).bUseSubtitles = true;
      SetUseSubtitles(AdvancedGameInfo(Level.Game).bUseSubtitles);
   }
}

/*****************************************************************
 * LoadProfile
 * Do real native side loading, but also ensure that any changes
 * are reflected in the active session
 *****************************************************************
 */
function bool LoadProfile(int v){

//   Log(v $ " is the profle being loaded");

   //natively load the profile so data is available
   if (!class'Profiler'.static.Load(v)){
      SetProfileConfiguration();
      return false;
   //do some other stuff, like set values dynamically
   } else {
      // Moved to reboot manager
      //class'DOTZPlayerControllerBase'.default.LastProfile = GetProfileName(v);
//      Log(" Saving to the config file");
      class'DOTZPlayerControllerBase'.static.StaticSaveConfig();
      SetProfileConfiguration();
   }
   return true;
}


/*****************************************************************
 * IsLoadedProfileValid
 * Is there a valid profile loaded
 *****************************************************************
 */
function bool IsLoadedProfileValid(){
   return class'Profiler'.static.IsValidProfile();
}

/*****************************************************************
 * DeleteProfile
 *****************************************************************
 */
function bool DeleteProfile(int v){
   if (!class'Profiler'.static.DeleteProfile(v)){
      return false;
   } else {
      SetProfileConfiguration();
      AdvancedGameInfo(Level.Game).DeleteProfileSaveGames();
   }
   return true;
}



/*****************************************************************
 * SetInvertLook
 *****************************************************************
 */
 function SetInvertLook(bool bShouldInvert){

    if (!IsLoadedProfileValid())  {
        bInvertLook = bShouldInvert;
    } else {

       if (bShouldInvert){
          class'Profiler'.static.SetValue(constINVERTY,"true");
       } else {
          class'Profiler'.static.SetValue(constINVERTY,"false");
       }
   }
   //InvertY = bShouldInvert;
   InvertLook(bShouldInvert);
}

/*****************************************************************
 * SetVoiceThruSpeakers
 *****************************************************************
 */
/*function SetVoiceThruSpeakers(bool bVoiceThruSpeakers){

   if (bVoiceThruSpeakers){
      class'Profiler'.static.SetValue(constVOICETHRUSPEAKERS,"true");
   } else {
      class'Profiler'.static.SetValue(constVOICETHRUSPEAKERS,"false");
   }
   //VoiceThruSpeakers = bVoiceThruSpeakers;
   class'UtilsXbox'.static.VoiceChat_Set_Voice_Thru_Speakers(bVoiceThruSpeakers);
}*/


/*****************************************************************
 * SetVoiceMasking
 *****************************************************************
 */
function SetVoiceMasking(bool bVoiceMasking){

    if (!IsLoadedProfileValid())  {
        bVoiceMask = bVoiceMasking;
    } else {

       if (bVoiceMasking){
          class'Profiler'.static.SetValue(constVOICEMASKING,"true");
          class'UtilsXbox'.static.VoiceChat_Set_Voice_Mask_Anonymous();
       } else {
          class'Profiler'.static.SetValue(constVOICEMASKING,"false");
          class'UtilsXbox'.static.VoiceChat_Set_Voice_Mask_None();
       }
   //VoiceMasking = bVoiceMasking;
   }
}

/*****************************************************************
 * SetDifficultyLevel
 * Setting the difficulty means adjusting the damage that the player
 * takes when he is hit. ONLY the player is adjusted.
 *****************************************************************
 */
function SetDifficultyLevel(int iDiffLevel){
   local AdvancedPawn TempPawn;

    if (!IsLoadedProfileValid())  {
        iDifficulty = iDiffLevel;
    } else {

       if (Level.NetMode != NM_StandAlone){
          return;
       }

       class'Profiler'.static.SetValue(constDIFFLEVEL,string(iDiffLevel));
       AdvancedGameInfo(Level.Game).iDifficultyLevel=iDiffLevel;
       //update player pawns with new difficulty levels
       foreach AllActors(class'AdvancedPawn', TempPawn){
          if (PlayerController(TempPawn.Controller) != none){
             TempPawn.UpdateDifficultyLevel(AdvancedGameInfo(Level.Game).iDifficultyLevel);
          }
       }
    }
}


/*****************************************************************
 * UseVibration
 *****************************************************************
 */
function SetUseVibration(bool useVibration){

    if (!IsLoadedProfileValid())  {
        bUseVibration = useVibration;
    } else {
       class'Profiler'.static.SetValue(constVIBRATION,string(useVibration));
       bUseVibration=useVibration;
    }
}

/*****************************************************************
 * SetControllerSensitivity
 *****************************************************************
 */
function SetControllerSensitivity(float sensitivity){

    if (!IsLoadedProfileValid())  {
        iSensitivity = sensitivity;
    } else {

        Log("Sens saving " $ sensitivity);
        class'PlayerInput'.default.Sensitivity = int(Sensitivity);
        class'PlayerInput'.static.StaticSaveConfig();
        class'Profiler'.static.SetValue(constSENSITIVITY,string(sensitivity));
    }
}

/*****************************************************************
 * SetUseSubtitles
 *****************************************************************
 */
function SetUseSubtitles(bool useSubTitles){

    if (!IsLoadedProfileValid())  {
        bSubtitles = useSubTitles;
        AdvancedGameInfo(Level.Game).bUseSubtitles = useSubtitles;
    } else {
        class'Profiler'.static.SetValue(constSUBTITLES,string(useSubtitles));
        AdvancedGameInfo(Level.Game).bUseSubtitles = useSubtitles;
    }
    if (AdvancedGameInfo(Level.Game).bUseSubtitles == true && AdvancedGameInfo(Level.Game).TheSubtitles == none){
       AdvancedGameInfo(Level.Game).TheSubtitles = Spawn(Class'AdvancedSubtitleMgr');
    } else if (AdvancedGameInfo(Level.Game).bUseSubtitles == false && AdvancedGameInfo(Level.Game).TheSubtitles != None) {
       AdvancedGameInfo(Level.Game).TheSubtitles.Destroy();
    }
}

/*****************************************************************
 * GetDifficultyLevel
 *****************************************************************
 */
function int GetDifficultyLevel(){
    if (!IsLoadedProfileValid())  {
        return iDifficulty;
    } else {
        return int(class'Profiler'.static.GetValue(constDIFFLEVEL));
    }
   //return AdvancedGameInfo(Level.Game).iDifficultyLevel;
}

/*****************************************************************
 * GetInvertLook
 *****************************************************************
 */
function bool GetInvertLook(){
    if (!IsLoadedProfileValid())  {
        return bInvertLook;
    } else {
        return bool(class'Profiler'.static.GetValue(constINVERTY));
    }
}

/*****************************************************************
 * GetVoiceThruSpeakers
 *****************************************************************
 */
/*function bool GetVoiceThruSpeakers(){
   return bool(class'Profiler'.static.GetValue(constVOICETHRUSPEAKERS));
   //return VoiceThruSpeakers;
} */

/*****************************************************************
 * GetVoiceMasking
 *****************************************************************
 */
function bool GetVoiceMasking(){
    if (!IsLoadedProfileValid())  {
        return bVoiceMask;
    } else {
        return bool(class'Profiler'.static.GetValue(constVOICEMASKING));
    }
   //return VoiceMasking;
}

/*****************************************************************
 * GetUseSubtitles
 *****************************************************************
 */
function bool GetUseSubTitles(){
    if (!IsLoadedProfileValid())  {
        return bSubtitles;
    } else {
        return bool(class'Profiler'.static.GetValue(constSUBTITLES));
    }
   //return AdvancedGameInfo(Level.Game).bUseSubtitles;
}

/*****************************************************************
 * GetUseVibration
 *****************************************************************
 */
function bool GetUseVibration(){
    if (!IsLoadedProfileValid())  {
        return bUseVibration;
    } else {
        return bool(class'Profiler'.static.GetValue(constVIBRATION));
    }
    //return bUseVibration;
}

/*****************************************************************
 * GetSensitivity
 *****************************************************************
 */
function int GetControllerSensitivity(){
    if (!IsLoadedProfileValid())  {
        return iSensitivity;
    } else {
        Log("Sens returned " $ class'Profiler'.static.GetValue(constSENSITIVITY));
        return int(class'Profiler'.static.GetValue(constSENSITIVITY));
    }
    //return bUseVibration;
}

/*****************************************************************
 * Get_Unique_Name
 *****************************************************************
 */
function string Get_Unique_Name(string v){
   //return class'Profiler'.static.Get_Unique_Name(v);
   return "";
}

/*****************************************************************
 * SaveProfile
 *****************************************************************
 */
function bool SaveProfile(){
   return class'Profiler'.static.Save();
}

/*****************************************************************
 * NewProfile
 * Create new profile with name v
 *****************************************************************
 */
function int NewProfile(string v){
   return class'Profiler'.static.NewProfile(v);
}

/*****************************************************************
 * GetProfileCount
 * Load up all profiles & get total count (refreshes list)
 *****************************************************************
 */
function int GetProfileCount(){
   return class'Profiler'.static.GetProfileCount();
}

/*****************************************************************
 * GetProfileName
 * Return name of profile given its index (call GetProfileCount first)
 *****************************************************************
 */
function string GetProfileName(int v){
   return class'Profiler'.static.GetProfileName(v);
}

/*****************************************************************
 * GetProfileByName
 * Return name of profile given its index (call GetProfileCount first)
 *****************************************************************
 */
function int GetProfileByName(string v){
   return class'Profiler'.static.GetProfileByName(v);
}

/*****************************************************************
 * GetCurrentProfileName
 * Returns name of currently loaded profile ("" if no profile is loaded)
 *****************************************************************
 */
function string GetCurrentProfileName(){
   return class'Profiler'.static.GetCurrentProfileName();
}

/*****************************************************************
 * NextGun
 *****************************************************************
 */
exec function NextGun(){
   super.NextGun();
   //if you are holding a gun, you want the next one in the cycle
   //if you have never held a gun you want whatever
   //if the gun you were holding has been dropped, then give the next one
   if (CurrentGunWeapon == Pawn.Weapon){
      LastGunWeapon = CurrentGunWeapon;
      CurrentGunWeapon = NextWeaponByClass(CurrentGunWeapon, 'DOTZGunWeapon');

   //if your current gun is not in your inventory they you want to start fresh
   } else if ( AdvancedPawn(Pawn).IsInInventory(CurrentGunWeapon) == false){
      LastGunWeapon = none;
      CurrentGunWeapon = NextWeaponByClass(None, 'DOTZGunWeapon');

   //if you are not holding a gun then you want the last one you were holding
   } else {
      CurrentGunWeapon = NextWeaponByClass(LastGunWeapon, 'DOTZGunWeapon');
   }
}

/*****************************************************************
 * PrevGun
 *****************************************************************
 */
exec function PrevGun(){
   super.PrevGun();
   //if you are holding a gun, you want the next one in the cycle
   if (CurrentGunWeapon == Pawn.Weapon) {
      LastGunWeapon = CurrentGunWeapon;
      CurrentGunWeapon = PrevWeaponByClass(CurrentGunWeapon, 'DOTZGunWeapon');

   //if your current gun is not in your inventory they you want to start fresh
   } else if ( AdvancedPawn(Pawn).IsInInventory(CurrentGunWeapon) == false){
      LastGunWeapon = none;
      CurrentGunWeapon = PrevWeaponByClass(None, 'DOTZGunWeapon');

   //if you are not holding a gun then you want the last one you were holding
   } else {
      CurrentGunWeapon = PrevWeaponByClass(LastGunWeapon, 'DOTZGunWeapon');
   }
}

/*****************************************************************
 * NextMelee
 *****************************************************************
 */
exec function NextMelee(){
   super.NextMelee();
   //if you are holding a Melee, you want the next one in the cycle
   if (CurrentMeleeWeapon == Pawn.Weapon){
      LastMeleeWeapon = CurrentMeleeWeapon;
      CurrentMeleeWeapon = NextWeaponByClass(CurrentMeleeWeapon, 'DOTZMeleeWeapon');
   //if you are not holding a Melee then you want the last one you were holding
   } else {
      CurrentMeleeWeapon = NextWeaponByClass(LastMeleeWeapon, 'DOTZMeleeWeapon');
   }
}

/*****************************************************************
 * PrevMelee
 *****************************************************************
 */
exec function PrevMelee(){
   super.PrevMelee();
   //if you are holding a Melee, you want the next one in the cycle
   if (CurrentMeleeWeapon == Pawn.Weapon){
      LastMeleeWeapon = CurrentMeleeWeapon;
      CurrentMeleeWeapon = PrevWeaponByClass(CurrentMeleeWeapon, 'DOTZMeleeWeapon');
   //if you are not holding a Melee then you want the last one you were holding
   } else {
      CurrentMeleeWeapon = PrevWeaponByClass(LastMeleeWeapon, 'DOTZMeleeWeapon');
   }

}

/*****************************************************************
 * NextGrenade
 *****************************************************************
 */
exec function NextGrenade(){

   super.NextGrenade();
   //if you are holding a grenade, you want the next one in the cycle
   if (CurrentGrenadeWeapon == Pawn.Weapon){
      LastGrenadeWeapon = CurrentGrenadeWeapon;
      CurrentGrenadeWeapon = NextWeaponByClass(CurrentGrenadeWeapon, 'DOTZGrenadeWeapon',true);

  //if your current gun is not in your inventory they you want to start fresh
   } else if ( AdvancedPawn(Pawn).IsInInventory(CurrentGrenadeWeapon) == false){
      LastGrenadeWeapon = none;
      CurrentGrenadeWeapon = NextWeaponByClass(None, 'DOTZGrenadeWeapon',true);

   //if you are not holding a grenade then you want the last one you were holding
   } else {
      CurrentGrenadeWeapon = NextWeaponByClass(LastGrenadeWeapon, 'DOTZGrenadeWeapon',true);
   }
}

/*****************************************************************
 * PrevGrenade
 *****************************************************************
 */
exec function PrevGrenade(){

   super.PrevGrenade();
   //if you are holding a grenade, you want the next one in the cycle
   if (CurrentGrenadeWeapon == Pawn.Weapon){
      LastGrenadeWeapon = CurrentGrenadeWeapon;
      CurrentGrenadeWeapon = PrevWeaponByClass(CurrentGrenadeWeapon, 'DOTZGrenadeWeapon',true);

  //if your current gun is not in your inventory they you want to start fresh
   } else if ( AdvancedPawn(Pawn).IsInInventory(CurrentGrenadeWeapon) == false){
      LastGrenadeWeapon = none;
      CurrentGrenadeWeapon = PrevWeaponByClass(None, 'DOTZGrenadeWeapon',true);

   //if you are not holding a grenade then you want the last one you were holding
   } else {
      CurrentGrenadeWeapon = PrevWeaponByClass(LastGrenadeWeapon, 'DOTZGrenadeWeapon',true);
   }
}


/*****************************************************************
 *
 *****************************************************************
 */
exec function KungFu(){

    if( Level.Netmode!=NM_Standalone )
        return;

    if (KungFuMode == false){
        Pawn.GiveWeapon("DOTZWeapons.KungFuWeapon");
        KungFuMode= true;
    } else {
        KungFuMode= false;
        Pawn.GiveWeapon("DOTZWeapons.FistWeapon");
    }
}


/*****************************************************************
* Fire
******************************************************************
*/
exec function Fire( optional float F )
{
   if ( Level.Pauser == PlayerReplicationInfo ){
      SetPause(false);
     return;
   }
   if ( bDemoOwner || (Pawn == None) ) return;
   Super.Fire(F);
}

/**
 * Goto third-person spectator mode.
 */
function PawnDied( pawn p ) {
    super.PawnDied( p );

//    Log(self $ "PawnDied set some spectating stuff up");

    //Unpossess();
    //bBehindView = true;
    //SetViewTarget(p);
    ClientSetViewTarget(p);
}


/*****************************************************************
 * do ALL
 *****************************************************************
 */
exec function all(){
    if( Level.Netmode!=NM_Standalone )
        return;

   Weapons();
   bGodMode=true;
   ConsoleCommand( "AllAmmo" );
}


exec function gun(){
    if( Level.Netmode!=NM_Standalone )
        return;
    Pawn.GiveWeapon("DOTZWeapons.RifleWeapon");
}
exec function bat(){
    if( Level.Netmode!=NM_Standalone )
        return;
  Pawn.GiveWeapon("DOTZWeapons.BaseBallBatWeapon");
}
exec function pipe(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.LeadPipeWeapon");
}

exec function hammer(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.HammerWeapon");
}

exec function golfclub(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.GolfClubWeapon");
}

exec function axe(){
    if( Level.Netmode!=NM_Standalone )
        return;
  Pawn.GiveWeapon("DOTZWeapons.FireaxeWeapon");
}

exec function shovel(){
    if( Level.Netmode!=NM_Standalone )
        return;
  Pawn.GiveWeapon("DOTZWeapons.ShovelWeapon");
}

exec function glock(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.glockWeapon");
}

exec function shotgun(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.shotgunWeapon");
}

exec function sniper(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.sniperWeapon");
}

exec function molotov(){
    if( Level.Netmode!=NM_Standalone )
        return;
 Pawn.GiveWeapon("DOTZWeapons.molotovWeapon");
}

exec function revolver(){
    if( Level.Netmode!=NM_Standalone )
        return;
    Pawn.GiveWeapon("DOTZWeapons.RevolverWeapon");
}

exec function machinegun(){
    if( Level.Netmode!=NM_Standalone )
        return;
    Pawn.GiveWeapon("DOTZWeapons.M16Weapon");
}

exec function MiniGun(){
    if( Level.Netmode!=NM_Standalone )
        return;
    Pawn.GiveWeapon("DOTZWeapons.MountedWeaponA");
    ClientSetWeapon(class'DOTZEngine.DOTZFixedWeapon');
    AdvancedWeapon(Pawn.PendingWeapon).SetInfiniteAmmo(true);
}

exec function Friends(){
   if( Level.Netmode!=NM_Standalone )
        return;
   DOTZGameInfoBase(Level.Game).bNameCheat = !DOTZGameInfoBase(Level.Game).bNameCheat;
}

/*****************************************************************
 * Run
 *****************************************************************
 */
exec function Run(){
    //Log("STARTING TO RUN!!!!!");
    // SV: Dont run in multiplayer since its automatically set
    if(Level.NetMode != NM_StandAlone)
    {
        //Log("bRun:" @ bRun);
        // much less jitter with bRun == 0
        if(bRun == 1)
            bRun = 0;
       return;
    }

    if (AllowedToRun()){
        SetMultiTimer(RUNNING_COUNTER,1,true);
        Pawn.SoundVolume = 50;
        Pawn.AmbientSound = RunningSound;

    }  else {
        bRun = 0;
    }
}

/*****************************************************************
 * AllowedToRun
 *****************************************************************
 */
function bool AllowedToRun(){

    if (bScriptDisabled == true) return false;

    if (bRun == 1 && bReadyToDash == true && Vsize(Pawn.Velocity)>0 &&
        class'ExtinguishVolume' != Pawn.PhysicsVolume.class &&
        Pawn.PhysicsVolume.IsA('WaterVolume') == false){
        return true;
    }
    return false;
}

/*****************************************************************
* Weapons
******************************************************************
*/
exec function Weapons() {

    if( (Level.Netmode!=NM_Standalone) || (Pawn == None) )
        return;
    Pawn.GiveWeapon("DOTZWeapons.M16Weapon");
    Pawn.GiveWeapon("DOTZWeapons.ShovelWeapon");
    Pawn.GiveWeapon("DOTZWeapons.FireAxeWeapon");
    Pawn.GiveWeapon("DOTZWeapons.LeadPipeWeapon");
    Pawn.GiveWeapon("DOTZWeapons.GolfClubWeapon");
    Pawn.GiveWeapon("DOTZWeapons.HammerWeapon");
    Pawn.GiveWeapon("DOTZWeapons.BaseBallBatWeapon");
    Pawn.GiveWeapon("DOTZWeapons.ShotgunWeapon");
    Pawn.GiveWeapon("DOTZWeapons.RevolverWeapon");
    Pawn.GiveWeapon("DOTZWeapons.GlockWeapon");
    Pawn.GiveWeapon("DOTZWeapons.SniperWeapon");
    Pawn.GiveWeapon("DOTZWeapons.RifleWeapon");
    Pawn.GiveWeapon("DOTZWeapons.GrenadeWeapon");
    Pawn.GiveWeapon("DOTZWeapons.MolotovWeapon");
}

/*****************************************************************
 * HandleWalking
 *****************************************************************
 */
function HandleWalking(){

    if(Level.NetMode != NM_StandAlone)
    {
        // In multiplayer, do always run
        super.HandleWalking();
    } else
    {
       if ( Pawn != None )
         //parent specified bRun !=0 to mostly run, we want mostly walk
         Pawn.SetWalking( (bRun == 0) && !Region.Zone.IsA('WarpZoneInfo') );
    }
}

/*****************************************************************
 * NotifyTakeHit
 *****************************************************************
 */
function NotifyTakeHit( Pawn instigatedBy, vector HitLocation, int actualDamage,
                        class<DamageType> DamageType, vector Momentum ) {

    super.NotifyTakeHit( InstigatedBy, Hitlocation, actualDamage,
                         damageType, Momentum );
    if ( instigatedBy.IsA('ZombiePawnBase') == true && bWaitingToFall == false
            && damageType != class'DOTZInfectionDamage' ) {
        AdvancedPawn(Pawn).FallDown(Momentum);
        bWaitingToFall = true;
        SetMultiTimer(REFALL_TIMER, 2.5, false);
        Fall();
    }
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int ID) {
    switch ( ID ) {

    case RUNNING_COUNTER:
        DoRunCalcs();
        break;

    case REFALL_TIMER :
        bWaitingToFall = false;
        break;

    default:
        super.MultiTimer(ID);
    }
}

/*****************************************************************
 * DoRunCalcs
 *****************************************************************
 */
function DoRunCalcs(){

    local float AffectRatio;

    AffectRatio = 1- (float(runningCounter)/(RUNMAX + 3));
   // Log ("Ground Speed: " $ Pawn.GroundSpeed);
    //Log ("Walking pct: " $ Pawn.WalkingPct $ " Walking Speed: " $ Pawn.WalkingPct * Pawn.GroundSpeed);
    //Log ("AffectRatio: " $ AffectRatio);

    //you are running check if you should stop
    if (AllowedToRun()){
        RunningCounter++;
        if (Pawn.SoundVolume + BREATH_INCREASE >= 255) {
            Pawn.SoundVolume = 255;
        } else {
            Pawn.SoundVolume += BREATH_INCREASE;
        }

        //running affects ground speed
        Pawn.GroundSpeed = Pawn.Default.GroundSpeed * AffectRatio;

        //ah, you ran too much
        if (RunningCounter > RUNMAX){
            Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
            bRun = 0;
            bReadyToDash = false;
            Pawn.PlaySound(AdvancedPawn(Pawn).HitSounds[0]);

        }

    //you are not running
    } else if (class'ExtinguishVolume' == Pawn.PhysicsVolume.class ||
               Pawn.PhysicsVolume.IsA('WaterVolume')){
        //Log ("You are in water");
        bReadyToDash = false;
        bRun = 0;
        Pawn.AmbientSound = none;
    } else {
      //  bReadyToDash = false; //think we should remove this
        RunningCounter --;
        if (Pawn.SoundVolume - BREATH_DECREASE <= 0) {
            Pawn.SoundVolume = 0;
        } else {
            Pawn.SoundVolume -=BREATH_DECREASE;
        }


        if (bRun == 1){
            //running affects ground speed
            Pawn.GroundSpeed = Pawn.Default.GroundSpeed * AffectRatio;
        } else {
           Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
        }

        if (RunningCounter <= -3){ //hack to ensure that it always takes at least 2 to recover
            bReadyToDash = true;
            RunningCounter = 0;
            SetMultiTimer(RUNNING_COUNTER,0,false);
            Pawn.AmbientSound = none;
        }
    }

    //safe guard to ensure that running is never slower than walking
    if (Pawn.GroundSpeed < Pawn.default.WalkingPct * Pawn.default.GroundSpeed){
        Pawn.GroundSpeed = (Pawn.default.WalkingPct * Pawn.default.GroundSpeed);
    }

    //Log("RUNNINGCOUNT: " $ RunningCounter $ "VOL:" $ Pawn.SoundVolume);
}

/*****************************************************************
 * Jump
 * Some additional running logic to prevent the player from jumping
 * around the level to speed through it
 *****************************************************************
 */
exec function Jump( optional float F )  {

    local float AffectRatio;

    if (bScriptDisabled == true) return;

    AffectRatio = 1- (float(runningCounter)/(RUNMAX + 3));

    //Log (AffectRatio);
    //Log ("rc : " $ RunningCounter);

    super.Jump( F );
    if (Pawn.bIsCrouched != true){
        Pawn.GroundSpeed = Pawn.Default.GroundSpeed * AffectRatio;
        if (bRun == 1){
            RunningCounter++;
             //ah, you ran too much
            if (RunningCounter > RUNMAX || RunningCounter < 0){
                Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
                bRun = 0;
                bReadyToDash = false;
                Pawn.PlaySound(AdvancedPawn(Pawn).HitSounds[0]);
            }
        }
    }
}

/**
 */
function bool NotifyLanded(vector HitNormal){
    Pawn.GroundSpeed = Pawn.default.GroundSpeed;
    return super.NotifyLanded( HitNormal);
}

/**
 * If ye be spectating, then ye be dead, or else fair Otis is dead.  In either
 * case, you can't do much except go back to the load-game menu.
 */
state Spectating
{
    function BeginState() {
//        log(self $ " In spectating state");
        StartedSpectatingTime = Level.TimeSeconds;
        ResetFOV();
    }

    //NOTE: you can't do this, because the player starts in specating mode very
    // briefly when the game inits.
    //function EndState() {
    //    GameOver();
    //}

    exec function Fire( optional float F ) {
        HandlePlayerInput();
    }

    exec function AltFire( optional float F ) {
        HandlePlayerInput();
    }

    function bool IsDead() {
        return true;
    }

    /**
     * Do clever stuff here to restart the game for the player...
     */
    function HandlePlayerInput() {

        if ( Level.NetMode == NM_Standalone ) {
            if ( Level.TimeSeconds - StartedSpectatingTime > MIN_SPECTATE_TIME ) {
                    AdvancedGameInfo(Level.Game).GameOver();
            }
        } else {
            //Log("MP game restarting player");
            ServerRestartPlayer();
        }
    }

   function ServerReStartPlayer()
    {
        if ( Level.NetMode == NM_Client )
            return;
        Level.Game.RestartPlayer(self);
    }

    function DrawToHud( Canvas c, float scaleX, float scaleY )
    {
      //display nothing
    }

}


/*****************************************************************
 * DemoProfileConfig      * DEMO code *
 * Setup profile info just for demo
 *****************************************************************
 */
function DemoProfileConfig()
{
    local bool InvertY;
    //local bool VoiceThruSpeakers;
    local bool VoiceMasking;
    local bool bUseVibration;

    // Make sure a profile exists just for Demo
    if(GetCurrentProfilename() != "DemoProfile")
    {
        class'Profiler'.static.NewProfile("DemoProfile");
        // Fill in with default values
        class'Profiler'.static.SetValue(constINVERTY, "false");
        //class'Profiler'.static.SetValue(constVOICETHRUSPEAKERS, "false");
        class'Profiler'.static.SetValue(constVOICEMASKING, "false");
        class'Profiler'.static.SetValue(constDIFFLEVEL, "1");
        class'Profiler'.static.SetValue(constSUBTITLES, "false");
        class'Profiler'.static.SetValue(constVIBRATION, "true");
    }

   //SET CURRENT PROFILE
      //Set your mouse look perference
      InvertY = bool(class'Profiler'.static.GetValue(constINVERTY));
      SetInvertLook(InvertY);

      //Set your voice thru speakers preference
      //VoiceThruSpeakers = bool(class'Profiler'.static.GetValue(constVOICETHRUSPEAKERS));
      //SetVoiceThruSpeakers(VoiceThruSpeakers);

      //Set your voice thru speakers preference
      VoiceMasking = bool(class'Profiler'.static.GetValue(constVOICEMASKING));
      SetVoiceMasking(VoiceMasking);

      //Set the difficulty level
      AdvancedGameInfo(Level.Game).iDifficultyLevel = int(class'Profiler'.static.GetValue(constDIFFLEVEL));
      SetDifficultyLevel(AdvancedGameInfo(Level.Game).iDifficultyLevel);

      //Set the difficulty level
      AdvancedGameInfo(Level.Game).bUseSubtitles = bool(class'Profiler'.static.GetValue(constSUBTITLES));

      //Log("Setting subtitles: " $ bUseSubtitles);
      SetUseSubtitles(AdvancedGameInfo(Level.Game).bUseSubtitles);

      bUseVibration = bool(class'Profiler'.static.GetValue(constVIBRATION));
      SetUseVibration(bUseVibration);
}


simulated function RefreshPRI(int matchID){
    local int i, j, k;
    local bool bSkip;
    local float currentRefreshTime;

    // Get all the PRI info
    //for(i=0;i<pris.length;i++){
    //  ObjMaker.FreeObject(pris[i]);
    //}
   // for(i=0;i<oldpris.length;i++){
    //  ObjMaker.FreeObject(oldpris[i]);
    //}

    if( (Level == None) || (GameReplicationInfo == None) )
        return;

    currentRefreshTime = Level.TimeSeconds;
    if( (currentRefreshTime - lastRefreshTime) < 0.5 )
        return;
    lastRefreshTime = currentRefreshTime;

    pris.Remove(0, pris.Length);
    oldpris.Remove(0, oldpris.Length);
    for( i=0; i<GameReplicationInfo.PRIArray.Length; i++ )
    {
        //if( pris[i] == None )
            //pris[i] = PlayerReplicationInfo(ObjMaker.AllocateObject(class'PlayerReplicationInfo'));
            pris.Length = pris.Length + 1;
        pris[i].Gamertag = GameReplicationInfo.PRIArray[i].Gamertag;
        pris[i].PlayerName = GameReplicationInfo.PRIArray[i].PlayerName;
        pris[i].Score = GameReplicationInfo.PRIArray[i].Score;
        pris[i].Deaths = GameReplicationInfo.PRIArray[i].Deaths;
        if( GameReplicationInfo.PRIArray[i].Team != None )
            pris[i].TeamIndex = GameReplicationInfo.PRIArray[i].Team.TeamIndex;
        pris[i].TeamID = GameReplicationInfo.PRIArray[i].TeamID;
        pris[i].xnaddr = GameReplicationInfo.PRIArray[i].xnaddr;
        pris[i].xuid = GameReplicationInfo.PRIArray[i].xuid;
        pris[i].Ranking = GameReplicationInfo.PRIArray[i].Ranking;
        pris[i].Kills = GameReplicationInfo.PRIArray[i].Kills;

        if( GameReplicationInfo.PRIArray[i] == PlayerReplicationInfo )
            myPRIIndex = i;
    }

    k = 0;
    for( i=0; i<GameReplicationInfo.OldPRIArray.Length; i++ )
    {
        bSkip = false;
        for( j=0; j<pris.length; j++ )
        {
            if( pris[j].Gamertag == GameReplicationInfo.OldPRIArray[i].Gamertag )
            {
                bSkip = true;
                break;
            }
        }
        if(bSkip)
            continue;
        for( j=0; j<oldpris.length; j++ )
        {
            if( oldpris[j].Gamertag == GameReplicationInfo.OldPRIArray[i].Gamertag )
            {
                bSkip = true;
                break;
            }
        }
        if(bSkip)
            continue;

        //if( oldpris[i] == None )
            //oldpris[k] = PlayerReplicationInfo(ObjMaker.AllocateObject(class'PlayerReplicationInfo'));
            oldpris.Length = oldpris.Length + 1;
        oldpris[k].Gamertag = GameReplicationInfo.OldPRIArray[i].Gamertag;
        oldpris[k].PlayerName = GameReplicationInfo.OldPRIArray[i].PlayerName;
        oldpris[k].Score = GameReplicationInfo.OldPRIArray[i].Score;
        oldpris[k].Deaths = GameReplicationInfo.OldPRIArray[i].Deaths;
        if( GameReplicationInfo.OldPRIArray[i].Team != None )
            oldpris[k].TeamIndex = GameReplicationInfo.OldPRIArray[i].Team.TeamIndex;
        oldpris[k].TeamID = GameReplicationInfo.OldPRIArray[i].TeamID;
        oldpris[k].xnaddr = GameReplicationInfo.OldPRIArray[i].xnaddr;
        oldpris[k].xuid = GameReplicationInfo.OldPRIArray[i].xuid;
        oldpris[k].Ranking = GameReplicationInfo.OldPRIArray[i].Ranking;
        oldpris[k].Kills = GameReplicationInfo.OldPRIArray[i].Kills;
        k++;
    }

    // Take out any duplicates
    //FilterDuplicates();
    // Sort the array & do ranking
    SortListByWhatever(matchID);

    // Get the GameRepInfo stuff
    //if( PlayerOwner().GameReplicationInfo.Teams != None)
    //{
        //TeamScores[0] = int(GameReplicationInfo.Teams[0].Score);
        //TeamScores[1] = int(GameReplicationInfo.Teams[1].Score);
    //}
}

/*****************************************************************
 * SortListByWhatever - uses Score & Deaths if DM or TDM, else uses Kills & Deaths, also does ranking
 *****************************************************************
 */
function SortListByWhatever(int gametype)
{
    local int i, k, s1, s2;
    local MyPRI tempplayerinfo;
    //local int currentRank;


    // First sort the players
    for(k=0; k <pris.length-1; k++)
    {
        for(i=0; i<pris.length-(k+1); i++)
        {
            if( gametype == 4 )
            {
                s1 = pris[i].Kills;
                s2 = pris[i+1].Kills;
            } else
            {
                s1 = pris[i].Score;
                s2 = pris[i+1].Score;
            }
            if(s1 < s2 || ((s1 == s2) && (pris[i].Deaths > pris[i+1].Deaths)) )
            {
                tempplayerinfo = pris[i];
                pris[i] = pris[i+1];
                pris[i+1] = tempplayerinfo;

                if( myPRIIndex == i )
                    myPRIIndex = i + 1;
                else if( myPRIIndex == (i + 1) )
                    myPRIIndex = i;
            }
        }
    }

    // Apply ranking
    for(i=0; i<pris.length; i++)
    {
        if( i == 0 )
            pris[i].Ranking = 1;
        else
        {
            if( gametype == 4 )
            {
                s1 = pris[i-1].Kills;
                s2 = pris[i].Kills;
            } else
            {
                s1 = pris[i-1].Score;
                s2 = pris[i].Score;
            }

            if( (s1 == s2) && (pris[i-1].Deaths == pris[i].Deaths) )
                pris[i].Ranking = pris[i-1].Ranking;
            else
                pris[i].Ranking = pris[i-1].Ranking + 1;
        }
    }
}

defaultproperties
{
     EndOfMatchMenuMP="DOTZMenu.DOTZPlayersListIG"
     PauseMenuMP="DOTZMenu.DOTZMPPause"
     bReadyToDash=True
     RunningSound=Sound'DOTZXCharacters.PlayerPainSounds.PlayerPainBreathing'
     PreLoadActors(0)="XDOTZCharacters.TeenagerHuman"
     PreLoadActors(1)="XDOTZCharacters.MilitaryHuman"
     PreLoadActors(2)="DOTZWeapons.BaseBallBatAmmunition"
     PreLoadActors(3)="DOTZWeapons.BaseBallBatAttachment"
     PreLoadActors(4)="DOTZWeapons.BaseBallBatWeapon"
     PreLoadActors(5)="DOTZWeapons.FireAxeAmmunition"
     PreLoadActors(6)="DOTZWeapons.FireAxeAttachment"
     PreLoadActors(7)="DOTZWeapons.FireAxeWeapon"
     PreLoadActors(8)="DOTZWeapons.FistAmmunition"
     PreLoadActors(9)="DOTZWeapons.FistWeapon"
     PreLoadActors(10)="DOTZWeapons.GlockAmmunition"
     PreLoadActors(11)="DOTZWeapons.GlockAttachment"
     PreLoadActors(12)="DOTZWeapons.GlockWeapon"
     PreLoadActors(13)="DOTZWeapons.GolfClubAmmunition"
     PreLoadActors(14)="DOTZWeapons.GolfClubAttachment"
     PreLoadActors(15)="DOTZWeapons.GolfClubWeapon"
     PreLoadActors(16)="DOTZWeapons.GrenadeAmmunition"
     PreLoadActors(17)="DOTZWeapons.GrenadeAttachment"
     PreLoadActors(18)="DOTZWeapons.GrenadeWeapon"
     PreLoadActors(19)="DOTZWeapons.HammerAmmunition"
     PreLoadActors(20)="DOTZWeapons.HammerAttachment"
     PreLoadActors(21)="DOTZWeapons.HammerWeapon"
     PreLoadActors(22)="DOTZWeapons.KungFuAmmunition"
     PreLoadActors(23)="DOTZWeapons.KungFuWeapon"
     PreLoadActors(24)="DOTZWeapons.LeadPipeAmmunition"
     PreLoadActors(25)="DOTZWeapons.LeadPipeAttachment"
     PreLoadActors(26)="DOTZWeapons.LeadPipeWeapon"
     PreLoadActors(27)="DOTZWeapons.M16Ammunition"
     PreLoadActors(28)="DOTZWeapons.M16Attachment"
     PreLoadActors(29)="DOTZWeapons.M16Weapon"
     PreLoadActors(30)="DOTZWeapons.MolotovAmmunition"
     PreLoadActors(31)="DOTZWeapons.MolotovAttachment"
     PreLoadActors(32)="DOTZWeapons.MolotovWeapon"
     PreLoadActors(33)="DOTZWeapons.RevolverAmmunition"
     PreLoadActors(34)="DOTZWeapons.RevolverAttachment"
     PreLoadActors(35)="DOTZWeapons.RevolverWeapon"
     PreLoadActors(36)="DOTZWeapons.RifleAmmunition"
     PreLoadActors(37)="DOTZWeapons.RifleAttachment"
     PreLoadActors(38)="DOTZWeapons.RifleWeapon"
     PreLoadActors(39)="DOTZWeapons.ShotGunAmmunition"
     PreLoadActors(40)="DOTZWeapons.ShotgunAttachment"
     PreLoadActors(41)="DOTZWeapons.ShotgunWeapon"
     PreLoadActors(42)="DOTZWeapons.ShovelAmmunition"
     PreLoadActors(43)="DOTZWeapons.ShovelAttachment"
     PreLoadActors(44)="DOTZWeapons.ShovelWeapon"
     PreLoadActors(45)="DOTZWeapons.SniperAmmunition"
     PreLoadActors(46)="DOTZWeapons.SniperAttachment"
     PreLoadActors(47)="DOTZWeapons.SniperWeapon"
     PreLoadActors(48)="DOTZWeapons.MountedWeaponA"
     PreLoadActors(49)="DOTZWeapons.MountedWeaponAmmunitionA"
     PreLoadActors(50)="DOTZWeapons.MountedWeaponAttachmentA"
     PreLoadActors(51)="XDOTZCharacters.MiddleAgedHuman"
}
