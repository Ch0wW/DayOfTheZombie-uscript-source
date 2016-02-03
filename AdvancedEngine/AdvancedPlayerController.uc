// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * AdvancedPlayerController -
 *
 * @version $Rev: 5335 $
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Nov 2003
 ****************************************************************
 */
class AdvancedPlayerController extends PlayerController
    implements( HudDrawable )
    implements( VideoNotification );



const DgrToUnr       = 182.04444444; //Degrees to unreal rot units
const ActionTimerID  = 228466; //(ACTION)
const HUD_INIT_TIMER = 18293;
const VIDEO_DELAY    = 3302;
const PAWNAPPEARANCE = 2223232;


struct SayStruct{
   var string Message;
   var int secs;
};
var array<SayStruct> SayMessages;

var bool bClearScreen;
var private string sCurrentVideo;
var HudQuantity MyLifeBar;
var bool bAllowedToFall;

var string MPMessage;

var AdvancedCheatManager advCheatManager;
var class<AdvancedCheatManager> AdvancedCheatClass;

var array<string> PreLoadActors;

enum E_SWAYTYPE{
   SWAY_NONE,
   SWAY_CIRCLE,
   SWAY_FORWARD,
   SWAY_SIDEWAYS,
};

var VideoPlayer objVideoPlayer;

var float TickDelta; //stores the length of the current tick
var E_SWAYTYPE SwayType;
var float SwayTheta; //internal
var float SwayDelta; //internal
var float SwayRate; //rate of sway in seconds
var float SwayMag; //magnitude of sway

var int FallState;    //falling, waiting, getting up
var float FallDelay;  //running total of time waited after hit the ground
var float FallTheta;  //falling counter
var float FallDelta;  //system controlled rate of fall
var float FallRate;   //multiplier for falldelta
var int FallDir;
var Rotator FallRotation;

//view restriction vars
var int maxViewPitch;
var int minViewPitch;
var int maxMountPitch;
var int minMountPitch;

//actionable object vars
var int ActionRadius;

var rotator LastCameraRotation;
var vector LastCameraLocation;

//accuracy related variables
const iMaxInaccuracy = 0.5;
var float iInaccuracy;
var float iInaccuracyDelta;
var float iInaccuracyRotDelta;
var float iInaccuracyDecline;
var float iCrouchAccuracyMod;
var int iInaccCount;
var bool bSecondaryAudioMode;

var() bool bDisablePawnHud;
var() bool bDisableHealth;

var Emitter theWeatherEffect;

//fade stuff
var bool bDoFade;
var vector LastFlashView;
var vector TargetFlashView;

var vector FadeColour;
var float FadeTime;
var bool bLoading; //hack?

var localized string LoadingMessageTxt;
var int numFailures;
var transient CameraEffect MotionBlur;
var bool bIsBlurred;

// zoom view (for internal use only)
var bool bUnZooming; //NOTE might be excessive..?
var float ZoomFOV;
var float TimeToZoom;
var float TimeToUnZoom;
// (^ internal use only)

var Material SpectatingOverlay;
var localized string SpectatingMsg;

var bool bGameOver;
var bool RegisteredWithHud;
var bool acc;

var Actor objActionableActor;
var bool bCloseMenuPending;

const DEFAULT_ZOOM_TIME = 0.1;
const DEATH_MSG = 34342423;

var bool bCamAnimate;
var bool bShouldInvert;
var bool bUseVibration;

var int iHeadTexture;
var int iBodyTexture;

var bool bNoPauseMenu;
var bool bCameraLock;

replication{
   reliable if( bNetDirty && bNetOwner && Role==ROLE_Authority )
        bShouldInvert;

    unreliable if( Role<ROLE_Authority )
        Action, ServerSetPitch, NextGun, PrevGun, NextGrenade, PrevGrenade, NextMelee, PrevMelee;

    // Functions server can call.
    reliable if( Role==ROLE_Authority )
       fall;
}

var string ActionKey;

var bool bPlayingROQMovie;
var bool bStoppingROQMovie;

const ActionKeyUpdateID = 432424;

/*****************************************************************
 * SetSpeedMultiplier
 *****************************************************************
 */
function SetSpeedMultiplier(float MovementRate){
    //  Pawn.GroundSpeed = MovementRate;
    AdvancedPawn(Pawn).Notify_SetSpeed(MovementRate);
}

/*****************************************************************
 * ROQMovieStopped
 *****************************************************************
 */
event ROQMovieStopped(){

    if (bStoppingROQMovie == true) return;

    bStoppingROQMovie = true;
    if (AdvancedGameInfo(Level.Game).TheSubtitles != none){
      AdvancedGameInfo(Level.Game).TheSubtitles.KillSubtitles();
    }
    bClearScreen=false;
    Level.Game.SetPause(false,self);
    bPlayingROQMovie = false;
    ViewTarget.PlaySound(None);
    ConsoleCommand( "UnPauseSounds");
    PlayMusic(Song,0.1);
    bStoppingROQMovie = false;
    TriggerEvent('ROQComplete',None,None);

}

/*****************************************************************
 * PlayMovie
 *****************************************************************
 */
exec function PlayMovie(String MovieFileName, bool bLoop, sound SoundFile, float ScaleX, float ScaleY)   {

    ClientFlash(0,vect(0,0,0));
    bClearScreen=true;
    StopAllMusic(0.1);
    ConsoleCommand( "PauseSounds");
    bPlayingROQMovie = true;
    if (SoundFile != none){
        //log(SoundFile);
         ViewTarget.PlaySound(SoundFile);
    }

    Level.Game.SetPause(true,self);

    //float Left, float Top, float Right, float Bottom,
    AdvancedHud(myHud).PlayMovieScaled(MovieFileName,0, 0, ScaleX,
                                                 /*1*/ ScaleY, false, false);

}

exec function PlayM()
{
    PlayMovie("Demi.RoQ", false, none,1,0.87);
}

exec function PauseMovie()
{
   myHud.PauseMovie(!myHud.IsMoviePaused());
}

exec function StopMovie()
{
   myHud.StopMovie();
}

function bool IsMoviePlaying()
{
    return bPlayingROQMovie;
//   return myHud.IsMoviePlaying();
}

exec function RenderLog(){
   AdvancedWeapon(Pawn.Weapon).brenderlog = !AdvancedWeapon(Pawn.Weapon).brenderlog;
}

exec function Killme(){
   if (Pawn!=None){
      Pawn.TakeDamage(1000, none, Pawn.Location, vect(0,0,0), None);
   }
}

exec function dumpplayers(){
   local int i;
  // Log("PRIArray");
   for (i=0;i < GameReplicationInfo.PRIArray.Length; i++){
      Log(GameReplicationInfo.PRIArray[i].Gamertag $ " : " $ GameReplicationInfo.PRIArray[i].UID );
   }

   //Log("oldPRIArray");
   for (i=0;i < GameReplicationInfo.oldPRIArray.Length; i++){
      Log(GameReplicationInfo.oldPRIArray[i].Gamertag $ " : " $ GameReplicationInfo.oldPRIArray[i].PlayerName );
   }


}

exec function Cam(){
   bCamAnimate = !bCamAnimate;
}


exec function DumpFlag(){
   Log(PlayerReplicationInfo.HasFlag);
}

exec function DumpRep(){
   Log(PlayerReplicationInfo.bHasFlag $ " Has Flag");
   Log(PlayerReplicationInfo.Team.TeamIndex $ " Team Index");
   Log(PlayerReplicationInfo.HasFlag $ " CarriedObject");
}

exec function NextGun(){
   if (AdvCheatManager != None){
       AdvCheatManager.ProcessInput(12);
    }
}
exec function PrevGun(){
   if (AdvCheatManager != None){
    AdvCheatManager.ProcessInput(11);
   }
}
exec function NextGrenade(){
   if (AdvCheatManager != None){
       AdvCheatManager.ProcessInput(10);
    }
}
exec function NextMelee(){
   if (AdvCheatManager != None){
    AdvCheatManager.ProcessInput(9);
   }
}
exec function PrevMelee();
exec function PrevGrenade();


exec function Jump( optional float F )  {
   super.Jump(F);
   if (AdvCheatManager != None){
    AdvCheatManager.ProcessInput(1);
   }
}

exec function AltFire( optional float F ) {
   super.AltFire(F);
   if (AdvCheatManager != None){
    AdvCheatManager.ProcessInput(2);
   }
}

