// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZCaptureTheFlagHUD extends DOTZMPHudBase;

var localized string PressFireTxt;

var array<Material> TeamScoreMat;
var array<Material> ScoreMat;
var Material BagMat;

var array<Material> FlagHomeMat;
var array<Material> FlagHeldMat;
var array<Material> FlagDropMat;

var Material BlueFlagMat;
var Material RedFlagMat;

var float BagPosX, BagPosY;

//===========================================================================
// Editable properties
//===========================================================================

// HUD mockup

//===========================================================================
// Internal data
//===========================================================================




//===========================================================================
// Hud Hooks
//===========================================================================

/**
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {
   local CTFFlag tempFlag;

   local int LocalStat;

   //this sets all stats used below
   super.DrawToHUD(c,ScaleX,ScaleY);
   LocalStat = StatLocation;

     //XBOX
   if (Player.IsA('XDotzPlayerController') == true){
      BagPosX = 210*scaleX;
      BagPosY = 750* scaleY;
   }else{
      BagPosX = 180*scaleX;
      BagPosY = 800* scaleY;
   }
   DOTZPlayerControllerBase(Player).RefreshPRI(3);
/*
   Rank=1;
    //calculate the player's rank
   for ( i=0; i<Player.GameReplicationInfo.PRIArray.length; i++){
      if (Player.GameReplicationInfo.PRIArray[i].Kills > Player.PlayerReplicationInfo.Score &&
           Player.GameReplicationInfo.PRIArray[i] != Player.PlayerReplicationInfo){
          Rank++;
      } else if (Player.GameReplicationInfo.PRIArray[i].Kills == Player.PlayerReplicationInfo.Score &&
            Player.GameReplicationInfo.PRIArray[i].Deaths < Player.PlayerReplicationInfo.Deaths &&
            Player.GameReplicationInfo.PRIArray[i] != Player.PlayerReplicationInfo) {
            Rank++;
      }
   }
*/
   //player score
   if (Player.PlayerReplicationInfo.Team != none){
      C.SetPos(LeftMargin,StatLocation);
      C.DrawTile(TeamScoreMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
      C.SetPos(LeftMarginPlus,StatLocation+ (5*scaleY));
      C.DrawText(string(DOTZPlayerControllerBase(Player).pris[DOTZPlayerControllerBase(Player).myPRIIndex].Score));
      StatLocation += StatSpace;
   }

   //show the bag
   if (Player.PlayerReplicationInfo.bHasFlag){
      C.SetPos(BagPosX,BagPosY);
      C.DrawTile(BagMat,128*scaleX,64*scaleY,0,0,128,64);
   }

   foreach AllActors(class'CTFFlag', tempFlag){
      if (tempFlag.TeamType == 0){
         //red flag status
         if (tempFlag.bHome == true){
            RedFlagMat = FlagHomeMat[0];
         } else if (tempFlag.bHeld){
            RedFlagMat = FlagHeldMat[0];
         } else {
            RedFlagMat = FlagDropMat[0];
         }
      } else {
         //blue flag status
         if (tempFlag.bHome){
            BlueFlagMat = FlagHomeMat[1];
         } else if (tempFlag.bHeld){
            BlueFlagMat = FlagHeldMat[1];
         } else {
            BlueFlagMat = FlagDropMat[1];
         }
      }
   }

   //Draw the red flags status
   C.SetPos(TeamLeftMargin,LocalStat);
   C.DrawTile(RedFlagMat,64*scaleX,128*scaleY,0,0,64,128);
   C.SetPos(TeamLeftMargin + (15 * scaleX),LocalStat + (60*scaleY));
   C.DrawText(string(int(Player.GameReplicationInfo.Teams[0].Score)));

   //Draw the blue flags status
   C.SetPos(TeamLeftMargin + (70 * scaleX),LocalStat);
   C.DrawTile(BlueFlagMat,64*scaleX,128*scaleY,0,0,64,128);
   C.SetPos(TeamLeftMargin + (85 * scaleX), LocalStat+ (60 * scaleY));
   C.DrawText(string(int(Player.GameReplicationInfo.Teams[1].Score)));

   //press fire to continue
   if (Player.PlayerReplicationInfo.bIsSpectator == true){

       //if you are a client and the game is not restarting, then show the continue message
       //if you are the server, then always show the continue message
       if (Player.GameReplicationInfo.bMatchHasBegun == true ||
           Level.NetMode == NM_ListenServer ){
          C.bCenter = true;
          c.SetPos( scaleX, 375 * scaleY );
          C.DrawText(PressFireTxt);
          C.bCenter = false;
       }
    }
}


//===========================================================================
// default Properties
//===========================================================================

defaultproperties
{
     PressFireTxt="Press fire to continue"
     TeamScoreMat(0)=Texture'DOTZTInterface.HUD.HudIconRedPlayerScore'
     TeamScoreMat(1)=Texture'DOTZTInterface.HUD.HudIconBluePlayerScore'
     ScoreMat(0)=Texture'DOTZTInterface.HUD.HudIconRedKills'
     ScoreMat(1)=Texture'DOTZTInterface.HUD.HudIconBlueKills'
     BagMat=Texture'DOTZTInterface.HUD.HudIconCTFPlayerHasBag'
     FlagHomeMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagAtBase'
     FlagHomeMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagAtBase'
     FlagHeldMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagStolen'
     FlagHeldMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagStolen'
     FlagDropMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagDropped'
     FlagDropMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagDropped'
}
