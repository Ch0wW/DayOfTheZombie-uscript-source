// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZGameInfo - the single player game type for DOTZ
 *
 * @version $1.0$
 * @author  Jesse Lachapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class AdvancedMPGameBase extends AdvancedGameInfo;

//var config string PauseMenuMP;
var config string EndOfMatchMenuMP;

var bool bOverTime; //not used, but suspect it will be required
var bool IsPrivateGame;

var NavigationPoint LastPlayerStartSpot;    // last place player looking for start spot started from
var NavigationPoint LastStartSpot;          // last place any player started from

//bot management
var int InitialInPlayLimit;
var int MaxInPlayLimit;
var int MinInPlayLimit;
var float PerPlayerInPlayLimitModifier;

//audio
var array<Sound> RedTeamWins;
var array<Sound> BlueTeamWins;

var array<Sound> FiveMinuteWarning;
var array<Sound> OneMinuteWarning;
var array<Sound> YouWin;
var array<Sound> YouLose;



//===========================================================================
// Internal data
//===========================================================================

var int tickcount;
var int RemainingTime;
var int TimeLimit;
var int GoalScore;
var int GameRestartTime;

var int LastNumPlayers;

//consts
const TIMELIMIT_ID = 11;
const RESTART_TIMER = 12;

const ID_DM = 1;
const ID_TDM = 2;
const ID_CTF = 3;
const ID_INV = 4;

/*****************************************************************
 * RestartPlayer
 * Tell the new pawn what inventory they can hold
 *****************************************************************
 */
function RestartPlayer( Controller c ) {
   super.RestartPlayer( c );
   //set the preference for textures
   C.PlayerReplicationInfo.bIsSpectator = false;
   AdvancedPlayerController(c).SetCustomTextures();
   log("&& RestartPlayer");
}

/*****************************************************************
 * GameOver
 *****************************************************************
 */
function GameOver(){
    //Level.Game.SetPause(true,pc);
}

/*******************************************************************
 * InitGame
 * Initialize the game.  The GameInfo's InitGame() function is called
 * before any other scripts (including PreBeginPlay() ), and is used
 * by the GameInfo to initialize parameters and spawn its helper
 * classes.  Warning: this is called before actors' PreBeginPlay.
 *******************************************************************
 */
event InitGame(String options, out String error){

   local string InOpt;
   local int i;

   TimeLimit = 10;
   GoalScore = 15;
   IsPrivateGame = false;

   //Private Game
   InOpt = ParseOption (Options, "Private");
    if( InOpt != "" ){ IsPrivateGame = bool(InOpt); }

   //TimeLimit
    InOpt = ParseOption( Options, "TimeLimit");
    if( InOpt != "" ){ TimeLimit = int(InOpt); }
   if (TimeLimit == 0) { TimeLimit = -1; }

   //GoalScore
    InOpt = ParseOption( Options, "GoalScore");
    if( InOpt != "" ){ GoalScore = int(InOpt); }
   if (GoalScore == 0) { GoalScore = -1; }

   //treat this as a team game
    InOpt = ParseOption( Options, "IsTeam");
    if( InOpt != "" ){ bTeamGame = bool(InOpt); }

   if (TimeLimit == -1){
      RemainingTime = -1;
   } else {
      RemainingTime = TimeLimit * 60 + 1;
   }

   //get global bot management from the LD configed level info
   InitialInPlayLimit = MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).InitialInPlayLimit;
   MaxInPlayLimit = MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).MaxInPlayLimit;
   MinInPlayLimit = MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).MinInPlayLimit;
   PerPlayerInPlayLimitModifier = MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PerPlayerInPlayLimitModifier;

   for(i=0;i<MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh.length;i++){
      DynamicLoadObject(string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh[i]),class'Mesh');
      log("Preloading: " $ string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMesh[i]));
   }

   for(i=0;i<MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation.length;i++){
      DynamicLoadObject(string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation[i]),class'MeshAnimation');
      log("Preloading: " $ string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadAnimation[i]));
   }

   for(i=0;i<MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial.length;i++){
      DynamicLoadObject(string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial[i]),class'Material');
      log("Preloading: " $ string(MultiPlayerLevelInfo(Level.GameSpecificLevelInfo).PreloadMaterial[i]));
   }



   iDifficultyLevel = 1;

   Super.InitGame(options, error);

}


