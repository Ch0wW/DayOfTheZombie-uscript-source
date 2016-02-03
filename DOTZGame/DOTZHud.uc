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
class DOTZHud extends DOTZHudBase;

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


/****************************************************************
 * GetStandardFontRef
 * A hack to propogate some of the fonts out to other components
 ****************************************************************
 */
/*
function Font GetStandardFontRef(){
   return standardFont;
}
*/


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBSmallFont Name=SubtitleFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="SubtitleFnt1"
     End Object
     SubtitleGuiFont=BBSmallFont'DOTZGame.DOTZHud.SubtitleFnt1'
     Begin Object Class=BBSmallFont Name=InfoFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="InfoFnt1"
     End Object
     InfoGuiFont=BBSmallFont'DOTZGame.DOTZHud.InfoFnt1'
     Begin Object Class=BBLargeFont Name=BigFnt1
         FontArrayNames(0)="BBHUDFonts.LargeBelow800"
         FontArrayNames(1)="BBHUDFonts.LargeBelow1024"
         FontArrayNames(2)="BBHUDFonts.LargeBelow1280"
         FontArrayNames(3)="BBHUDFonts.LargeBelow1600"
         FontArrayNames(4)="BBHUDFonts.LargeAbove1600"
         Name="BigFnt1"
     End Object
     BigGuiFont=BBLargeFont'DOTZGame.DOTZHud.BigFnt1'
     Begin Object Class=BBSmallFont Name=StandardFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="StandardFnt1"
     End Object
     StandardGuiFont=BBSmallFont'DOTZGame.DOTZHud.StandardFnt1'
     Begin Object Class=BBSmallFont Name=SmallFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="SmallFnt1"
     End Object
     SmallGuiFont=BBSmallFont'DOTZGame.DOTZHud.SmallFnt1'
}
