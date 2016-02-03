// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ClassName -
 *
 * @version $Revision: #2 $
 * @author  name (email@digitalextremes.com)
 * @date    Month 2003
 */
class AdvancedGameInfo extends GameInfo
implements( HudDrawable );



var bool bUseSubtitles;
var int iDifficultyLevel;
var AdvancedSubtitleMgr TheSubtitles;
var int iNextTick;
var Pawn LastInstigator;
var Actor LastSender;
var name LastEventName;


var localized string SpectatingMsg;

var int iEnemyDiffLevel;

//game settings
var config bool bUseReticule;
var bool bFriendlyFire;


// save slots
var config string SlotName0;
var config string Date0;
var config string SlotName1;
var config string Date1;
var config string SlotName2;
var config string Date2;
var config string SlotName3;
var config string Date3;
var config string SlotName4;
var config string Date4;
var config string SlotName5;
var config string Date5;
var config string SlotName6;
var config string Date6;
var config string SlotName7;
var config string Date7;
//auto save
var const int AUTO_SLOT;
var config string SlotName8;
var config string Date8;
var() config bool bAutoSaveDisabled;
//quick save
var const int QUICK_SLOT;
var config string SlotName9;
var config string Date9;
// other save system properties...
var bool bDisableSave;
var float SaveTimeStamp;
var bool bSaveInProgress;

var localized string SaveDisabledTxt;
var Localized String QuickSaveTxt;
var Localized String SaveTxt;
var localized String AutoSaveTxt;

var localized String QuickSaveName;
var localized String AutoSaveName;

enum E_SHADOWTYPE{
   SHADOW_NONE,
   SHADOW_PROJ,
   SHADOW_BLOB,
   SHADOW_FAKE,
};

var array<string> PreloadObjects;
var array<staticmesh> PreloadMesh;
var array<MeshAnimation> PreloadAnimation;
var array<Material> PreloadMaterial;

var config E_SHADOWTYPE iUseShadows;
const POST_SAVE_TIMER = 293484;
var string DefaultInventory;

var config class<PlayerController> OverridePlayerControllerClass;

/*****************************************************************
 * InitGame
 *****************************************************************
 */
event InitGame(String options, out String error){

   local string InOpt;
   local int savegame;
   local int slot;

   if (OverridePlayerControllerClass != none){
      PlayerControllerClass = OverridePlayerControllerClass;
   }

   Preload();

   //FriendlyFire
    InOpt = ParseOption( Options, "FriendlyFire");
    if( InOpt != "" ){ bFriendlyFire = bool(InOpt); }

   //EnemyStrength
   InOpt = ParseOption ( Options, "EnemyStrength" );
   if ( InOpt != "" ){ iEnemyDiffLevel = int(InOpt); }


   //TheSaveManager = new (self) class'SaveGames';

   // CARROT: Get he list of save games
   //class'UtilsXbox'.static.Refresh_Save_Games();
   slot = 0;

   // Clear the slots
   for (savegame = 0; savegame <= 9; ++savegame) {
        SetSlotName(savegame, "");
   }

   // Set the slots
   /*for (savegame = 0; savegame < class'UtilsXbox'.static.Count_Save_Games(); ++savegame) {
        savegametitle = class'UtilsXbox'.static.Get_Save_Game_Title(savegame);

        if (InStr(savegametitle, AutoSaveName) != -1) {
            SetSlotName(AUTO_SLOT, savegametitle);
        } else if (InStr(savegametitle, QuickSaveName) != -1) {
            SetSlotName(QUICK_SLOT, savegametitle);
        } else if (slot <= 7) {
            SetSlotName(slot, savegametitle);
            ++slot;
        }
   }*/

   Super.InitGame(options, error);
}


/*****************************************************************
 * PreLoad
 *****************************************************************
 */