/*****************************************************************
 * Logout
 *****************************************************************
 */
function Logout( Controller Exiting ){
   //needs to be called to get an accurate NumPlayers
   super.Logout(Exiting);

   if (class'UtilsXbox'.static.Get_Reboot_Type() == 3) { // if live host
       if (IsPrivateGame) {
           class'UtilsXbox'.static.Live_Host_Set_PublicFilled(0);
           class'UtilsXbox'.static.Live_Host_Set_PublicOpen(0);
           class'UtilsXbox'.static.Live_Host_Set_PrivateFilled(NumPlayers);
           class'UtilsXbox'.static.Live_Host_Set_PrivateOpen(MaxPlayers - NumPlayers);

            if (MaxPlayers - NumPlayers > 0) {
               class'UtilsXbox'.static.Set_Player_Joinable      ();
               GameFilled = false;
               GameReplicationInfo.GameFilled = GameFilled;
            } else {
               class'UtilsXbox'.static.Set_Player_Not_Joinable  ();
               GameFilled = true;
               GameReplicationInfo.GameFilled = GameFilled;
            }
       } else {
           class'UtilsXbox'.static.Live_Host_Set_PublicFilled(NumPlayers);
           class'UtilsXbox'.static.Live_Host_Set_PublicOpen(MaxPlayers - NumPlayers);
           class'UtilsXbox'.static.Live_Host_Set_PrivateFilled(0);
           class'UtilsXbox'.static.Live_Host_Set_PrivateOpen(0);

           if (MaxPlayers - NumPlayers > 0) {
               class'UtilsXbox'.static.Set_Player_Joinable      ();
               GameFilled = false;
               GameReplicationInfo.GameFilled = GameFilled;
           } else {
               class'UtilsXbox'.static.Set_Player_Not_Joinable  ();
               GameFilled = true;
               GameReplicationInfo.GameFilled = GameFilled;
           }

       }
       class'UtilsXbox'.static.Live_Host_Update_Session();
   } else {
       class'UtilsXbox'.static.Set_Player_Not_Joinable();
   }
}

/*****************************************************************
 * Login
 *****************************************************************
 */
event PlayerController Login(string Portal,string Options,out string Error){
   local PlayerController tempplayer;
   //needs to be called to get an accurate NumPlayers
   tempplayer = super.Login(Portal,Options,Error);

   if (tempplayer != none){
      if (class'UtilsXbox'.static.Get_Reboot_Type() == 3) { // if live host
          if (IsPrivateGame) {
            class'UtilsXbox'.static.Live_Host_Set_PublicFilled(0);
            class'UtilsXbox'.static.Live_Host_Set_PublicOpen(0);
            class'UtilsXbox'.static.Live_Host_Set_PrivateFilled(NumPlayers);
            class'UtilsXbox'.static.Live_Host_Set_PrivateOpen(MaxPlayers - NumPlayers);

            if (MaxPlayers - NumPlayers > 0) {
               class'UtilsXbox'.static.Set_Player_Joinable      ();
               GameFilled = false;
               GameReplicationInfo.GameFilled = GameFilled;
            } else {
               class'UtilsXbox'.static.Set_Player_Not_Joinable  ();
               GameFilled = true;
               GameReplicationInfo.GameFilled = GameFilled;
            }
          } else {
            class'UtilsXbox'.static.Live_Host_Set_PublicFilled(NumPlayers);
            class'UtilsXbox'.static.Live_Host_Set_PublicOpen(MaxPlayers - NumPlayers);
            class'UtilsXbox'.static.Live_Host_Set_PrivateFilled(0);
            class'UtilsXbox'.static.Live_Host_Set_PrivateOpen(0);

            if (MaxPlayers - NumPlayers > 0) {
               class'UtilsXbox'.static.Set_Player_Joinable      ();
               GameFilled = false;
               GameReplicationInfo.GameFilled = GameFilled;
            } else {
               class'UtilsXbox'.static.Set_Player_Not_Joinable  ();
               GameFilled = true;
               GameReplicationInfo.GameFilled = GameFilled;
            }
          }
          class'UtilsXbox'.static.Live_Host_Update_Session();
       } else {
          class'UtilsXbox'.static.Set_Player_Not_Joinable();
       }
   }

   Log("Login called " $ GetNumPlayers() $ " of " $ MaxPlayers);
   return tempplayer;
}

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
simulated function PostBeginPlay(){
   super.PostBeginPlay();
}