// The player wants to fire.
exec function Fire( optional float F )
{
   super.Fire(F);
   if (AdvCheatManager != None){
       AdvCheatManager.ProcessInput(8);
    }
}

function AddCheats()
{
   super.AddCheats();
    // Assuming that this never gets called for NM_Client
    if ( advCheatManager == None && (Level.NetMode == NM_Standalone) )
        advCheatManager = new(Self) AdvancedCheatClass;
}

simulated event ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
   super.ReceiveLocalizedMessage(Message, switch,RelatedPRI_1, RelatedPRI_2,OptionalObject);


   if (RelatedPRI_1 != none && RelatedPRI_2 !=None){
      SetMultiTimer(DEATH_MSG, 4, false);
      Message.Static.ClientReceive( Self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
      MPMessage = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
   }
}

event TeamMessage( PlayerReplicationInfo PRI, coerce string S, name Type  )
{
    if ( myHUD != None )
    myHUD.Message( PRI, S, Type );

    if ( ((Type == 'Say') || (Type == 'TeamSay')) && (PRI != None) ){
        S = PRI.Gamertag$": "$S;

      if (SayMessages.Length < 4){
         SayMessages.Length = SayMessages.Length + 1;
        // Log(SayMessages.Length);
         SayMessages[SayMessages.length-1].Message = S;
         SayMessages[SayMessages.Length-1].secs = Level.TimeSeconds;
      }
   }
   else if (Type== 'Generic' && PRI != None)
   {
        SetMultiTimer(DEATH_MSG, 4, false);
        MPMessage =  S;
   }


}


/*****************************************************************
 * NextWeaponByClass
 *****************************************************************
 */
function Weapon NextWeaponByClass(Inventory StartPoint, name WeaponClass, optional bool bRequireAmmo){

   local Inventory TempWeapon, CandidateWeapon, LowestRanked;

   if( Level.Pauser!=None ) { return Weapon(StartPoint); }
   if (AdvancedPawn(Pawn).IsInInventory(StartPoint) == false) {
      if (Pawn.FindInventoryType(Pawn.Weapon.class) !=None){
         StartPoint = Pawn.Weapon;
      } else {
         StartPoint = none;
      }
   }

   TempWeapon = Pawn.Inventory;
   while(TempWeapon != None) {

      //if you have found a weapon of the right class with a higher ranking
      //than your current weapon, but lower then the best candidate
      //and not the current weapon
      if (TempWeapon.IsA(WeaponClass) &&
          ( StartPoint == none || TempWeapon.InventoryGroup >= StartPoint.InventoryGroup) &&
          ( CandidateWeapon == none || TempWeapon.InventoryGroup < CandidateWeapon.InventoryGroup)&&
          (TempWeapon != StartPoint && StartPoint!=None))
      {
         //if no ammo and you want a gun with ammo
         if (!(bRequireAmmo && (Weapon(TempWeapon).AmmoType == none || Weapon(TempWeapon).AmmoType.AmmoAmount == 0) &&
             Weapon(TempWeapon).ReloadCount == 0)){
            CandidateWeapon = Weapon(TempWeapon);
         }

      }

      //While you are at it keep track of the lowest ranked weapon of this
      //class, so that if the startingpoint happens to be the highest ranked
      //weapon you can cycle back to the lowest
      if (TempWeapon.IsA(WeaponClass) &&
         (LowestRanked == none || TempWeapon.InventoryGroup <= LowestRanked.InventoryGroup )){
         //check it has ammo if required
         if (!(bRequireAmmo && (Weapon(TempWeapon).AmmoType == none || Weapon(TempWeapon).AmmoType.AmmoAmount == 0) &&
             Weapon(TempWeapon).ReloadCount == 0)){
            LowestRanked = TempWeapon;
         }
      }

      TempWeapon = TempWeapon.Inventory;
   }

   //can't find a next weapon
   if (CandidateWeapon == None){
      //can't find a lowest weapon
      if (LowestRanked != none){
         Pawn.PendingWeapon = Weapon(LowestRanked);
      }
   } else {
      Pawn.PendingWeapon = Weapon(CandidateWeapon);
   }

   if ( Pawn.PendingWeapon != None && Pawn.PendingWeapon != Pawn.Weapon ) {
      Pawn.Weapon.PutDown();
      ClientSetWeapon(Pawn.PendingWeapon.Class);
   }
   return Pawn.PendingWeapon;
}


/*****************************************************************
 * PrevWeaponByClass
 *****************************************************************
 */
function Weapon PrevWeaponByClass(Inventory StartPoint, name WeaponClass,optional bool bRequireAmmo){

   local Inventory TempWeapon, CandidateWeapon, HighestRanked;

   if( Level.Pauser!=None ) { return Weapon(StartPoint); }
   if (Pawn.FindInventoryType(StartPoint.class) == none) {
      if (Pawn.FindInventoryType(Pawn.Weapon.class) !=None){
         StartPoint = Pawn.Weapon;
      } else {
         StartPoint = none;
      }
   }

   TempWeapon = Pawn.Inventory;
   while(TempWeapon != None) {

      //if you have found a weapon of the right class with a higher ranking
      //than your current weapon, but lower then the best candidate
      //and not the current weapon
      if (TempWeapon.IsA(WeaponClass) &&
          ( StartPoint == none || TempWeapon.InventoryGroup <= StartPoint.InventoryGroup) &&
          (CandidateWeapon == none || TempWeapon.InventoryGroup > CandidateWeapon.InventoryGroup)&&
          (StartPoint!=None && TempWeapon != StartPoint))
      {
         //check it has ammo if required
         if (!(bRequireAmmo && (Weapon(TempWeapon).AmmoType == none || Weapon(TempWeapon).AmmoType.AmmoAmount == 0) &&
             Weapon(TempWeapon).ReloadCount == 0)){
            CandidateWeapon = Weapon(TempWeapon);
         }
      }

      //While you are at it keep track of the lowest ranked weapon of this
      //class, so that if the startingpoint happens to be the highest ranked
      //weapon you can cycle back to the lowest
      if (TempWeapon.IsA(WeaponClass) &&
         (HighestRanked == none || TempWeapon.InventoryGroup >= HighestRanked.InventoryGroup)){
         //check it has ammo if required
         if (!(bRequireAmmo && (Weapon(TempWeapon).AmmoType == none || Weapon(TempWeapon).AmmoType.AmmoAmount == 0) &&
             Weapon(TempWeapon).ReloadCount == 0)){
            HighestRanked = TempWeapon;
         }
      }

      TempWeapon = TempWeapon.Inventory;
   }

   //can't find a next weapon
   if (CandidateWeapon == None){
      //can't find a lowest weapon
      if (HighestRanked != none){
         Pawn.PendingWeapon = Weapon(HighestRanked);
      }
   } else {
      Pawn.PendingWeapon = Weapon(CandidateWeapon);
   }

   if ( Pawn.PendingWeapon != None && Pawn.PendingWeapon != Pawn.Weapon ) {
      Pawn.Weapon.PutDown();
      ClientSetWeapon(Pawn.PendingWeapon.Class);
   }
   return Pawn.PendingWeapon;
}



exec function Fix1(){
    local AdvancedPlayerController p;
    foreach AllActors(class'AdvancedPlayerController', p){
        p.SetCustomTextures();
    }
    log(iHeadTexture $ iBodyTexture);
}

exec function Fix2(){
    local AdvancedPlayerController p;
    foreach AllActors(class'AdvancedPlayerController', p){

        log(p.Pawn.Skins.length);
        p.Pawn.Skins.length = 0;
        p.Pawn.CopyMaterialsToSkins();
        log(p.Pawn.Skins.length);
    }
}

exec function Skins()
{
    local AdvancedPlayerController p;
    foreach AllActors(class'AdvancedPlayerController', p){
        log(p.Pawn.Skins[0]);
        log(p.Pawn.Skins[1]);
    }
}

/*****************************************************************
 * SetCustomTextures
 *****************************************************************
 */
function SetCustomTextures(){
   if (Pawn !=None){
      AdvancedPawn(Pawn).SetCustomAppearance(iHeadTexture, iBodyTexture);
      SetMultiTimer(PAWNAPPEARANCE, 0,false);
      log(self $ "&& Setting appearance" $ iHeadTexture $ iBodyTexture);
   } else {
       SetMultiTimer(PAWNAPPEARANCE, 1,true);
       log(self $ "&& waiting to set appearance");
   }
}

