// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZInvasion extends DOTZMPGameBase;

var int InitialWaveSize;
var int WaveSizeIncrement;
var int NumWaves;
var int WaveRemaining;
var int WaveInPlay;
var int WaveSize;
var bool bFirstWave;

const WAVE_TIMER = 50;
const WAVEDELAY = 10;
const ANNOUNCE_DELAY = 2;

var array<Sound> NewWave;
var array<Sound> WaveCompleted;
var array<Sound> GameOver;

/*******************************************************************
 * Initialize the game.  The GameInfo's InitGame() function is called
 * before any other scripts (including PreBeginPlay() ), and is used
 * by the GameInfo to initialize parameters and spawn its helper
 * classes.  Warning: this is called before actors' PreBeginPlay.
 *******************************************************************
 */
event InitGame(String options, out String error){
   //get global bot management from the LD configed level info
   InitialWaveSize = WaveMultiPlayerLevelInfo(Level.GameSpecificLevelInfo).InitialWaveSize;
   WaveSizeIncrement = WaveMultiPlayerLevelInfo(Level.GameSpecificLevelInfo).WaveSizeIncrement;
   bFirstWave = true;
   SetMultiTimer(WAVE_TIMER, WAVEDELAY, false);
   super.InitGame(options, error);
   GoalScore = -1;
}

/*****************************************************************
 * InitGameReplicationInfo
 * Something just for invasion so the switc teams stuff doesn't come
 * up in the menu
 *****************************************************************
 */
function InitGameReplicationInfo(){
   super.InitGameReplicationInfo();
   GameReplicationInfo.bAllowedToSwitchTeams =false;
   GameReplicationInfo.MatchID = ID_INV;
}

/*****************************************************************
 * PickTeam
 * When starting a team match we assing teams alternately to each
 * side based upon order of entry.
 *****************************************************************
 */
function byte PickTeam(byte Current, Controller C){
   return 0;
}

/*****************************************************************
 * RestartPlayer
 *****************************************************************
 */
function RestartPlayer( Controller c ) {
   if (PlayerController(C).CanRestartPlayer()){
      super.RestartPlayer(c);
      C.PlayerReplicationInfo.bOnlySpectator = true;
   }
}

//event PlayerController Login(string Portal,string Options,out string Error){
//   super.Login(Portal,Options,Error);
//   log(self $ " " $ NumPlayers $ " : " $ MaxPlayers);
//}


/*****************************************************************
 * PostLogin
 *****************************************************************
 */
event PostLogin( PlayerController NewPlayer ){
   super.PostLogin(NewPlayer);
   NewPlayer.PlayerReplicationInfo.bOnlySpectator = false;
}

/*****************************************************************
 * StartWave
 *****************************************************************
 */
function StartWave(){

    local Controller P;

   //reset values
   WaveSize = InitialWaveSize + (WaveSizeIncrement * NumWaves);
   WaveRemaining = WaveSize;
   NumWaves++;

   //let'm know a wave is starting
   if (!bGameEnded){
      GlobalAnnouncement(NewWave);
   }

   //reset players
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController') )
        {
         if ( bGameEnded ){ return; }
         //dead players now get respawned
         if (P.Pawn == none || P.Pawn.Health <= 0){
            P.PlayerReplicationInfo.bOnlySpectator = false;
                RestartPlayer(P);
         }
        }
   }

   TriggerEvent('NEW_WAVE',self,none);
   GameReplicationInfo.Teams[0].Score +=1;

   bFirstWave = false;
}


/*****************************************************************
 * WaveComplete
 *****************************************************************
 */
function WaveComplete(){
   SetMultiTimer(WAVE_TIMER, 12, false);
   SetMultiTimer(ANNOUNCE_DELAY, 2, false);
}

/*****************************************************************
 * EndGameAnnouncement
 * Instead of the normal 'you win' 'you lose' crap, just say
 * game over, cause you always lose eventually
 *****************************************************************
 */
function EndGameAnnouncement(PlayerReplicationInfo Winner){

   local Controller P;
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController') ){
         P.PlayerReplicationInfo.bOnlySpectator = false;
        }
   }

   //use this opportunity to shut off other announcements
   SetMultiTimer(WAVE_TIMER, 0, false);
   SetMultiTimer(ANNOUNCE_DELAY, 0, false);
   GlobalAnnouncement(GameOver);
   GameReplicationInfo.bMatchHasBegun = false;
}

/*****************************************************************
 * TooManyBots
 * Coopted this function for use with the Multiplayer creation policy
 * in the opponent factory, so we can globally limit the number of monsters
 *****************************************************************
 */