/*****************************************************************
 * PostNetBeginPlay
 *****************************************************************
 */
simulated function PostNetBeginPlay(){
   SetMultiTimer(TIMELIMIT_ID, 1, true);
   super.PostNetBeginPlay();
}

/*****************************************************************
 * Reset
 * Start the game again
 *****************************************************************
 */
function Reset(){
   if (TimeLimit == -1){
      RemainingTime = -1;
   } else {
      RemainingTime = TimeLimit * 60 + 1;
   }

   super.Reset();
}

/*****************************************************************
 * InitGameReplicationInfo
 * Set up data that players will use
 *****************************************************************
 */
function InitGameReplicationInfo(){
   GameReplicationInfo.TimeLimit = TimeLimit;
   if (TimeLimit == -1){
      GameReplicationInfo.RemainingTime = -1;
   } else {
      GameReplicationInfo.RemainingTime = (RemainingTime /60) + 1;
   }
   GameReplicationInfo.GoalScore = GoalScore;

   if (bTeamGame){
      GameReplicationInfo.Teams[0] = Spawn(class'TeamInfo');
      GameReplicationInfo.Teams[1] = Spawn(class'TeamInfo');

      GameReplicationInfo.Teams[0].TeamName = "Red";
      GameReplicationInfo.Teams[0].TeamIndex = 0;

      GameReplicationInfo.Teams[1].TeamName = "Blue";
      GameReplicationInfo.Teams[1].TeamIndex = 1;
   }
   GameReplicationInfo.bMatchHasBegun = true;
   super.InitGameReplicationInfo();
}

/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
simulated function MultiTimer(int SlotID){
   switch (SlotID){
   case TIMELIMIT_ID:
      CheckTimeLimit();
      break;
   case RESTART_TIMER:
      RestartGame();
      break;
   }
}

/*****************************************************************
 * CheckTimeLimit
 * See if the game is over yet
 *****************************************************************
*/
function CheckTimeLimit(){
   local Controller Winner, C;
   local int Score;


//   log(remainingtime);
   //this game has no time limit
   if (TimeLimit==-1){
      return;
   }

   RemainingTime -= 1;
   if ((RemainingTime /60)+ 1 != GameReplicationInfo.RemainingTime){
      GameReplicationInfo.RemainingTime = RemainingTime/60 + 1;   //for display on server
      GameReplicationInfo.RemainingMinute = RemainingTime/60 + 1; //for display on client
   }

   //one minute warning
   if (RemainingTime == 60){
      GlobalAnnouncement(OneMinuteWarning);
   }
   //five minutes warning
   if (RemainingTime == 300){
      GlobalAnnouncement(FiveMinuteWarning);
   }

   Score = -1;
   if (RemainingTime <= 0){


    // SV: if team game and is tied, then just dont let anyone win
    if( (bTeamGame) && (GameReplicationInfo.Teams[0].Score == GameReplicationInfo.Teams[1].Score) )
    {
        EndGame(none, "");
        return;
    }

      //find the highest score
    for ( C=Level.ControllerList; C!=None; C=C.NextController ){

        //only check if a player has won
        if (PlayerController(C) == none){ continue; }

        // Use team scores if team game
        if( (C.PlayerReplicationInfo != None)
            && ((C.PlayerReplicationInfo.Team != none) && (C.PlayerReplicationInfo.Team.Score > Score)) )
        {
            Winner = C;
            Score = C.PlayerReplicationInfo.Team.Score;

        } else if ( (C.PlayerReplicationInfo != None)
            && ( (C.PlayerReplicationInfo.Team == none) && (C.PlayerReplicationInfo.Score > Score) ))
        {
            Winner = C;
           // if (C.PlayerReplicationInfo.Team == none){
               Score = C.PlayerReplicationInfo.Score;
            //} else {
            //   Score = C.PlayerReplicationInfo.Team.Score;
            //}

//            Log(Winner $ " currently has the highest score " $ Score );

        //if the score is the same as the highest score, and not a team game
        } else if ( C.PlayerReplicationInfo != none &&
                    C.PlayerReplicationInfo.Team == none &&
                        C.PlayerReplicationInfo.Score == Score ){

//            Log(C $ " another player ties the highest score");
            Winner = none;

         //if the score is the same as the highest score, and you are on a different team
         }else if ( Winner == none
                    ||
                  (C.PlayerReplicationInfo != none &&
                   C.PlayerReplicationInfo.Team != none &&
                   C.PlayerReplicationInfo.Team.Score == Score &&
                   C.PlayerReplicationInfo.Team.TeamIndex != Winner.PlayerReplicationInfo.Team.TeamIndex) ){

//            Log("Score: " $ C.PlayerReplicationInfo.Score);
//            Log(C.PlayerReplicationInfo.Team);
//            Log(Winner);
//            Log(C.PlayerReplicationInfo.Team.TeamIndex);
//            Log(Winner.PlayerReplicationInfo.Team.TeamIndex);


//            Log(C $ " on different team ties the highest score");
            Winner = none;
        }
      }
      EndGame(Winner.PlayerReplicationInfo, "");
   }
}