/*****************************************************************
 * PostNetReceive
 * Handles the case (albiet awkwardly) of trying to close the menu
 * when the player controller doesn't have a 'player' yet.
 *****************************************************************
 */
simulated event PostNetReceive(){
    //handle the pending close menu
    If (bCloseMenuPending == true && Player !=None){
        Player.GUIController.CloseAll(true);
        bCloseMenuPending = false;
    }
}

/****************************************************************
 * PostBeginPlay
 *
 ****************************************************************
 */
function PostBeginPlay() {
    UpdateActionKey();
    SetMultiTimer( ActionKeyUpdateID, 1, false);
    SetMultiTimer( ActionTimerID, 0.25, true);
    Super.PostBeginPlay();
    ClientFlash(0, vect(0,0,0));
    EnableWeatherEffect( self );
    objVideoPlayer = new (Level) Class'BinkVideoPlayer';
    objVideoPlayer.RegisterForNotification(self); //let me know when a video ends
}

/*****************************************************************
 * PostNetBeginPlay
 * Close any menus when you start as a client
 *****************************************************************
 */
function PostNetBeginPlay(){
    super.PostNetBeginPlay();
   UpdateActionKey();
   SetMultiTimer( ActionKeyUpdateID, 1, false);
   ClientCloseMenu(true);
   //AdvancedPawn(Pawn).HudCaption = PlayerReplicationInfo.Gamertag;

   // CARROT: Sets the timeout to 15 seconds instead of 500
    MotionBlur = new class'MotionBlur';

   bShortConnectTimeOut = true;
}

/*****************************************************************
 * SetPause
 *****************************************************************
 */
simulated function bool SetPause(BOOL bPause){

   UpdateActionKey();
   if (AdvancedGameInfo(Level.Game).TheSubtitles != none){
      AdvancedGameInfo(Level.Game).TheSubtitles.KillSubtitles();
   }
   return super.SetPause(bPause);
}

exec function ClientPause(){
   UpdateActionKey();
}

/*****************************************************************
 * SetPawnClass
 * Overridden so that inCharacter can override the default pawn type
 *****************************************************************
 */
function SetPawnClass(string inClass, string inCharacter)
{
   local int i;
    local class<Pawn> pClass;

    for( i=0; i<PreloadActors.length; i++){
      DynamicLoadObject(PreloadActors[i],class'class');
    }

    pClass = class<Pawn>(DynamicLoadObject(inCharacter, class'Class'));
    if (pClass == none){
       pClass = class<Pawn>(DynamicLoadObject(inClass, class'Class'));
    }
    PawnClass = pClass;
}

/*****************************************************************
 * ClientCloseMenu
 * Should close the damn menu, but guess what, sometimes your
 * not ready. So wait til the crap comes in over the pipes in PostNetRecieve
 *****************************************************************
 */
event ClientCloseMenu(optional bool bCloseAll, optional bool bCancel){

    //Log("ClientCloseMenu called -  Player: " $ Player );
    if (Player !=None){
        //Log("ClientCloseMenu called -  GuiController: " $ Player.GuiController );
        if (bCloseAll)
            Player.GUIController.CloseAll(bCancel);
        else
            Player.GUIController.CloseMenu(bCancel);
    }   else {
        bCloseMenuPending = true;
    }
}


exec function dumpActors(){
    local actor temp;
    local int count;
    foreach AllActors(Class'Actor', temp){
        Log(temp);
        count++;
    }
    Log("There are : " $ count $ " actors in the map");
}

exec function DumpAcc(){
    if (!acc){
        SetMultiTimer(1, 0.3, true);
    } else {
        SetMultiTimer(1,0,false);
    }
}

exec function Detail(){
   if (objActionableActor != none){

      Log(" Object: " $ objActionableActor.GetHumanReadableName());
      Log(" State: " $ objActionableActor.GetStateName());


      //details on an actionable weapon pickup
      if (AdvancedWeaponPickup(objActionableActor) !=None){
          Log( " Inventory   : " $ AdvancedWeaponPickup(objActionableActor).Inventory);
          if (AdvancedWeaponPickup(objActionableActor).Inventory != none){
              Log( " ReloadCount : " $ AdvancedWeapon(AdvancedWeaponPickup(objActionableActor).Inventory).ReloadCount);
              Log( " Owner : " $ AdvancedWeapon(AdvancedWeaponPickup(objActionableActor).Inventory).Owner);
          }
      }



  }
}

/*****************************************************************
 *
 *****************************************************************
 */
exec function InvertLook(bool bIsChecked){
   ConsoleCommand("set PlayerInput bInvertMouse " $ bIsChecked);
   class'PlayerInput'.default.bInvertMouse = bIsChecked;
   class'PlayerInput'.static.StaticSaveConfig();
}

exec function Weapons();

exec function DumpPawns(){
    local Pawn temp;
    foreach AllActors(class'Pawn', temp){
        //Weapons
        if (temp.Weapon == none){
         Log(temp $ " Weapon is none");
        } else {
         Log(temp $ " " $ temp.Weapon $ " in state: " $ temp.Weapon.GetStateName() );
        }
        //PendingWeapons
        if (temp.PendingWeapon == none){
          Log(temp $ " PendingWeapon is none");
        } else {
         Log(temp $ " " $ temp.PendingWeapon);
        }
        //ThirdPerson
        /*if (temp.ThirdPersonActor == none){
          Log(temp $ " ThirdPersonActor is none");
        } else {
         Log(temp $ " " $ temp.ThirdPersonActor);
        } */



    }
}

exec function DumpPawn(){
    if (Pawn != none){
        Log(self $ " :  " $ Pawn);
    }
}

exec function Dumpweapon(){
    Log(self $ " current weapon: " $ Pawn.Weapon);
    Log(self $ " current pending: " $ Pawn.PendingWeapon);
    Log(self $ " current ammotype: " $ Pawn.Weapon.AmmoType);
    Log(self $ " weapon state: " $ Pawn.weapon.GetStateName());
}

exec function DumpHUD(){
    Log(self $ myHUD);
}

exec function DumpState(){
    Log(self $ " " $ GetStateName());
}

exec function Select(){
    Log("Play Select");
    Pawn.Weapon.PlaySelect();
}

exec function Deselect(){
    Log("Play Select");
    Pawn.Weapon.PlaySelect();
}

exec function NoFall(){
   bAllowedToFall = false;
   if (Pawn != none){ AdvancedPawn(Pawn).bAllowedToFall = false; }
}

/**
 * Called each time a level is loaded.  After restoring from a save-game,
 * a new HUD object is spawned, so we have to re-register.
 */
event PostLoad() {
    MotionBlur = new class'MotionBlur';
    super.PostLoad();
//    Log(self $ "PostLoad: there are ... " $ CameraEffects.length);
    if ( bIsBlurred ){ AddCameraEffect(MotionBlur); }
    RegisteredWithHud = false;
    Level.Game.SetPause(false,self);
    SetMultiTimer( HUD_INIT_TIMER, 0.5, false );
    // restore cheat manager...
    AddCheats();
}


/*****************************************************************
 * PreClientTravel
 * Update your playtime before you leave this level
 *****************************************************************
 */
event PreClientTravel(){
   super.PreClientTravel();
   if (Pawn != none){
      AdvancedPawn(Pawn).CalcPlayTime();
   }
}

/****************************************************************
 * MotionBlurOn
 * Turns on the motion blur, not for use with other effects currently
 ****************************************************************
 */
exec function MotionBlurOn() {
    if ( bIsBlurred == true){ return; }
    bIsBlurred = true;
//   log("add camera effect");
    AddCameraEffect(MotionBlur);
}

/****************************************************************
 * MotionBlurOff
 *
 ****************************************************************
 */
exec function MotionBlurOff() {
   if ( CameraEffects.length == 0 || bIsBlurred == false){ return; }
   bIsBlurred = false;
//   log("remove camera effect");
   RemoveCameraEffect(MotionBlur);
   //log(CameraEffects.length);
}


/****************************************************************
 * Nuke
 * Destroy all pawns in the level
 ****************************************************************
 */
exec function Nuke()
{
   local Pawn temp;

    if( Level.Netmode!=NM_Standalone )
        return;

   foreach AllActors(class'Pawn', temp){
      if (temp.Controller != Level.GetLocalPlayerController() &&
           Level.GetLocalPlayerController().SameTeamAs(temp.Controller) == false){
         temp.TakeDamage(1000, Level.GetLocalPlayerController().Pawn, temp.Location, vect(0,0,0), None);
      }
   }
}

