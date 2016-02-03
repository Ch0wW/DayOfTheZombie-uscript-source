// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZHud - the player's HUD.  Much of the actual work is delegated to
 *    other objects via AdvancedHud's HudDrawable interface.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class DOTZInvasionHUD extends DOTZMPHudBase;

var localized string WaitingForWaveTxt;
var localized string PressFireTxt;

var Material WaveMat;
var Material KillsMat;
var Material RankMat;

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

    // draw the real stuff last...
    super.drawToHUD( c, scaleX, scaleY );

    DOTZPlayerControllerBase(Player).RefreshPRI(4);
/*
    Rank=1;
    //calculate the player's rank
   for ( i=0; i<Player.GameReplicationInfo.PRIArray.length; i++){
      if (Player.GameReplicationInfo.PRIArray[i].Kills > Player.PlayerReplicationInfo.Kills &&
           Player.GameReplicationInfo.PRIArray[i] != Player.PlayerReplicationInfo){
          Rank++;
      } else if (Player.GameReplicationInfo.PRIArray[i].Kills == Player.PlayerReplicationInfo.Kills &&
            Player.GameReplicationInfo.PRIArray[i].Deaths < Player.PlayerReplicationInfo.Deaths &&
            Player.GameReplicationInfo.PRIArray[i] != Player.PlayerReplicationInfo) {
            Rank++;
      }
   }
*/
    C.SetPos(LeftMargin,StatLocation);
    C.DrawTile(RankMat,128*scaleX,64*scaleY,0,0,128,64);
    C.SetPos(LeftMarginPlus, StatLocation+ (5*scaleY));
    C.DrawText(String(DOTZPlayerControllerBase(Player).pris[DOTZPlayerControllerBase(Player).myPRIIndex].Ranking));
    //DropShadowText(C,LeftMargin+40, StatLocation * scaleY, string(Rank));
    StatLocation += StatSpace;

    //kills
    C.SetPos(LeftMargin,StatLocation);
    C.DrawTile(KillsMat,128*scaleX,64*scaleY,0,0,128,64);
    C.SetPos(LeftMarginPlus,StatLocation+ (5*scaleY));
    C.DrawText(string(DOTZPlayerControllerBase(Player).pris[DOTZPlayerControllerBase(Player).myPRIIndex].Kills));
    //DropShadowText(C,LeftMargin+40, StatLocation * scaleY, string(int(Player.PlayerReplicationInfo.Score)));
    StatLocation += StatSpace;

    //waves
    C.SetPos(LeftMargin,StatLocation);
    C.DrawTile(WaveMat,128*scaleX,64*scaleY,0,0,128,64);
    C.SetPos(LeftMarginPlus,StatLocation + (5*scaleY));
    C.DrawText(string(int(Player.PlayerReplicationInfo.Team.Score)));
    //DropShadowText(C,LeftMargin+40, StatLocation * scaleY, string(int(Player.PlayerReplicationInfo.Team.Score)));
    StatLocation += StatSpace;


    //press fire to continue
    if (Player.PlayerReplicationInfo.bIsSpectator == true){

       if (Player.GameReplicationInfo.bMatchHasBegun == true ||
           Level.NetMode == NM_ListenServer ){
          C.bCenter = true;
          c.SetPos( scaleX, 375 * scaleY );
          if (Player.PlayerReplicationInfo.bOnlySpectator == false){
             C.DrawText(PressFireTxt);
          } else {
             C.DrawText(WaitingForWaveTxt);
          }
          C.bCenter = false;
       }
    }

}

/**
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ) {
    c.SetPos( HEADER_X * scaleX, HEADER_Y * scaleY );
    c.DrawText( "DEBUG HUD" );
}

/**
 */
exec function ShowDebug() {
    local VGSPAIController c;
    super.ShowDebug();
    foreach AllActors( class'VGSPAIController', c ) {
        c.bDebugLogging = bShowDebugInfo;
    }
}



//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     WaitingForWaveTxt="Waiting for next wave"
     PressFireTxt="Press fire to start"
     WaveMat=Texture'DOTZTInterface.HUD.HudIconINRedWaves'
     KillsMat=Texture'DOTZTInterface.HUD.HudIconRedKills'
     RankMat=Texture'DOTZTInterface.HUD.HudIconRedPlayerRank'
}