/*****************************************************************
 * CheckScore
 * See if this score means the game ends
 *****************************************************************
 */
function CheckScore(PlayerReplicationInfo Scorer)
{
    local controller C;

   if (GoalScore == -1){
      return;
   }

    if ( Scorer != None ){
      if (bTeamGame == true && Scorer.Team.Score >= GoalScore){
        EndGame(Scorer,"fraglimit");
      }
        // SV: added bTeamGame == false check to fix team game end game condition bug
        if ( (bTeamGame == false) && (GoalScore > 0) && (Scorer.Score >= GoalScore) ){
            EndGame(Scorer,"fraglimit");
        } else if ( bOverTime ) {
            // end game only if scorer has highest score
            for ( C=Level.ControllerList; C!=None; C=C.NextController )
                if ( (C.PlayerReplicationInfo != None)
                    && (C.PlayerReplicationInfo != Scorer)
                    && (C.PlayerReplicationInfo.Score >= Scorer.Score) )
                    return;
            EndGame(Scorer,"fraglimit");
        }
    }
   super.CheckScore(Scorer);
}

/*****************************************************************
 * EndGame
 *****************************************************************
 */
function EndGame(PlayerReplicationInfo Winner, string Reason){
    local controller C;
   SetMultiTimer(RESTART_TIMER,GameRestartTime,false);
   SetMultiTimer(TIMELIMIT_ID, 0, false);
   EndGameAnnouncement(Winner);

    for ( C=Level.ControllerList; C!=None; C=C.NextController ) {
      if (PlayerController(C) != none){
      PlayerController(C).ClientOpenMenu(default.EndOfMatchMenuMP);
      }
   }
   super.EndGame(Winner,Reason);
}


/*****************************************************************
 * EndGameAnnouncement
 *****************************************************************
 */
function EndGameAnnouncement(PlayerReplicationInfo Winner){

   local Controller P;

   if (Winner == none){
//      Log("No winner");
      //GlobalAnnouncement(YouLose);
      return;
   }

   if (bTeamGame == true){
      //RED team won!!!
      if (Winner.Team.TeamIndex == 0){
         TeamAnnounce(0, RedTeamWins);
         TeamAnnounce(1, RedTeamWins);
      //BLUE team won!!!
      } else {
         TeamAnnounce(0, BlueTeamWins);
         TeamAnnounce(1, BlueTeamWins);
      }

   }else {

      //Let people know how they did individually
        for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
            if ( P.IsA('PlayerController')){
               //there can be only one winner
               if (P.PlayerReplicationInfo == Winner){
                  PlayerController(P).PlayAnnouncement(class'Utils'.static.RndSound(YouWin),1,false);
               } else {
                  PlayerController(P).PlayAnnouncement(class'Utils'.static.RndSound(YouLose),1,false);
               }
         }
        }

   }
}




/*****************************************************************
 * Killed
 * Monitor killed messages for fraglimit
 *****************************************************************
 */
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
   super.Killed(Killer, Killed, KilledPawn, damageType);
   Killed.PlayerReplicationInfo.bIsSpectator = true;
   CheckScore(Killer.PlayerReplicationInfo);
}

/*****************************************************************
 * FindPlayerStart
 * returns the 'best' player start for this player to start from.
 *****************************************************************
*/
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    local NavigationPoint Best;

   super.FindPlayerStart(Player, InTeam, incomingName);

    if ( (Player != None) && (Player.StartSpot != None) )
        LastPlayerStartSpot = Player.StartSpot;
    Best = Super.FindPlayerStart(Player, InTeam, incomingName );
    if ( Best != None )
        LastStartSpot = Best;
    return Best;
}