/*****************************************************************
 * dumpinv
 *****************************************************************
 */
exec function dumpinv(){
    local inventory inv;
    inv = Pawn.inventory;

    while (inv != none){
        if (Ammunition(inv) != none){
            Log(inv $ " :  ammo: " $ Ammunition(inv).AmmoAmount);
        } else if (Weapon(inv) != none){
            Log(inv $ " :  reloadcount: " $ Weapon(inv).ReloadCount);
        } else {
            Log(inv);
        }
        inv = inv.inventory;
    }
}

/****************************************************************
 * Magic
 * Makes objects appear in front of the player
 ****************************************************************
 */
exec function Magic(string actorname){

   local class<Actor> newActor;
   newActor = class<Actor>(DynamicLoadObject(actorname, class'Class'));

   if (Pawn!=None){
      Spawn(newactor,,,Pawn.location + (vector(Pawn.Rotation) * 100 ));
   }
}

/*****************************************************************
 *
 *****************************************************************
 */
exec function TestSwitch(){
    SwitchToBestWeapon();
}


function SwitchToBestWeapon(){

//   Log("SwitchToBestWeapon");
   super.SwitchToBestWeapon();
}

/*****************************************************************
 * ClientSetHUD
 * Ovverridden as a test, seems that the HUDtype might not actually match the
 * .class?
 *****************************************************************
 */
function ClientSetHUD(class<HUD> newHUDType, class<Scoreboard> newScoringType)
{
    local HUD NewHUD;


    //Log( self $ " Client Set hud is called ");

    if ( (myHUD == None) || (newHUDType != None)) //&& (newHUDType != myHUD.Class)) )
    {
        NewHUD = spawn(newHUDType, self);
        if ( NewHUD != None )
        {
            if ( myHUD != None )
                myHUD.Destroy();
            myHUD = NewHUD;
        }
    }
    if ( (myHUD != None) && (newScoringType != None) )
        MyHUD.SpawnScoreBoard(newScoringType);

    //@@@ attempt to get hud set up in mp
    RegisteredWithHud = false;
    SetMultiTimer( HUD_INIT_TIMER, 0.5, false );

}




function float RateWeapon(Weapon W){
    return W.Default.AutoSwitchPriority;
}

exec function TestPriority(){
    local int test;

    if ( Pawn.IsHumanControlled() )
        test =  Pawn.Weapon.RateSelf();
    else if ( !Pawn.Weapon.HasAmmo() )
    {
        if ( Pawn.Weapon == self )
            test = -0.5;
        else
            test = -1;
    }
    else
        test = Pawn.Weapon.default.AutoSwitchPriority;
        Log("PendingWeapon: " $ Pawn.PendingWeapon);
        log("Weapon Priority: " $ test);
}

/**
 * Toggles the (static) reticule on the current weapon.
 */
exec function ToggleReticule() {
    local AdvancedWeapon aw;
    aw = AdvancedWeapon( pawn.weapon );
    if ( aw != none ) {
        if ( aw.StaticReticule != none ) aw.StaticReticule = none;
        else aw.StaticReticule = aw.default.StaticReticule;
    }
}

/*****************************************************************
 * Kills
 * Toogles the pawn to show the number of kills you have
 *****************************************************************
 */
exec function kills(){
    AdvancedPawn(Pawn).bDisplayKills =
        !AdvancedPawn(Pawn).bDisplayKills;
}

exec function game(){
    local Pawn p;
    foreach AllActors(class'Pawn',p){
        log(p.xGamerTag);
    }
}

/****************************************************************
 * Possess
 * When possessing a pawn, let it handle weather effects.
 ****************************************************************
 */
function Possess( Pawn p ) {
    local class<Emitter> effectClass;
    local Emitter theWeatherEffect;

    //Log(self $ "Possess");
    //ClientSwitchToBestWeapon();

    DisableWeatherEffect();
    super.Possess( p );

    effectClass = getWeatherEffectClass();
    if ( effectClass != None ) {
        theWeatherEffect = Spawn( effectClass, pawn );
        if ( theWeatherEffect != None ) {
            theWeatherEffect.setBase( pawn );
        }
    }

    //NOTE a little hack to make sure the weapon gets properly
    //     initialized, in case the pawn already had it when possessed.
    if (advancedPawn(p).objMount !=None){
       //GotoState('PlayerMounted');
       advancedPawn(p).objMount.DoMount(p);
    } else {
       p.weapon.bringUp();
    }
}



/****************************************************************
 * UnPossess
 * Unpossessing means you might be switching to a cinematic, so turn
 * on the weather again on the controller.
 ****************************************************************
 */
function UnPossess() {
    EndSway();
    EndZoom();
    EnableWeatherEffect( self );
    Pawn.Weapon.PutDown();
    super.UnPossess();
}


function ClientSwitchToBestWeapon(){
    super.ClientSwitchToBestWeapon();
    //Log(" Call to client switch to best weapon: " $ Pawn.Weapon);
}

/****************************************************************
 * MultiTimer
 *
 ****************************************************************
 */
function MultiTimer(int TimerID){
   switch(TimerID){

   case 1:
       Log("traceAcc: " $ Pawn.Weapon.TraceAccuracy);
       break;

   case ActionTimerID:
       CheckForActionableActor();
       break;

   case HUD_INIT_TIMER:
       if (!RegisteredWithHud){
           AdvancedHud(MyHUD).register(self, true);
           RegisteredWithHud = true;
       }
       break;

   case VIDEO_DELAY:
        if (objVideoPlayer!=None){
           objVideoPlayer.ScaleVideo(0.85);
           objVideoPlayer.PlayVideo( sCurrentVideo );
           Level.Game.SetPause(true,self);
        }
       break;

   case DEATH_MSG:
      MPMessage = "";
      break;

    case ActionKeyUpdateID:
        UpdateActionKey();
        break;

    case PAWNAPPEARANCE:
        SetCustomTextures();
        break;

   default:
       super.MultiTimer( timerID );
   }
}


/****************************************************************
 * QuickSave
 * Overridden to provide a name to the save
 ****************************************************************
 */
exec function QuickSave(){
   if ( (Pawn.Health > 0) && (Level.NetMode == NM_Standalone) ){
      ClientMessage(QuickSaveString);
      AdvancedGameInfo(Level.Game).QuickSave();
   }
}

/****************************************************************
 * Overridden to ensure that slot numbers are in synch with
 * AdvancedGameInfo.
 ****************************************************************
 */

function string EncodeStringURL(string s) {
    local string r;
    local string c;
    local int i;

    for (i = 0; i < Len(s); ++i) {
        c = Mid(s,i,1);

        if (c == " ") {
            r = r $ "_";
        } else {
            r = r $ c;
        }
    }

    return r;
}

