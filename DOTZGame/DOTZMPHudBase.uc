// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZMPHUDBase extends DOTZHudBase;

//screen locations
var int StatLocation, StatSpace;
var float LeftMargin;
var float LeftMarginPlus;
var float TeamLeftMargin;
var float ClockX, ClockY, ClockInc;

var PlayerController Player;
var int TeamNum;
var int EnemyTeamNum;

var Material ClockMat;

//localized text!
var localized string Mintxt;
var localized string Sectxt;
var localized string Unlimitedtxt;
var localized string TimeExpiredtxt;

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

//function SetTeamColor(int Red, int Green, int Blue){
//   R = Red;
//   G = Green;
//   B = Blue;
//}

/*****************************************************************
 * DropShadowText
 *****************************************************************
 */

function DropShadowText(Canvas C, float X, float Y, string text){

   //draw black
   C.SetPos(X, Y);
   C.SetDrawColor(0,0,0);
   C.DrawText(Text);

   //draw colour text
   C.SetPos(X-2, Y-1);
   C.SetDrawColor(255,255,255);
   C.DrawText(Text);
   //C.SetDrawColor(R,G,B);
}

/**
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {
   local int clamp_seconds;
   local string PlayerName;
   local vector worldCoords;
   local PlayerPawnBase P;
   local vector EnemyDir, FacingDir;

   Player = Level.GetLocalPlayerController();


   //XBOX
   if (Player.IsA('XDotzPlayerController') == true){
      StatLocation = 75 * scaleY;
      StatSpace = 50 * scaleY;
      LeftMargin = 115 * scaleX;
      LeftMarginPlus = LeftMargin + 30;
      TeamLeftMargin = 1000 * scaleX;
      ClockX = 280;
      ClockY = 40;
      ClockInc = ClockX + 20;

   //PC
   } else {
      StatLocation = 50 * scaleY;
      StatSpace = 50 * scaleY;
      LeftMargin = 70 * scaleX;
      LeftMarginPlus = LeftMargin + 50 * scaleX;
      TeamLeftMargin = 1100 * scaleX;
      ClockX = 600 * scaleX;
      ClockY = 30 * scaleY;
      ClockInc = ClockX + 40 * scaleX;

   }

   if (Player.PlayerReplicationInfo.Team != none){
      TeamNum = Player.PlayerReplicationInfo.Team.TeamIndex;

      if (TeamNum == 0) {
         EnemyTeamNum = 1;
      } else if (TeamNum == 1) {
         EnemyTeamNum = 0;
      }
   } else {
      TeamNum = -1;
      EnemyTeamNum = -1;
   }


   //draw the clock and the time here!
   C.SetPos(ClockX ,ClockY);
   C.DrawTile(ClockMat,32*scaleX,32*scaleY,0,0,32,32);

   if (Player.GameReplicationInfo.bMatchHasBegun == true){
      if (Player.GameReplicationInfo.RemainingTime == 1){
        clamp_seconds = Player.GameReplicationInfo.SecondsRemaining;
        if (clamp_seconds < 0)
            clamp_seconds = 0;
        DropShadowText(C,ClockInc, ClockY, string(clamp_seconds));
      }else if (Player.GameReplicationInfo.RemainingTime != -1){
        DropShadowText(C,ClockInc, ClockY, string(Player.GameReplicationInfo.RemainingTime) $ MinTxt);
      } else {
        DropShadowText(C,ClockInc, ClockY, UnlimitedTxt);
      }
   } else {
      DropShadowText(C,ClockInc, ClockY, TimeExpiredTxt);
   }

   if (Player.Pawn != none){
    foreach DynamicActors(class'PlayerPawnBase', P){

        EnemyDir = Normal(P.Location - Player.Pawn.Location);
        FacingDir = Normal(vector(Player.Pawn.Rotation));

        if (P != Player.Pawn && ((EnemyDir dot FacingDir) >= 0) &&
         FastTrace(P.Location + vect(0,0,20),Player.Pawn.Location)){

            PlayerName = P.xGamerTag;
            worldCoords = Player.Player.Console.WorldToScreen(P.Location + vect(0,0,50));
            C.SetPos((worldCoords.X-20), (worldCoords.Y));
            C.DrawTextClipped(PlayerName);
        }
    }
    }


   // draw the real stuff last...
   super.drawToHUD( c, scaleX, scaleY );

   //relevant MP stats
    C.Font = AdvancedHud(Player.myHUD).GetStandardFontRef();
    C.SetDrawColor(255,255,255);
   //Common to all MP games
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
     ClockMat=Texture'DOTZTInterface.HUD.Clock'
     Mintxt="Min."
     Sectxt="Sec."
     Unlimitedtxt="Unlimited"
     TimeExpiredtxt="Complete!"
     Begin Object Class=BBLargeFont Name=SubtitleFnt1
         FontArrayNames(0)="BBHUDFonts.LargeBelow800"
         FontArrayNames(1)="BBHUDFonts.LargeBelow1024"
         FontArrayNames(2)="BBHUDFonts.LargeBelow1280"
         FontArrayNames(3)="BBHUDFonts.LargeBelow1600"
         FontArrayNames(4)="BBHUDFonts.LargeAbove1600"
         Name="SubtitleFnt1"
     End Object
     SubtitleGuiFont=BBLargeFont'DOTZGame.DOTZMPHudBase.SubtitleFnt1'
     Begin Object Class=BBSmallFont Name=InfoFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="InfoFnt1"
     End Object
     InfoGuiFont=BBSmallFont'DOTZGame.DOTZMPHudBase.InfoFnt1'
     Begin Object Class=BBLargeFont Name=BigFnt1
         FontArrayNames(0)="BBHUDFonts.LargeBelow800"
         FontArrayNames(1)="BBHUDFonts.LargeBelow1024"
         FontArrayNames(2)="BBHUDFonts.LargeBelow1280"
         FontArrayNames(3)="BBHUDFonts.LargeBelow1600"
         FontArrayNames(4)="BBHUDFonts.LargeAbove1600"
         Name="BigFnt1"
     End Object
     BigGuiFont=BBLargeFont'DOTZGame.DOTZMPHudBase.BigFnt1'
     Begin Object Class=BBSmallFont Name=StandardFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="StandardFnt1"
     End Object
     StandardGuiFont=BBSmallFont'DOTZGame.DOTZMPHudBase.StandardFnt1'
     Begin Object Class=BBSmallFont Name=SmallFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="SmallFnt1"
     End Object
     SmallGuiFont=BBSmallFont'DOTZGame.DOTZMPHudBase.SmallFnt1'
}