function bool TooManyBots(Controller botToRemove){
   if (WaveRemaining > 0){
      return super.TooManyBots(BotToRemove);
   } else {
      return true;
   }
}

/*****************************************************************
 * NotifyAddBot
 *****************************************************************
 */
function NotifyAddBot(){
   WaveRemaining -=1;
   WaveInPlay++;
   super.NotifyaddBot();
}

/*****************************************************************
 * NotifyRemoveBot
 *****************************************************************
 */
function NotifyRemoveBot(){
   WaveInPlay--;
   if (WaveRemaining <= 0 && WaveInPlay <=0){
      WaveComplete();
   }
   super.NotifyRemoveBot();
}


/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int SlotID){
   switch(SlotID){
      case WAVE_TIMER:
         StartWave();
         break;

      case ANNOUNCE_DELAY:
         if (GameReplicationInfo.bMatchHasBegun == true){
            GlobalAnnouncement(WaveCompleted);
         }

      default:
         super.MultiTimer(SlotID);
   }
}

/*****************************************************************
 * Killed
 *****************************************************************
 */
function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> damageType )
{
   local bool bAllDead;
   local Controller P;

   bAllDead=true;
   super.Killed(Killer, Killed, KilledPawn, damageType);

   //check if there is anybody left alive
    for ( P = Level.ControllerList; P!=None; P=P.nextController ) {
        if ( P.IsA('PlayerController') )
        {
         if (P.Pawn != none && P.Pawn.Health > 0){
            bAllDead=false;
         }
        }
   }
   //if Everybody is dead then end the game
   if (bAllDead == true){
      EndGame(None, "Everyone is dead");
   }
}

/*****************************************************************
 * ScoreKill
 *****************************************************************
 */
function ScoreKill(Controller Killer, Controller Other)
{
    if( (killer == Other) || (killer == None) )
    {
        if (Other!=None)
        {
           Other.PlayerReplicationInfo.Score -= 1;
            ScoreEvent(Other.PlayerReplicationInfo,-1,"self_frag");
        }
    }
    else if ( killer.PlayerReplicationInfo != None )
    {
      //don't count zombies as a score in deathmatch
      if (!Other.IsA('PlayerController')){
            Killer.PlayerReplicationInfo.Score += 1;
           Killer.PlayerReplicationInfo.Kills++;
           ScoreEvent(Killer.PlayerReplicationInfo,1,"frag");
       }
   }
    if ( GameRulesModifiers != None )
        GameRulesModifiers.ScoreKill(Killer, Other);

    if ( (Killer != None) || (MaxLives > 0) )
    CheckScore(Killer.PlayerReplicationInfo);
}

function Logout( Controller Exiting ){

   if ( PlayerController(Exiting) != None ){
      if ( PlayerController(Exiting).PlayerReplicationInfo.bOnlySpectator ){
			NumPlayers--;
		}
   }
   super.Logout(Exiting);
   log(self $ " " $ NumPlayers $ " : " $ MaxPlayers);

}

//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     NewWave(0)=Sound'DOTZXAnnouncer.Invasion.InvasionNewWave01'
     NewWave(1)=Sound'DOTZXAnnouncer.Invasion.InvasionNewWave02'
     NewWave(2)=Sound'DOTZXAnnouncer.Invasion.InvasionNewWave03'
     NewWave(3)=Sound'DOTZXAnnouncer.Invasion.InvasionNewWave04'
     WaveCompleted(0)=Sound'DOTZXAnnouncer.Invasion.InvasionWaveComplete01'
     WaveCompleted(1)=Sound'DOTZXAnnouncer.Invasion.InvasionWaveComplete02'
     WaveCompleted(2)=Sound'DOTZXAnnouncer.Invasion.InvasionWaveComplete03'
     RedTeamWins(0)=Sound'DOTZXAnnouncer.CTF.CTFRedWon'
     BlueTeamWins(0)=Sound'DOTZXAnnouncer.CTF.CTFBlueWon'
     FiveMinuteWarning(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning01'
     FiveMinuteWarning(1)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning02'
     FiveMinuteWarning(2)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch5MinWarning03'
     OneMinuteWarning(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning01'
     OneMinuteWarning(1)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning02'
     OneMinuteWarning(2)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning03'
     OneMinuteWarning(3)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatch1MinWarning04'
     YouWin(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatchYouWin'
     YouLose(0)=Sound'DOTZXAnnouncer.DeathMatch.DeathMatchYouLose'
     bRestartLevel=False
     bTeamGame=True
     bDelayedStart=True
     HUDType="DOTZGame.DOTZInvasionHUD"
}