function PreLoad(){
   local int i;
  // local class temp;

   //Preload stuff that the dumb and unattractive LD's have specified
   for(i=0;i<GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh.length;i++){
      DynamicLoadObject(string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh[i]),class'Mesh');
      log("Preloading: " $ string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh[i]));
   }
   for(i=0;i<GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation.length;i++){
      DynamicLoadObject(string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation[i]),class'MeshAnimation');
      log("Preloading: " $ string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation[i]));
   }
   for(i=0;i<GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial.length;i++){
      DynamicLoadObject(string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial[i]),class'Material');
      log("Preloading: " $ string(GameSpecificLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial[i]));
   }

   //Preload stuff that the smart and attractive programmers have specified.
   for(i=0;i<PreloadObjects.length;i++){
      DynamicLoadObject(PreloadObjects[i],class'class');
   }
   for(i=0;i<PreloadMesh.length;i++){
      DynamicLoadObject(string(PreloadMesh[i]),class'StaticMesh');
      log("Preloading: " $ string(PreloadMesh[i]));
   }
   for(i=0;i<PreloadAnimation.length;i++){
      DynamicLoadObject(string(PreloadAnimation[i]),class'MeshAnimation');
      log("Preloading: " $ string(PreloadAnimation[i]));
   }
   for(i=0;i<PreloadMaterial.length;i++){
      DynamicLoadObject(string(PreloadMaterial[i]),class'Material');
      log("Preloading: " $ string(PreloadMaterial[i]));
   }

}