/*****************************************************************
 * RatePlayerStart
 * Rate whether player should choose this NavigationPoint as its start
 *****************************************************************
 */
function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local PlayerStart P;
    local float Score, NextDist;
    local Controller OtherPlayer;

    P = PlayerStart(N);

    if ( (P == None) || !P.bEnabled || P.PhysicsVolume.bWaterVolume )
        return -10000000;

    if ( bTeamGame && (Team != P.TeamNumber) ) //&&&
        return -9000000;

    //assess candidate
    if ( P.bPrimaryStart )
        Score = 10000000;
    else
        Score = 5000000;
    if ( (N == LastStartSpot) || (N == LastPlayerStartSpot) )
        Score -= 10000.0;
    else
        Score += 3000 * FRand(); //randomize

    if ( Level.TimeSeconds - P.LastSpawnCampTime < 30 )
        Score = Score - (30 - P.LastSpawnCampTime + Level.TimeSeconds) * 1000;

    for ( OtherPlayer=Level.ControllerList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextController)
        if ( OtherPlayer.bIsPlayer && (OtherPlayer.Pawn != None) )
        {
            if ( OtherPlayer.Pawn.Region.Zone == N.Region.Zone )
                Score -= 1500;
            NextDist = VSize(OtherPlayer.Pawn.Location - N.Location);
            if ( NextDist < OtherPlayer.Pawn.CollisionRadius + OtherPlayer.Pawn.CollisionHeight )
                Score -= 1000000.0;
            else if ( (NextDist < 3000) && FastTrace(N.Location, OtherPlayer.Pawn.Location) )
                Score -= (10000.0 - NextDist);
            else if ( NumPlayers + NumBots == 2 )
            {
                Score += 2 * VSize(OtherPlayer.Pawn.Location - N.Location);
                if ( FastTrace(N.Location, OtherPlayer.Pawn.Location) )
                    Score -= 10000;
            }
        }
    return FMax(Score, 5);
}


/*****************************************************************
 * SetPause
 *****************************************************************
 */
function bool SetPause( bool bPause, PlayerController pc ) {
   //if you are pausing and there is a pawn then bring up the menu
   //DO NOT pause the game, if you have no pawn and are still alive
   // (you are in a cinematic) then do nothing

   //if you are dead
//   Log(pc.IsDead());
   if (pc.IsDead()){
//      Log("Calling Server RestartPlayer");
      pc.ServerRestartPlayer();
   }
   //pausing and not in a cinematic
   //if (bPause && !(pc.Pawn == None && pc.IsDead()==false)){
//      pc.ClientOpenMenu(default.PauseMenuMP);
//   }

   //if you are unpausing then unpause
   else if (!bPause){
       return Super.SetPause(bPause, pc);
   }

   return true;
}

/*****************************************************************
 * Tick
 *****************************************************************
 */
event Tick(float delta){
    super.Tick(delta);
    if (Tickcount == 0){
        Tickcount++;
    } else if (tickcount == 1){
        tickcount++;
        LevelStart();
    }
}

/*****************************************************************
 * SetDifficultyLevel
 * No! Don't!
 *****************************************************************
 */
function SetDifficultyLevel(int iDiffLevel){
}

/*****************************************************************
 * PostLoad
 *****************************************************************
 */
function PostLoad(){
    local Projector temp;

    super.PostLoad();

    foreach Allactors(class'Projector', temp){
            if (ShadowProjector(temp) == none){
                temp.AttachProjector();
            }
    }
}


/*****************************************************************
 * LevelStart
 *****************************************************************
 */
function LevelStart(){
    local PlayerController pc;
    pc = Level.GetLocalPlayerController();
    //close any loading screen menus
    GuiController(pc.Player.InteractionMaster.GlobalInteractions[0]).CloseAll(true);
}

/*****************************************************************
 * NotifyAddBot
 * Works in conjunction with the Multiplayer creation policy to
 * keep track of the number of computer controlled enemies in the game
 *****************************************************************
 */
function NotifyAddBot(){
   NumBots++;
}

/*****************************************************************
 * NotifyRemoveBot
 * Works in conjunction with the Multiplayer creation policy to
 * keep track of the number of computer controlled enemies in the game
 *****************************************************************
 */