exec function QuickLoad() {
    local int ireal;

    if (Level.NetMode == NM_Standalone) {


        class'UtilsXbox'.static.Filter_Containers("QUICKSAVE", "true");

        if (class'UtilsXbox'.static.Get_Num_Filtered_Containers() > 0) {
            ireal = class'UtilsXbox'.static.Filtered_To_Real_Index(0);

            if (class'UtilsXbox'.static.Get_Container_Meta(ireal, "OWNER") ==
                class'Profiler'.static.GetCurrentProfileName()) {
                AdvancedHUD(myHud).Message(PlayerReplicationInfo, LoadingMessageTxt, 'INFO');
                bLoading = true;
                ClientTravel( "?loadnamed=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Container_Meta(ireal, "TITLE")), TRAVEL_Absolute, false );
            }
            //ClientTravel( "?loadnamed=" $ class'UtilsXbox'.static.Get_Container_Name(0), TRAVEL_Absolute, false );
        } else {
            Log("No quicksaves");
        }

       // CARROT: Get the name of the game
       //loadgame = AdvancedGameInfo(Level.Game).GetSlotNameEncoded(class'AdvancedGameInfo'.default.QUICK_SLOT);

        //ClientTravel( "?load=" $ class'AdvancedGameInfo'.default.QUICK_SLOT, TRAVEL_Absolute, false );
//        Log("Client travel to " $ loadgame);
    }
}


//===========================================================================
// Video Stuff
//===========================================================================


/*****************************************************************
 * VideoComplete
 * Implemented for VideoNotification interface. Informs you when a
 * video is complete
 *****************************************************************
 */
function VideoComplete(bool completed){
    if (AdvancedGameInfo(Level.Game).TheSubtitles != none){
      AdvancedGameInfo(Level.Game).TheSubtitles.KillSubtitles();
    }
    bClearScreen=false;
    Level.Game.SetPause(false,self);
    ConsoleCommand( "UnPauseSounds");
    PlayMusic(Song,0.1);
}

/*****************************************************************
 * PlayVideo
 * use the VideoPlayer to start a video please, also pause
 *****************************************************************
 */
function PlayVideo(string VideoName){
    if (objVideoPlayer != None){
        ClientFlash(0,vect(0,0,0));
        bClearScreen=true;
        StopAllMusic(0.1);
        sCurrentVideo = VideoName;
        ConsoleCommand( "PauseSounds");
        SetMultiTimer(VIDEO_DELAY,0.05, false);
    }
}


/****************************************************************
 * CrappyMode
 * Secondary Audio mode
 ****************************************************************
 */
exec function CrappyMode(){
   bSecondaryAudioMode = !bSecondaryAudioMode;
   //   if (Pawn!=None && Pawn.Weapon != None){
      //AdvancedWeapon(Pawn.Weapon).ToggleCrappyMode();
   //}
}

/****************************************************************
 * TogglePawnHud
 ****************************************************************
 */
exec function TogglePawnHud() {
    bDisablePawnHud = !bDisablePawnHud;
}

exec function ToggleHealthHud() {
    bDisableHealth = !bDisableHealth;
}


/****************************************************************
 * ForceCylinderCollision
 * Debugging method, forces all static meshes to cynlinder collision
 ****************************************************************
 */
exec function ForceCylinderCollision() {
    local StaticMeshActor a;

    ForEach AllActors( class'StaticMeshActor', a ) {
        a.bUseCylinderCollision = true;
    }
}

/****************************************************************
 * Fade
 * Not just a fade (as the name might imply). It also takes control
 * away from the player so that they can't keep moving around and
 * screw things up while the fade is happening.
 ****************************************************************
 */
exec function Fade(){
   //bDisablePawnHud = true;
   AdvancedHud(MyHUD).HideHud();
   //StopAllMusic(0.1);
   ConsoleCommand( "PauseSounds");
   bDoFade = true;
   bGodMode = true;
   LastFlashView = vect(1,1,1);
   TargetFlashView = vect(1,1,1);
}

/**
 * Use at own risk!
 */
exec function DestroyActor( string actorName ) {
    local Actor target;

    target = Actor( FindObject( actorName, class'Actor' ) );
    if ( target != none ) target.destroy();
}


/*****************************************************************
 * ServerSetPitch
 *****************************************************************
*/
function ServerSetPitch(int Pitch){
   if(Pawn != none){
    AdvancedPawn(Pawn).AimedPitch = Pitch;
    Pawn.PostNetReceive();
   }
  // Log(self $ " ServerSetPitch " $ Pitch);
}


function rotator AdjustAim(Ammunition FiredAmmunition, vector projStart, int aimerror)
{
    if (SwayType == SWAY_NONE){
        return super.AdjustAim(FiredAmmunition, projStart, aimerror);
    } else {
        return Rotation + LastCameraRotation;
    }
}

/*****************************************************************
 * PlayerCalcView
 *****************************************************************
 */
event PlayerCalcView(out actor ViewActor, out vector CameraLocation,
                         out rotator CameraRotation ){

   local vector HeadLoc, CameraLoc;
   local rotator HeadRot, CameraRot;
   local name HeadBoneName, CameraBoneName;

   HeadBoneName = 'Head';
   CameraBoneName = 'Camera';
   Super.PlayerCalcView(ViewActor,CameraLocation, CameraRotation);

   if (Pawn != none){
      if ( abs(AdvancedPawn(Pawn).AimedPitch - GetViewRotation().Pitch) > 300){
          if ( abs(GetViewRotation().Pitch) < 7000 ||
               abs(GetViewRotation().Pitch) > 58535){
            ServerSetPitch(GetViewRotation().Pitch);
          }
      }
   }

   if (Pawn!= none && Pawn.Weapon !=None && bCamAnimate)
   {
      //Get Locations
      HeadLoc = Pawn.Weapon.GetBoneCoords(HeadBoneName).Origin;
      CameraLoc = Pawn.Weapon.GetBoneCoords(CameraBoneName).Origin;
      //Get Rotations
      HeadRot = rotator(Pawn.Weapon.GetBoneCoords(HeadBoneName).XAxis);
      CameraRot = rotator(Pawn.Weapon.GetBoneCoords(CameraBoneName).XAxis);

//      Log("HeadRot: "  $ HeadRot $ " CamerRot " $ CameraRot);
      if (HeadLoc != vect(0,0,0) && CameraLoc != vect(0,0,0))
      {
         //CameraLocation = CameraLoc; //seems to be a relative offset based on orientations!
         //CamerLocation = HeadLoc; // leaving it at the head looks good!
         //CameraRotation += HeadRot - CameraRot;
         CameraRotation = rotator(Pawn.Weapon.GetBoneCoords(CameraBoneName).XAxis);
         CameraLocation = Pawn.Weapon.GetBoneCoords(CameraBoneName).Origin;
      }
   }

   if (!bCameraLock == true){
      UpdateFall(CameraLocation, CameraRotation, TickDelta);
      UpdateSway(CameraLocation, CameraRotation, TickDelta);
   } else {
      LastCameraRotation =  rot(0,0,0);
   }

//    LastCameraRotation = CameraRotation;

}

/*****************************************************************
 * DoSway
 *****************************************************************
 */
exec function DoSway(){
//      StartSway(SWAY_FORWARD);
//      StartSway(SWAY_SIDEWAYS);
      StartSway(SWAY_CIRCLE,4);
}


/****************************************************************
 * StartSway
 *****************************************************************
 */
function StartSway(E_SWAYTYPE ST, float Mag){
   //reset the counter
   SwayTheta = 0;
   //set the global sway type
   SwayType = ST;
   //set the global sway mag
   SwayMag = Mag;

}

/*****************************************************************
 * EndSway
 *****************************************************************
 */
function EndSway(){
    SwayType = SWAY_NONE;
    AdvancedPawn(Pawn).SwayBob = vect(0,0,0);
}

/*****************************************************************
 * UpdateSway
 *****************************************************************
 */
function UpdateSway(out vector CameraLocation, out rotator CameraRotation, float TickDelta){

    local vector TempSwayBob;

   if (Pawn == None){ return; }

   if (SwayType == SWAY_CIRCLE){

           //X/Y axis
        SwayDelta = swayMag * sin(SwayTheta);
        CameraRotation.pitch += SwayDelta * 100;

        SwayDelta = swayMag * cos(SwayTheta);
        CameraRotation.yaw += SwayDelta * 100;
        SwayTheta += TickDelta/SwayRate * 0.75;

/*
        //X/Y axis
        SwayDelta = swayMag * sin(SwayTheta);
        TempSwayBob = vector(CameraRotation + rot(0,16384,0)) * SwayDelta;
        //Z - axis
        SwayDelta = swayMag * cos(SwayTheta);
        TempSwayBob += vect(0,0,1) * SwayDelta;
        AdvancedPawn(Pawn).SwayBob = TempSwayBob;
        SwayTheta += TickDelta/SwayRate *2;
        */
    }
    else if (SwayType == SWAY_SIDEWAYS){
        //X/Y axis
        SwayDelta = swayMag * sin(SwayTheta);
        CameraRotation.pitch += 20 * SwayDelta * SwayDelta;
        LastCameraRotation.pitch =  20 * SwayDelta * SwayDelta;

        SwayDelta = swayMag * cos(SwayTheta);
        CameraRotation.yaw += SwayDelta * 60;
        LastCameraRotation.Yaw = SwayDelta * 60;

        /*
        TempSwayBob = vector(CameraRotation + rot(0,16384,0)) * SwayDelta * 2;
        //Z - axis
        TempSwayBob += -SwayDelta * SwayDelta * vect(0,0,1);
        AdvancedPawn(Pawn).SwayBob = TempSwayBob;
        */
        SwayTheta += TickDelta/SwayRate * 0.75;

    }
    else if (SwayType == SWAY_FORWARD){
        //X/Y axis
        SwayDelta = swayMag * sin(SwayTheta);
        TempSwayBob = vector(CameraRotation) * SwayDelta * 2;
        //Z - axis
        TempSwayBob += -SwayDelta * SwayDelta * vect(0,0,1);
        AdvancedPawn(Pawn).SwayBob = TempSwayBob;
        SwayTheta += TickDelta/SwayRate *2;
    } else {
        LastCameraRotation =  rot(0,0,0);
    }

}

/*****************************************************************
 * Fall
 *****************************************************************
 */
exec function Fall(){
    local float temp;

   if (bAllowedToFall == false){
      return;
   }

    FallState = 0;
    FallTheta = 0;
    FallDelay = 0;
    temp = Frand();
    FallDir = (temp * 3) - 1;
}

/*****************************************************************
 * UpdateFall
 * if you are falling then proceed to the next step
 *****************************************************************
 */
function UpdateFall(out vector CameraLocation, out rotator CameraRotation, float TickDelta){

   if (Pawn == None){ return; }

    //FALL
    if (FallState == 0){

        if (Pawn.BaseEyeHeight > 0){
         Pawn.BaseEyeHeight -= FallDelta * FallRate;
        }
        CameraRotation.Pitch += 150* FallRate * sin(FallTheta/3);
        CameraRotation.Roll += FallDir* 150 * FallRate * sin(FallTheta/2);
        FallTheta += TickDelta;

        if (FallTheta > 1 ){
            FallState = 1;
        }


    // HIT THE GROUND
    } else if (FallState == 1) {
        Pawn.Velocity.X = 0;
        Pawn.Velocity.Y = 0;
        if (FallDelay == 0){
            ShakeView(0,0,vect(3,3,10),0,vect(200,200,200),25);
        }
       if ( ShakeOffsetRate != vect(0,0,0) ){
           // modify shake offset
            ShakeOffset.X += TickDelta * ShakeOffsetRate.X;
            CheckShake(MaxShakeOffset.X, ShakeOffset.X, ShakeOffsetRate.X, ShakeOffsetTime.X);
            ShakeOffset.Y += TickDelta * ShakeOffsetRate.Y;
            CheckShake(MaxShakeOffset.Y, ShakeOffset.Y, ShakeOffsetRate.Y, ShakeOffsetTime.Y);
            ShakeOffset.Z += TickDelta * ShakeOffsetRate.Z;
            CheckShake(MaxShakeOffset.Z, ShakeOffset.Z, ShakeOffsetRate.Z, ShakeOffsetTime.Z);
        }
        FallDelay += TickDelta;
        CameraRotation.Pitch +=  150* FallRate * sin(FallTheta/4); // theta no longer increasing
        CameraRotation.Roll += FallDir * 150 * FallRate * sin(FallTheta/4);
        if ( FallDelay > 3){
            FallDelay = 0;
            FallState = 2;
        }

    //GET UP
    } else if (FallState == 2){

        if (Pawn.BaseEyeHeight < Pawn.default.BaseEyeHeight){
           Pawn.BaseEyeHeight += FallDelta * FallRate;
        }
        CameraRotation.Pitch += 150* FallRate * sin(FallTheta/3);
        CameraRotation.Roll += FallDir * 150 * FallRate * sin(FallTheta/2);
        FallTheta -= TickDelta;

        if (FallTheta <= 0 ){
            FallState = -1;
            Pawn.BaseEyeHeight = Pawn.default.BaseEyeHeight;
        }
    }
//    FallRotation = OldRot;
}


/****************************************************************
 * PlayerTick
 ****************************************************************
 */
function PlayerTick(float DeltaTime){

   TickDelta = DeltaTime; //stored in case some non-tick
                          //functions want to use this information
   if (bDoFade == true){
      //stop the player from moving
      if (Pawn != None){
         Pawn.velocity = vect(0,0,0);
      }

      //gradually adjust the scale from clear (1,1,1) to solid (0,0,0)
      FlashScale = LastFlashView -  vect(1,1,1) * (DeltaTime/FadeTime);
      LastFlashView = FlashScale;
      FlashFog = FadeColour;
   } else {
      Super.PlayerTick(DeltaTime);
   }

   if (Pawn!=None && Pawn.Weapon !=None){
    AdvancedWeapon(Pawn.Weapon).UpdateAccuracy(deltaTime);
   }
}

/****************************************************************
 * PawnDied
 * Overridden to ensure that the pawn doesn't stay in the mount
 ****************************************************************
 */
function PawnDied(Pawn P) {
   if (AdvancedPawn(Pawn).objMount != None){
      AdvancedPawn(Pawn).objMount.DoUnMount();
   }
   EndSway();
   Super.PawnDied(P);
}


/**
 * Can be called when something happens that ends the player's game, like
 * when they fail a critical objective... well in theory at least.
 *
 * For now, this is really just used by the Otis pawn when it's destroyed, in
 * case the spectating stuff broke.  Beware of console commands triggering this
 * code, the key-pressthat invokes the console command also goes to the menu
 * system...
 */
function GameOver() {
    bGameOver = true;
}

/**
 * Overridden in the dead state...
 */
function bool IsDead() {
    return bGameOver;
}

/****************************************************************
 * CheckForActionableActor
 ****************************************************************
 */
function CheckForActionableActor(){

   local Actor TempActionActor;
   local Actor BestActionActor;
   local int aPriority;

   if (Pawn != None){
      //get the weapon to update it's information the same time that
      //the controller does
      if (Pawn.Weapon !=None){
         AdvancedWeapon(Pawn.Weapon).UpdateTarget();
      }

      //check the weapon first for target info
      if (Pawn.Weapon !=None && AdvancedWeapon(Pawn.Weapon).TargetActorInfo.target != None){
         BestActionActor = AdvancedWeapon(Pawn.Weapon).TargetActorInfo.target;
          //log("Weapon: " $ BestActionActor);


      } else {
         //For each colliding actor
         foreach Pawn.RadiusActors(class'Actor',TempActionActor,ActionRadius){

           if (Vsize(Pawn.Location - TempActionActor.Location) > TempActionActor.iActionableRadius){
               continue;
            }

            //find the actor with the highest priority actionable interface
            aPriority = TempActionActor.GetActionablePriority(self);
            if (aPriority > 0){
               if (BestActionActor == None ||
                   (aPriority > BestActionActor.GetActionablePriority(self)) || //greater priority or
                   (aPriority == BestActionActor.GetActionablePriority(self) &&  //same priority and ...
                    (VSize(Pawn.Location - BestActionActor.location) >
                     Vsize(Pawn.Location - TempActionActor.location))) //closer
                   )
               {
                     //not through walls
                      if (FastTrace(Pawn.Location + Pawn.EyePosition(), TempActionActor.Location) ||
                          FastTrace(Pawn.Location, TempActionActor.Location)){
                          BestActionActor = TempActionActor;
                      }
               }
            }
         }
      }
   }

   //Set it or reset it
   if (BestActionActor !=None){
      BestActionMessage = BestActionActor.GetActionableMessage(self);
   } else {
      BestActionMessage = "";
   }
   objActionableActor = BestActionActor;

}

/****************************************************************
 * ToggleWeaponZoom
 * So that this can be bound independently from alt-fire
 ****************************************************************
 */
exec function ToggleWeaponZoom() {
    local AdvancedWeapon weap;

                // Log( self @ "ToggleWeaponZoom"  )    ;
    weap = AdvancedWeapon( Pawn.Weapon );
    if ( weap == None ) Warn( pawn.weapon @ "cannot zoom" );
    weap.ToggleAimedMode();
}

/****************************************************************
 * StartZoomEx
 * Smoothly zooms to ZoomFOV.
 *
 * @param ZoomFOV  Angle of the FOV to zoom to, assumed to be smaller
 *                 than current FOV
 * @param time     How quickly to change FOVs, in seconds
 ****************************************************************
 */
function StartZoomEx( float ZoomFOV, optional float time ) {
    if ( time <= 0 ) time = DEFAULT_ZOOM_TIME;
                // Log( self @ "starting zoom from" @ FOVAngle @ DefaultFOV  @ "to" @ ZoomFOV @ "with time" @ time  )    ;

    self.ZoomFOV = ZoomFOV;
    bZooming     = true;
    bUnZooming   = false;
    // handle the possibility that the current FOV may already be
    // partway between the desired and the expected-initial angles.
    ZoomLevel    = FClamp( (DefaultFOV - FOVAngle)/(DefaultFOV - ZoomFOV),
                           0.0, 1.0 );
    TimeToZoom   = time;

}


/****************************************************************
 * StartUnZoom
 * Restores DefaultFOV
 *
 * @param time     How quickly to change FOVs, in seconds
 ****************************************************************
 */
function StartUnZoom( optional float time ) {
                // Log( self @ "START UN-ZOOM"  )    ;
    if ( time <= 0 ) time = DEFAULT_ZOOM_TIME;

    bZooming     = false;
    bUnZooming   = true;
    ZoomLevel    = 1.0;
    ZoomFOV      = FOVAngle;
    TimeToUnZoom = time;
}



/****************************************************************
 * AdjustView
 * Overridden for fancier zoom functionality
 ****************************************************************
 */
function AdjustView(float DeltaTime ) {
    // from base class, smoothly adjust actual FOVAngle towards
    // DesiredFOV.
    if ( FOVAngle != DesiredFOV ) {
        if ( FOVAngle > DesiredFOV ) {
            FOVAngle = FOVAngle - FMax( 7, 0.9 * DeltaTime
                                            * (FOVAngle - DesiredFOV) );
        }
        else {
            FOVAngle = FOVAngle - FMin( -7, 0.9 * DeltaTime
                                            * (FOVAngle-DesiredFOV) );
        }
        if ( Abs(FOVAngle - DesiredFOV) <= 10 ) {
            FOVAngle = DesiredFOV;
        }
    }

    // fancy zoom stuff.  Uses ZoomLevel as the current pct of full zoom.
    if ( bZooming && FOVAngle != ZoomFOV ) {
        ZoomLevel  = FMin( 1.0, ZoomLevel + DeltaTime / TimeToZoom );
        DesiredFOV = DefaultFOV - ZoomLevel * (DefaultFOV - ZoomFOV);
    }
    else if ( bUnZooming && FOVAngle != DefaultFOV ) {
        ZoomLevel  = FMax( 0.0, ZoomLevel - DeltaTime / TimeToUnZoom );
        DesiredFOV = DefaultFOV - ZoomLevel * (DefaultFOV - ZoomFOV);
    }
}



simulated function UpdateActionKey(){
    local string KeyName, Alias;
    local int i;
   //the actionable message
    for (i=0;i<255;i++)
    {
        KeyName = ConsoleCommand("KEYNAME"@i);
        if (KeyName!=""){
            Alias = ConsoleCommand("KEYBINDING"@KeyName);
            if (Alias =="Action"){
                ActionKey =   "'" $ KeyName $ "'";
           }
        }
    }

}

/****************************************************************
 * DrawToHud
 *****************************************************************
 */
function DrawToHud(Canvas c, float scaleX, float scaleY) {
    local AdvancedPawn ap;
    local int i;


   if (bClearScreen==true){
      c.SetPos(0,0);
      c.DrawTileScaled(Material'Engine.ConsoleBK', 100, 100);
      return;
   }


    // delegate to the pawn...
    if ( Pawn != None && !bDisablePawnHud ) {
        ap = AdvancedPawn( pawn );
        if ( ap != None ) ap.drawToHud( c, scaleX, scaleY );
        if (!bDisableHealth){
            myLifeBar.drawQuantity( pawn.health, c, scaleX, scaleY );
        }
    }

    ReplaceText(BestActionMessage, "Action", ActionKey);

    c.SetDrawColor( 255,255,255, 0 );

   C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
    C.bCenter = true;
    c.SetPos( scaleX, 375 * scaleY );
    C.DrawText(BestActionMessage);

    //Multiplayer Death message
    if (MPMessage != ""){
       //C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
         //    GetSubtitleFontRef();
       c.SetPos( scaleX, 800 * scaleY );
       C.DrawText(MPMessage);
    }
    C.bCenter = false;

    C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
          GetTinyFontRef();

    if (Level.NetMode != NM_StandAlone){
       for(i=0;i<SayMessages.length;i++){
          c.SetPos( 10, (450 * ScaleY) + (30* ScaleY * i) );
          if ((Level.TimeSeconds - SayMessages[i].secs) > 7){
            SayMessages.Remove(i,1);
            continue;
          }
          C.DrawText(Left(SayMessages[i].Message, InStr(SayMessages[i].Message,":") + 47));
       }
    }

}


/****************************************************************
 * DrawDebugToHUD
 ****************************************************************
 */
function drawDebugToHUD(Canvas c, float scaleX, float scaleY){
    if ( Pawn.Weapon != None ) {
        //the inaccuracy of your weapon do to movement
        c.SetPos( 750 * scaleX, 33 * scaleY );
        //c.Font = C.SmallFont;
      C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSmallFontRef();
        c.DrawText("Inaccuracy:" $ Pawn.Weapon.TraceAccuracy);
    }
}

/****************************************************************
 * NextSkill
 * Used to adjust the firing mode of a weapon
 *****************************************************************
 */
exec function NextSkill()
{
   local AdvancedWeapon objCurrentWeapon;
   objCurrentWeapon = AdvancedWeapon(Pawn.Weapon);
   if (objCurrentWeapon!=None){
      objCurrentWeapon.ToggleMode();
   }
}

/****************************************************************
 * PrevSkill
 * Used to adjust the firing mode of a weapon
 *****************************************************************
 */
exec function PrevSkill()
{
   local AdvancedWeapon objCurrentWeapon;
   objCurrentWeapon = AdvancedWeapon(Pawn.Weapon);
   if (objCurrentWeapon!=None){
      objCurrentWeapon.ToggleMode();
   }
}

/****************************************************************
 * Action
 * Whoa! Something happened! User is trying to do something
 ****************************************************************
 */
exec function Action(){
    if (AdvCheatManager != None){
        AdvCheatManager.ProcessInput(3);
    }
    if (objActionableActor != None){
        objActionableActor.DoActionableAction(self);
    }
}


/*****************************************************************
 * ForceReload
 *****************************************************************
 */
exec function ForceReload(){
   super.ForceReload();
   if (AdvCheatManager != None){
    AdvCheatManager.ProcessInput(4);
   }
}

/****************************************************************
 * DoMount
 * The function that makes the player mounted, provided that the
 * player has a mountable weapon
 ****************************************************************
 */
function DoMount(MountPoint theMount)
{
    local AdvancedPawn ap;
    ap = AdvancedPawn( pawn );
    if ( ap != None ) ap.mount();
    ap.objMount = theMount;
    GotoState('PlayerMounted');
}

/****************************************************************
 * DoUnMount
 * The function that makes the player UN-mounted
 ****************************************************************
 */
function DoUnMount()
{
    local AdvancedPawn ap;
    ap = AdvancedPawn( pawn );
    if ( ap != None ) ap.unmount();
    GotoState('PlayerWalking');
    ap.objMount = None;
}


/****************************************************************
 * EnableWeatherEffect
 ****************************************************************
 */
function EnableWeatherEffect( Actor focus ) {
    local class<Emitter> effectClass;

                if ( !(theWeatherEffect == None ) ) {            Log( "(" $ self $ ") assertion violated: (theWeatherEffect == None )", 'DEBUG' );           assert( theWeatherEffect == None  );        }//    ;
    effectClass = getWeatherEffectClass();
    if ( effectClass != None ) {
        theWeatherEffect = focus.Spawn( effectClass, focus );
        if ( theWeatherEffect != None ) {
            theWeatherEffect.setBase( focus );
        }
    }
}


/****************************************************************
 * DisableWeatherEffect
 ****************************************************************
 */
function DisableWeatherEffect() {
    if ( theWeatherEffect != None ) {
        theWeatherEffect.destroy();
    }
    theWeatherEffect = None;
}


/****************************************************************
 * GetWeatherEffectClass
 ****************************************************************
 */
function class<Emitter> GetWeatherEffectClass() {
    local WeatherEffect w;

    foreach AllActors( class'WeatherEffect', w ) {
        return w.GetWeatherEffectClass();
    }
}


/****************************************************************
 * ToggleInventoryDisplay
 ****************************************************************
 */
exec function ToggleInventoryDisplay() {
    local AdvancedPawn ap;
    ap = AdvancedPawn( Pawn );
    if ( ap != None ) {
        ap.bShowInventory = !ap.bShowInventory;
    }
}



//===========================================================================
// State PlayerWalking
//===========================================================================
state PlayerWalking
{


   /*************************************************************
    *  PlayerMove - Overridden to provide a method of locking the
    *               player when in beachhead mode
    *************************************************************
    */
   function PlayerMove(optional float deltaTime){

      //while moving increase the inaccuracy
      if (abs(Pawn.velocity.X) > 0) {
         if (iInaccuracy < iMaxInaccuracy){
            iInaccuracy = iInaccuracy + (iInaccuracyDelta * deltaTime);
         }

      //Z maxes it out
      } else if (abs(Pawn.velocity.Z)>0){
         iInaccuracy = iMaxInaccuracy;

      //Rotating Maxes it out
      }else if (DesiredRotation != Rotation){
            if (iInaccuracy < iMaxInaccuracy){
               iInaccuracy = iInaccuracy + (iInaccuracyRotDelta * deltaTime);
         }

      //decreases otherwise
      } else {
         if (iInaccuracy > 0){
            iInaccuracy = iInaccuracy  - (iInaccuracyDecline * deltaTime);
            if (iInaccuracy < 0) iInaccuracy = 0; //just in case;
         }
      }

      //protect the roof
      //      iInaccuracy = Min (iInaccuracy, iMaxInaccuracy);

      if (Pawn!= None && Pawn.Weapon != None){
         AdvancedWeapon(Pawn.Weapon).AffectAccuracy(iInaccuracy);
         if (Pawn.bIsCrouched){
            AdvancedWeapon(Pawn.Weapon).ModifyShake(iCrouchAccuracyMod);
         } else {
            AdvancedWeapon(Pawn.Weapon).ModifyShake(1);
         }
      }
      Super.PlayerMove(deltaTime);
   }
}


//===========================================================================
// State PlayerMounted
//===========================================================================
state PlayerMounted{
  ignores SwitchToBestWeapon, ClientSetWeapon, SwitchWeapon, NextWeapon, PrevWeapon,
          NextGun, PrevGun, NextMelee, PrevMelee, NextGrenade, PrevGrenade;

   /*************************************************************
    *  PlayerMove - Overridden to provide a method of locking the
    *               player when in beachhead mode
    *************************************************************
    */
   function PlayerMove(optional float deltaTime){

      local Rotator OldRotation, ViewRotation;
      local Rotator MountRotation;
      local int PosYawLimit, NegYawLimit, RelYawRange;
      local int PosPitchLimit, NegPitchLimit, RelPitchRange;
      local int YawDiff, PitchDiff;
      local AdvancedPawn ap;

      local int PawnFeetLocation;
      local int EyeHeightDifference;

      //Process rotations only (i.e. Ignore Moves)
      ap = AdvancedPawn(Pawn);
      ViewRotation = Rotation;
      MountRotation = ap.objMount.Rotation;

      //Normal rotation management
      if ( !bKeyboardLook && (bLook == 0) && bCenterView ){
         ViewRotation.Pitch = ViewRotation.Pitch & 65535;
         if (ViewRotation.Pitch > 32768)
            ViewRotation.Pitch -= 65536;
         ViewRotation.Pitch=ViewRotation.Pitch*(1-12*FMin(0.0833,deltaTime));
         if ( Abs(ViewRotation.Pitch) < 200 )
            ViewRotation.Pitch = 0;
      }


      //clamping cause a rounding error that causes drift on the mount
      //Restricted FieldOfFire management
      //ViewRotation = Class'Utils'.static.clampProper(ViewRotation);
      //MountRotation = Class'Utils'.static.clampProper(ap.objMount.Rotation);


      //The complete range of freedom from the Mounts orientation
      RelYawRange   = (ap.objMount.YawRange*DgrToUnr)/2;
      RelPitchRange = (ap.objMount.PitchRange*DgrToUnr)/2;

      //absolute boundaries for yaw
      PosYawLimit = MountRotation.Yaw + RelYawRange;
      PosYawLimit =  Class'Utils'.static.clampProperComponent(PosYawLimit);
      NegYawLimit = MountRotation.Yaw - RelYawRange;
      NegYawLimit = Class'Utils'.static.clampProperComponent(NegYawLimit);

      //absolute boundaries for pitch
      PosPitchLimit = MountRotation.Pitch + RelPitchRange;
      PosPitchLimit = Class'Utils'.static.clampProperComponent(PosPitchLimit);
      NegPitchLimit = MountRotation.Pitch - RelPitchRange;
      NegPitchLimit = Class'Utils'.static.clampProperComponent(NegPitchLimit);

      //The difference between the View and the mount
      YawDiff = ViewRotation.Yaw - MountRotation.Yaw;
      YawDiff = Class'Utils'.static.clampProperComponent(YawDiff);
      PitchDiff = ViewRotation.Pitch - MountRotation.Pitch;
      PitchDiff = Class'Utils'.static.clampProperComponent(PitchDiff);



      //If the view exceeds the yaw range then reset it to absolute markers
      if (YawDiff > RelYawRange){
         ViewRotation.Yaw = PosYawLimit;
     } else if (YawDiff < -RelYawRange){
         ViewRotation.Yaw = NegYawLimit;
      }

      if (PitchDiff > RelPitchRange){
         ViewRotation.Pitch = PosPitchLimit;
      } else if (PitchDiff < -RelPitchRange){
         ViewRotation.Pitch = NegPitchLimit;
      }

      // Update rotation.
      SetRotation(ViewRotation);
      Pawn.SetRotation(ViewRotation);
      OldRotation = Rotation;

       //bottom of the pawn
      PawnFeetLocation = Pawn.Location.Z - (Pawn.CollisionHeight / 2);
      EyeHeightDifference = ap.location.z - PawnFeetLocation;

      //set the eye height relative to the player's feet
      Pawn.BaseEyeHeight = EyeHeightDifference;
      UpdateRotation(DeltaTime, 1);

      //update the accuracy
      if (Pawn!= None && Pawn.Weapon != None){
         if (iInaccuracy > 0){
            iInaccuracy = iInaccuracy  - (iInaccuracyDelta * deltaTime);
         }
         if (iInaccuracy < 0) iInaccuracy = 0; //just in case;
         if (iInaccuracy > iMaxInaccuracy) iInaccuracy = iMaxInaccuracy; //just in case;

         AdvancedWeapon(Pawn.Weapon).AffectAccuracy(iInaccuracy);
      }
   }
}



//===========================================================================
// State Dead
//===========================================================================
state Dead
{
   ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon, NextWeapon, PrevWeapon;
    function BeginState()
    {
        if ( (Pawn != None) && (Pawn.Controller == self) ){
            Pawn.Controller = None;
        }
        EndSway();
        EndZoom();
        FOVAngle = DesiredFOV;
        Pawn = None;
        Enemy = None;
        bBehindView = true;
        bFrozen = true;
        bJumpStatus = false;
        bPressedJump = false;
        bBlockCloseCamera = true;
        bValidBehindCamera = false;
        FindGoodView();
        SetTimer(1.0, false);
        StopForceFeedback();
        ClientPlayForceFeedback("Damage");  // jdf
        CleanOutSavedMoves();
    }


}




//==========================================================================
//==========================================================================
//==========================================================================
//==========================================================================


// The player w === REMOVE THIS LET THE PARENT DO IT< ADDED FOR TESTING
exec function SwitchWeapon (byte F )
{
    local weapon newWeapon;

    if ( (Level.Pauser!=None) || (Pawn == None) || (Pawn.Inventory == None) )
        return;
    if ( (Pawn.Weapon != None) && (Pawn.Weapon.Inventory != None) ){
        newWeapon = Pawn.Weapon.Inventory.WeaponChange(F, false);
            }
    else
        newWeapon = None;
    if ( newWeapon == None ){
        newWeapon = Pawn.Inventory.WeaponChange(F, true);
        }

    if ( newWeapon == None ){
        return;
        }

    if ( Pawn.Weapon == None )
    {
        Pawn.PendingWeapon = newWeapon;
        Pawn.ChangedWeapon();
    }
    else if ( Pawn.Weapon != newWeapon || Pawn.PendingWeapon != None )
    {
        Pawn.PendingWeapon = newWeapon;
        if ( !Pawn.Weapon.PutDown() )
            Pawn.PendingWeapon = None;
    }
}

//==========================================================================
//==========================================================================
//==========================================================================
//==========================================================================





//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bAllowedToFall=True
     AdvancedCheatClass=Class'AdvancedEngine.AdvancedCheatManager'
     SwayRate=4.000000
     SwayMag=2.000000
     FallState=-1
     FallDelta=0.010000
     FallRate=100.000000
     ActionRadius=128
     iInaccuracyDelta=0.500000
     iInaccuracyRotDelta=0.500000
     iInaccuracyDecline=2.000000
     iCrouchAccuracyMod=0.500000
     FadeTime=2.000000
     LoadingMessageTxt="Loading..."
     ActionKey="''"
     bShortConnectTimeOut=False
     bNetNotify=True
     DebugFlags=1
}