/*****************************************************************
 * QueueEvent
 * This function is a total last minute hack. It only works if it is
 * only used by one type of event and that event is the onkilled in the pawn
 *. If you want to use it else where you will need to change this function.
 *****************************************************************
*/
function QueueEvent(name EventName, Actor Sender, Pawn Instigator){
   LastInstigator = Instigator;
   LastSender = Sender;
   LastEventName = EventName;
   iNextTick++;
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
*/
function PostBeginPlay(){
   super.BeginPlay();

}

/*****************************************************************
 * PostLoad
 * restart music
 *****************************************************************
 */
function PostLoad(){
   super.PostLoad();
   if (Level.Song != ""){
    //  Log(Level.Song);
      PlayMusic(Level.Song,0);
   }
}

/**
 * Draw yourself to the canvas.  scale is relative to a 1280x1024
 * canvas.  This function is called every frame, so be quick about
 * it.
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ){

}

/**
 * Analogous to drawHUD, but used for debugging info (e.g. for LDs)
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ){

}

/*****************************************************************
 * PostLogin
 * register the game with the hud
 *****************************************************************
 */
function PostLogin(PlayerController NewPlayer){
   super.PostLogin(NewPlayer);
   AdvancedHud(NewPlayer.myHUD).register( self );

}

/*****************************************************************
 * Login
 *****************************************************************
 */
event PlayerController Login(   string Portal,  string Options,out string Error){

   local int iHead, iBody;
   local string InOpt;
   local PlayerController NewPlayer;

   //Log("At Capacity: " $ NumPlayers > MaxPlayers);

   if (NumPlayers + 1 > MaxPlayers){ return none; }
   NewPlayer = super.Login(Portal,Options,Error);

   //Customization (HEAD)
    InOpt = ParseOption( Options, "Head");
    if( InOpt != "" ){ iHead = int(InOpt); }

   //Customization (BODY)
    InOpt = ParseOption( Options, "Body");
    if( InOpt != "" ){ iBody = int(InOpt); }

   AdvancedPlayerController(NewPlayer).iHeadTexture= iHead;
   AdvancedPlayerController(NewPlayer).iBodyTexture= iBody;

   return NewPlayer;
}

/*****************************************************************
 * MakeDate
 *****************************************************************
 */
function string MakeDate()
{
   local string timeString;
   local string formatter;

   //add the date
   timeString = string(Level.Day) $ "/" $
        string(Level.Month) $ "/" $
        string(Level.Year) $ " - ";

   //add the hour
   formatter = string(Level.Hour);
   if (len(formatter) < 2){
      formatter = "0" $ formatter;
   }
   timeString = timeString $ formatter;

   //add the minute
   formatter = string(Level.Minute);
   if (len(formatter) < 2){
      formatter = "0" $ formatter;
   }
   timeString = timeString $ ":" $ formatter;

   //add the minute
   formatter = string(Level.Second);
   if (len(formatter) < 2){
      formatter = "0" $ formatter;
   }
   timeString = timeString $ ":" $ formatter;

   return timeString;
}



/*****************************************************************
 * SetSlotName
 *****************************************************************
 */
private function SetSlotName(int SlotNumber, string SlotName){
   switch SlotNumber{
      case 0:
         class'AdvancedGameInfo'.default.SlotName0 = SlotName;
         class'AdvancedGameInfo'.default.Date0 = MakeDate();
         break;
      case 1:
         class'AdvancedGameInfo'.default.SlotName1 = SlotName;
         class'AdvancedGameInfo'.default.Date1 = MakeDate();
         break;
      case 2:
         class'AdvancedGameInfo'.default.SlotName2 = SlotName;
         class'AdvancedGameInfo'.default.Date2 = MakeDate();
         break;
      case 3:
         class'AdvancedGameInfo'.default.SlotName3 = SlotName;
         class'AdvancedGameInfo'.default.Date3 = MakeDate();
         break;
      case 4:
         class'AdvancedGameInfo'.default.SlotName4 = SlotName;
         class'AdvancedGameInfo'.default.Date4 = MakeDate();
         break;
      case 5:
         class'AdvancedGameInfo'.default.SlotName5 = SlotName;
         class'AdvancedGameInfo'.default.Date5 = MakeDate();
         break;
      case 6:
         class'AdvancedGameInfo'.default.SlotName6 = SlotName;
         class'AdvancedGameInfo'.default.Date6 = MakeDate();
         break;
      case 7:
         class'AdvancedGameInfo'.default.SlotName7 = SlotName;
         class'AdvancedGameInfo'.default.Date7 = MakeDate();
         break;
     case 8:
         class'AdvancedGameInfo'.default.SlotName8 = SlotName;
         class'AdvancedGameInfo'.default.Date8 = MakeDate();
         break;
     case 9:
         class'AdvancedGameInfo'.default.SlotName9 = SlotName;
         class'AdvancedGameInfo'.default.Date9 = MakeDate();
         break;
   }
}


/*****************************************************************
 * GetSlotDate
 *****************************************************************
 */
static function string GetSlotDate(int SlotNumber){
     switch SlotNumber{
      case 0:
         return class'AdvancedGameInfo'.default.Date0;
      case 1:
         return class'AdvancedGameInfo'.default.Date1;
      case 2:
         return class'AdvancedGameInfo'.default.Date2;
      case 3:
         return class'AdvancedGameInfo'.default.Date3;
      case 4:
         return class'AdvancedGameInfo'.default.Date4;
      case 5:
         return class'AdvancedGameInfo'.default.Date5;
      case 6:
         return class'AdvancedGameInfo'.default.Date6;
      case 7:
         return class'AdvancedGameInfo'.default.Date7;
      case 8:
         return class'AdvancedGameInfo'.default.Date8;
      case 9:
         return class'AdvancedGameInfo'.default.Date9;
   }
}

/*****************************************************************
 * IsCurrentProfile
 *****************************************************************
 */
function bool IsCurrentProfile(string ProfileName){
   local string CurrentProfileName;
   CurrentProfileName = GetCurrentProfileName();
   if (CurrentProfileName != Mid(ProfileName,0,Len(CurrentProfileName))){
      return false;
   }
   return true;
}

/*****************************************************************
 * GetSlotName
 *****************************************************************
 */
static function string GetSlotName(int SlotNumber){
      switch SlotNumber{
      case 0:
         return class'AdvancedGameInfo'.default.SlotName0;
      case 1:
         return class'AdvancedGameInfo'.default.SlotName1;
      case 2:
         return class'AdvancedGameInfo'.default.SlotName2;
      case 3:
         return class'AdvancedGameInfo'.default.SlotName3;
      case 4:
         return class'AdvancedGameInfo'.default.SlotName4;
      case 5:
         return class'AdvancedGameInfo'.default.SlotName5;
      case 6:
         return class'AdvancedGameInfo'.default.SlotName6;
      case 7:
         return class'AdvancedGameInfo'.default.SlotName7;
      case 8:
         return class'AdvancedGameInfo'.default.SlotName8;
      case 9:
         return class'AdvancedGameInfo'.default.SlotName9;
   }
}

static function string GetSlotNameEncoded(int SlotNumber){
    local string s;
    local string r;
    local string c;
    local int i;

    s = GetSlotName(SlotNumber);

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

/*****************************************************************
 * SaveSlot
 * All saving should go through this function!
 *****************************************************************
 */
function SaveSlot(int SlotNumber, optional string SlotName, optional String Msg){
    local PlayerController pc;
    local string message;
    local string savename;
    local string oldsavename;
    local Actor a;
    local SaveHandler current;
    local int savegame;

    if (!class'UtilsXbox'.static.Get_Save_Enable())
        return;

    // no-op while saving!
    if ( bSaveInProgress ) return;

    // status msg
    pc = Level.GetLocalPlayerController();
    if ( bDisableSave ) Message = SaveDisabledTxt;
    else if (Msg != "") message = Msg;
    else message = SaveTxt;

    // no save for you, just message.
    if ( bDisableSave ) return;

    // prep actors for saving...
    bSaveInProgress = true;
    ForEach AllActors( class'Actor', a ) {
        current = SaveHandler( a );
        if ( current != none ) {
            current.PreSave();
        }
    }

    oldsavename = GetSlotName(SlotNumber);
    savename = MakeSaveName(SlotNumber);

    // CARROT: Remove any other slots that contain this game
    for (savegame = 0; savegame <= 9; ++savegame) {
        if (GetSlotName(savegame) == savename)
            SetSlotName(savegame, "");
    }

    //save the actual game
    if (SlotName == ""){
      SetSlotName(SlotNumber, savename);
    } else {
      SetSlotName(SlotNumber, SlotName);
    }

    //NOTE: SaveGame doesn't actually happen until the end of the tick!
    //ConsoleCommand("SaveGame " $ string(SlotNumber));
    ConsoleCommand("SaveGameNamed \"" $ savename $ "\" \"" $ oldsavename $ "\"" );
    class'AdvancedGameInfo'.static.StaticSaveConfig();

    // A hack-o-licious way of saying "next-tick"...
    SaveTimeStamp = Level.TimeSeconds;
                // Log( self @ "SAVED TIME AT" @ SaveTimeStamp  )    ;
}

/*****************************************************************
 * SaveNamed
 * The slot just denotes qucksave, autosave or normal save
 *****************************************************************
 */
function SaveOverGame(string replace_name, string owner, int SlotNumber) {
    local PlayerController pc;
    local string message;
    local string savename;
    local string filename;
    local Actor a;
    local SaveHandler current;

    if (!class'UtilsXbox'.static.Get_Save_Enable())
        return;

    Log("Saving game to profile " $ owner);

    // no-op while saving!
    if ( bSaveInProgress ) return;

    // status msg
    pc = Level.GetLocalPlayerController();
    if ( bDisableSave ) Message = SaveDisabledTxt;
    else message = SaveTxt;

    // Message might be autosave or quicksave
    if (SlotNumber == QUICK_SLOT)        message = QuickSaveTxt;
    else if (SlotNumber == AUTO_SLOT)    message = AutoSaveTxt;

    AdvancedHud(pc.myHud).Message(pc.PlayerReplicationInfo,message,'INFO');


    AdvancedHud(pc.myHud).Message(pc.PlayerReplicationInfo,message,'INFO');

    // no save for you, just message.
    if ( bDisableSave ) return;

    // prep actors for saving...
    bSaveInProgress = true;
    ForEach AllActors( class'Actor', a ) {
        current = SaveHandler( a );
        if ( current != none ) {
            current.PreSave();
        }
    }

    savename = MakeSaveName(SlotNumber);
    filename = MakeSaveNameFile(SlotNumber);

    //NOTE: SaveGame doesn't actually happen until the end of the tick!
    //ConsoleCommand("SaveGame " $ string(SlotNumber));

    ConsoleCommand( "SaveGameNamed \"" $ filename $ "\" \"" $ savename $
                    "\" \"" $ replace_name $ "\" \"" $ owner $
                    "\" \"" $ string(SlotNumber == AUTO_SLOT) $
                    "\" \"" $ string(SlotNumber == QUICK_SLOT) $ "\"");
    class'AdvancedGameInfo'.static.StaticSaveConfig();

    // A hack-o-licious way of saying "next-tick"...
    SaveTimeStamp = Level.TimeSeconds;
                // Log( self @ "SAVED TIME AT" @ SaveTimeStamp  )    ;
}


/*****************************************************************
 * DeleteProfileSaveGames
 *****************************************************************
 */
function DeleteProfileSaveGames(){
   local int i;

   for(i=0;i<10; i++){
      if (IsCurrentProfile(GetSlotName(i)) == true){
         SetSlotName(i,"");
      }
   }
}

/**
 * Here's the rest of the "next-tick" stuff...
 */
function Tick( float dt ) {
    local Actor a;
    local SaveHandler current;

    if (iNextTick > 0){
      TriggerEvent(LastEventName, LastSender, LastInstigator);
      iNextTick--;
    }

    //            // Log( self @ "GOT TICKED AT" @ Level.TimeSeconds  )    ;
    // be sure that this really is the NEXT tick.  The 0.01s is to avoid badness
    // due to rounding errors.
    if ( bSaveInProgress == true
            && Level.TimeSeconds > SaveTimeStamp + dt + 0.01 ) {
        //log( "################" @ Level.TimeSeconds @ ">" @ SaveTimeStamp @ "+" @ dt );
        // give actors a chance to restore post-save
        foreach AllActors( class'Actor', a ) {
            current = SaveHandler( a );
            if ( current != none ) {
                current.PostSave();
            }
        }
        bSaveInProgress = false;
    }
}

/*****************************************************************
 * AutoSave
 * A convenient way to auto save.
 *****************************************************************
 */
function AutoSave() {
    /*if ( class'AdvancedGameInfo'.default.bAutoSaveDisabled || !class'UtilsXbox'.static.Get_Save_Enable())
        return;
    //SaveSlot( AUTO_SLOT,,AutoSaveTxt);*/

    // AUTO_SLOT makes the system calculate an autosave name.
    //Log("Autosaving");
    SaveOverGame("", GetCurrentProfileName(), AUTO_SLOT);
}

/*****************************************************************
 * MakeSaveName
 *****************************************************************
 */
function string MakeSaveName(int slot){
   local string SaveName;
   local int Min, Hour, Sec;
   local string HourString, MinString, SecString;
   local int PlayTime;

   SaveName = GetCurrentProfileName();
   PlayTime = AdvancedPawn(Level.GetLocalPlayerController().Pawn).CalcPlayTime();

//   Log(Level.TimeSeconds $ "   " $ PlayTime);

   Hour = PlayTime / 3600;
   Min = (PlayTime-(Hour*3600))/60;
   Sec = (PlayTime - (Hour*3600)) - (Min*60);

   HourString =string(Hour);
   MinString = string(Min);
   SecString = string(Sec);

   if (len(HourString)==1){ HourString = "0" $ HourString; }
   if (len(MinString)==1){ MinString = "0" $ MinString; }
   if (len(SecString)==1){ SecString = "0" $ SecString; }

   SaveName = SaveName $ " - " $ HourString $ ":" $ MinString $ ":" $ SecString;
   SaveName = SaveName $ " - " $ GameSpecificLevelInfo(Level.GameSpecificLevelInfo).LevelName;

   if (slot == QUICK_SLOT) {
        SaveName = SaveName $ " - " $ QuickSaveName;
   } else if (slot == AUTO_SLOT) {
        SaveName = SaveName $ " - " $ AutoSaveName;
   }

   return SaveName;
}

function string MakeSaveNameFile(int slot){
   local string SaveName;
   local int Min, Hour, Sec;
   local string HourString, MinString, SecString;
   local int PlayTime;

   SaveName = GetCurrentProfileName();
   PlayTime = AdvancedPawn(Level.GetLocalPlayerController().Pawn).CalcPlayTime();

   //Log(Level.TimeSeconds $ "   " $ PlayTime);

   Hour = PlayTime / 3600;
   Min = (PlayTime-(Hour*3600))/60;
   Sec = (PlayTime - (Hour*3600)) - (Min*60);

   HourString =string(Hour);
   MinString = string(Min);
   SecString = string(Sec);

   if (len(HourString)==1){ HourString = "0" $ HourString; }
   if (len(MinString)==1){ MinString = "0" $ MinString; }
   if (len(SecString)==1){ SecString = "0" $ SecString; }

   //add level name
   SaveName = GameSpecificLevelInfo(Level.GameSpecificLevelInfo).LevelName $ "-" $ SaveName ;
   //add play time
   SaveName = SaveName $ "-" $ HourString $ ":" $ MinString $ ":" $ SecString;

   if (slot == QUICK_SLOT) {
       //SaveName = QuickSaveName $ "-" $ GetCurrentProfileName();
       SaveName = SaveName $ "-" $ QuickSaveName;
   } else if (slot == AUTO_SLOT) {
        //SaveName = AutoSaveName $ "-" $ GetCurrentProfileName();
       SaveName = SaveName $ "-" $ AutoSaveName;
   }

   return SaveName;
}

/*****************************************************************
 * QuickSave
 * A convenient way to quick save.
 *****************************************************************
 */
function QuickSave() {
    /*if (!class'UtilsXbox'.static.Get_Save_Enable())
        return;
    SaveSlot( QUICK_SLOT ,, QuickSaveTxt); */
    SaveOverGame("", GetCurrentProfileName(), QUICK_SLOT);
}

/*****************************************************************
 * SetMountPointVisibility
 *****************************************************************
 */
function SetMountPointVisibility(bool makeVisible, optional MountPoint mp);


/*****************************************************************
 * GameOver
 * System gets notification from the game when it should be over
 *****************************************************************
 */
function GameOver(){
}


/*****************************************************************
 * GiveDefaultInventory
 *****************************************************************
 */
function GiveDefaultInventory(Pawn P){}

/*****************************************************************
 * RestartPlayer
 *****************************************************************
 */
function RestartPlayer( Controller c ) {
   super.RestartPlayer( c );
   GiveDefaultInventory(C.Pawn);
}

/*****************************************************************
 * ReduceDamage
 * Check for things like friendlyFire settings
 *****************************************************************
 */
function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy,
         vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
    // SV: fixed so that self-inflicted damage in team games (ie. grenades) still do damage on self
   if (bFriendlyFire == false &&
       injured != none && injured.Controller != none &&
       instigatedBy != none && instigatedby.Controller != none &&
       injured.Controller.SameTeamAs(instigatedBy.Controller) && (injured.Controller != instigatedBy.Controller)){
      Damage = 0;
   }
   return super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,DamageType);
}