function NotifyRemoveBot(){
   NumBots--;
}


//===========================================================================
// Team game functions
//===========================================================================




/*****************************************************************
 * PickTeam
 * When starting a team match we assing teams alternately to each
 * side based upon order of entry.
 *****************************************************************
 */
function byte PickTeam(byte Current, Controller C){

   local int i;
   local int RedCount, BlueCount;

   //evaluate the current team distribution
   for (i=0; i < GameReplicationInfo.PRIArray.length; i++){
      if (GameReplicationInfo.PRIArray[i].Team.TeamIndex == 0){
         RedCount++;
      } else {
         BlueCount++;
      }
   }

   //put the new guy on the smaller team
   if (RedCount > BlueCount){
      return 1;
   } else {
      return 0;
   }
}

/*****************************************************************
 * ChangeTeam
 * Assign the player a team info
 *****************************************************************
 */
function bool ChangeTeam(Controller Other, int TeamNum, bool bNewTeam)
{
   //Remove from your current team
   if (Other !=None && Other.PlayerReplicationInfo != none &&
       Other.PlayerReplicationInfo.Team !=None){
      Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
   }
   //Add to the new team
   GameReplicationInfo.Teams[TeamNum].AddToTeam(Other);
   return true;
}

/*****************************************************************
 * ScoreObjective
 *****************************************************************
 */
function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{
    if ( Scorer != None )
    {
        if ( Scorer.Team != None && bTeamGame)
            Scorer.Team.Score += Score;
    }
    if ( GameRulesModifiers != None )
        GameRulesModifiers.ScoreObjective(Scorer,Score);

    CheckScore(Scorer);
}

/*****************************************************************
 * TooManyBots
 * Coopted this function for use with the Multiplayer creation policy
 * in the opponent factory, so we can globally limit the number of monsters
 *****************************************************************
 */
function bool TooManyBots(Controller botToRemove){
   local int CurrentInPlayLimit;
   CurrentInPlayLimit = InitialInPlayLimit + ((NumPlayers - 1.0) * PerPlayerInPlayLimitModifier);
   CurrentInPlayLimit = Min(CurrentInPlayLimit, MaxInPlayLimit);
   CurrentInPlayLimit = Max(CurrentInPlayLimit, MinInPlayLimit);
   if (NumBots >= CurrentInPlayLimit){ return true; }
   return false;
}


/*****************************************************************
 * TeamAnnounce
 * Generic function that will send an announcement to everyone on
 * the specified team
 *****************************************************************
 */
function TeamAnnounce(int TeamNumber, array<sound> Announcements){
   local sound Announcement;
   local Controller P;

   Announcement = class'Utils'.static.RndSound(Announcements);
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController') &&
           P.PlayerReplicationInfo.Team.TeamIndex == TeamNumber){
               PlayerController(P).PlayAnnouncement(Announcement,0,false);
        }
   }
}

/*****************************************************************
 * GlobalAnnouncement
 *****************************************************************
 */
function GlobalAnnouncement(array<sound> Announcements){
   local sound Announcement;
   local Controller P;

   if (Announcements.length == 0){
      return;
   }

   Announcement = class'Utils'.static.RndSound(Announcements);
//   Log(Announcement);
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController')){
         PlayerController(P).PlayAnnouncement(Announcement,0,false);
        }
   }
}


//===========================================================================
// exec functions
//===========================================================================


/******************************************************************
 * TestEvent
 * Triggers the specified event.  Handy for debugging.
 ******************************************************************
 */
exec function TestEvent( Name eventName ) {
    Log( "Triggering [" $ eventName $ "]" );
    TriggerEvent( eventName, self, none );
}


/******************************************************************
 * NoMusic
 * Stops any music currently playing.
 ******************************************************************
 */
exec function NoMusic() {
   StopAllMusic( 2 );
}



/*****************************************************************
 *
 *****************************************************************
 */
exec function CheckSearchable(){
    local ActionableSkeletalMesh temp;
    foreach AllActors(class'ActionableSkeletalMesh', temp){
        temp.Check();
    }
}


//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     EndOfMatchMenuMP="DOTZMenu.DOTZMPDead"
     GameRestartTime=20
     MapListType="AdvancedEngine.AdvancedMapList"
}