function string GetCurrentProfileName(){
  return "Default Profile";
}


 //was the original set pause
function bool NoMenuPause( bool bPause, PlayerController P )
{
    if( bPauseable || (bAdminCanPause && (P.IsA('Admin') || P.PlayerReplicationInfo.bAdmin)) || Level.Netmode==NM_Standalone )  {
        if( bPause )
            Level.Pauser=P.PlayerReplicationInfo;
        else
            Level.Pauser=None;
        return True;
    }
    else return False;
}


//===========================================================================
// defaultProperties
//===========================================================================

defaultproperties
{
     iDifficultyLevel=1
     iEnemyDiffLevel=1
     bUseReticule=True
     bFriendlyFire=True
     Date0="11/6/2011 - 14:59:25"
     Date1="11/6/2011 - 14:59:25"
     Date2="11/6/2011 - 14:59:25"
     Date3="11/6/2011 - 14:59:25"
     Date4="11/6/2011 - 14:59:25"
     Date5="11/6/2011 - 14:59:25"
     Date6="11/6/2011 - 14:59:25"
     Date7="11/6/2011 - 14:59:25"
     AUTO_SLOT=8
     Date8="11/6/2011 - 14:59:25"
     QUICK_SLOT=9
     Date9="11/6/2011 - 14:59:25"
     SaveDisabledTxt="Cannot save here."
     QuickSaveTxt="Quick-saving..."
     SaveTxt="Saving..."
     AutoSaveTxt="Auto-saving..."
     QuickSaveName="Quicksave"
     AutoSaveName="Autosave"
     iUseShadows=SHADOW_PROJ
     OverridePlayerControllerClass=Class'DOTZEngine.DOTZPlayerController'
}
