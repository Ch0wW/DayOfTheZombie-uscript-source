// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AdvancedHud - a fancier version of the standard HUD class.  The
 *    current instance can generally be found in
 *    AdvancedHud(Level.GetLocalPlayerController().myHUD)
 *
 * @version $Revision: #7 $
 * @author  Jesse Lachapelle (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class AdvancedHud extends HUD
    implements( HudDrawable );



//#exec new TrueTypeFontFactory PACKAGE="BBGUI" Name=BBLargeFont
//#exec new TrueTypeFontFactory PACKAGE="BBGUI" Name=BBSmallFont

//===========================================================================
// Externally interesting properties
//===========================================================================

// dimensions of the reference canvas, which everything is scaled
// relative to.
const REFX = 1280;
const REFY = 960;
// character used to indicate line breaks in a string...
const LINE_BREAK         = "|";
// most lines displayed at once in subtitles
const MAX_SUBTITLE_LINES = 3;
// timing of text displays
const SUBTITLE_DELAY     = 9.0;
const INFO_DELAY         = 2;
// message types used by Message() method
var const Name SUBTITLE;
var const Name INFO;
var const Name DEBUG_MSG;
// the right fonts for the current resolution of the canvas
// (maintained by the HUD)
var Font SubtitleFont;
var Font InfoFont;
var Font BigFont;
var Font StandardFont;
var Font TinyFont;
var Font SmallFont;
var bool bShowHud;

//===========================================================================
// Internal properties
//===========================================================================

var MessageQueue infoMsgs;
var struct MessageInfo {
    var array<String> msg;  // the lines of the message
    var float  revealTime;  // timestamp when it was first displayed
    var int    displayIdx;  // line to start the display at
} currentInfoMsg, currentSubtitle;

// all of the objects that have registered to be drawn
var private Array<HudDrawable> myHudDelegates;
//TODO can migrate to myHudDelegates...
var MountPoint ActiveMountPoint;

// subclasses may wish to override these...
var protected GUIFont SubtitleGuiFont;
var protected GUIFont InfoGuiFont;
var protected GUIFont BigGuiFont;
var GUIFont StandardGuiFont;
var protected GUIFont SmallGuiFont;
var GUIFont TinyGuiFont;

const SUBTITLE_UPDATE = 30281;
const INFO_UPDATE     = 18203;
const HEADER_X        = 1000;
const HEADER_Y        = 32;

//===========================================================================
// Interface for delegates
//===========================================================================

/**
 * Add d to the list of things that are drawn on the hud every frame.
 *
 * @param addLow - a little hack to put this delegate at the bottom of
 *                 the draw layers.
 */
function register( HudDrawable d, optional bool addLow ) {
    local int i, insertAt;

    if ( addLow ) {
        myHudDelegates.insert( 0, 1 );
        myHudDelegates[0] = d;
    }

    insertAt = myHudDelegates.length;
    for ( i = 0; i < myHudDelegates.length; ++i ) {
        // just exit if already registered...
        if ( myHudDelegates[i] == d ) return;
        // check for an open spot...
        if ( myHudDelegates[i] == None ) insertAt = i;
    }
    // if full, make some room...
    if ( insertAt >= myHudDelegates.length ) {
        insertAt = myHudDelegates.length;
        myHudDelegates.length = myHudDelegates.length + 1;
    }
    myHudDelegates[insertAt] = d;
}

/**
 * Remove d from the list of things that get drawn on the hud.
 */
function unregister( HudDrawable d ) {
    local int i;

    if ( d == None ) return;
    // find d and null it out...
    for ( i = 0; i < myHudDelegates.length; ++i ) {
        if ( myHudDelegates[i] == d ) {
            myHudDelegates.remove( i, 1 );
            return;
        }
    }
    //NOTE might be useful to shrink the array occasionally...
}

/****************************************************************
 * RegisterMountPoint
 ****************************************************************
 */
//TODO: this should be migrated to a HudDelegate
function RegisterMountPoint(MountPoint mp){
    if (ActiveMountPoint != None){
        Log("Attempt to register a mount point timer, while one is already active!");
        return;
    }
    ActiveMountPoint = mp;
}

/****************************************************************
 * UnRegisterMountPoint
 ****************************************************************
 */
//TODO: this should be migrated to a HudDelegate
function UnRegisterMountPoint(){
    ActiveMountPoint = None;
}


//===========================================================================
// Messaging to the hud...
//===========================================================================

/**
 * An alternate messaging system implementation...
 */
simulated function Message( PlayerReplicationInfo pri,
                            coerce String msg, Name msgType ) {
    local String logmsg;
    logmsg = "Received message," @ msgType @ "[" $ msg $ "]";
                // Log( self @ logmsg  )    ;

    switch ( msgType ) {
    case SUBTITLE:
        SetMessage( currentSubtitle.msg, msg );
        currentSubtitle.revealTime = Level.timeseconds;
        currentSubtitle.displayIdx = 0;
        // reset the timer, to ensure the message stays up for the
        // full duration...
        SetMultiTimer( SUBTITLE_UPDATE, SUBTITLE_DELAY, true );
        break;

    case DEBUG_MSG:
        if ( !bShowDebugInfo ) break;

    // else fall through and toss into the info queue...
    case INFO:
        //if ( currentInfoMsg.msg.length < 1 ) {
            SetMessage( currentInfoMsg.msg, msg );
            currentInfoMsg.revealTime = Level.timeseconds;
            // reset the timer, to ensure the message stays up for the
            // full duration...
            SetMultiTimer( INFO_UPDATE, INFO_DELAY, false );
        /*}
        else {
            infoMsgs.enqueueMessage( msg );
        }*/
  //      infoMsgs.enqueueMessage( msg );
        break;

    default:
        break;
    }
}

/****************************************************************
 * GetStandardFontRef
 * A hack to propogate some of the fonts out to other components
 ****************************************************************
 */
function Font GetStandardFontRef(){
   return standardFont;
}

function Font GetSmallFontRef(){
   return SmallFont;
}

function Font GetSubtitleFontRef(){
   return SubtitleFont;
}

function Font GetTinyFontRef(){
   return TinyFont;
}


//===========================================================================
// Implementation and helpers
//===========================================================================

/****************************************************************
 * DisplayProgressMessage does nothing. Will be done in the menus
 ****************************************************************
 */
simulated function DisplayProgressMessage(Canvas C)
{

}

function Destroyed(){
   super.Destroyed();
   standardFont = none;
   smallFont = none;
   subtitleFont = none;
}

/****************************************************************
 * PostRender - replacement for the standard hud framework
 ****************************************************************
 */
simulated event PostRender( canvas c ) {
    local int i;
    local float scaleX, scaleY, XPos,YPos;

    if (bShowHud == false){
       return;
    }

    // set up relevant vars for the canvas this frame...
    scaleX = c.clipX / REFX;
    scaleY = c.clipY / REFY;

    standardFont = standardGuiFont.GetFont( c.clipX );
    subtitleFont = subtitleGuiFont.GetFont( c.clipX );
    infoFont     = infoGuiFont.GetFont( c.clipX );
    bigFont      = bigGuiFont.GetFont( c.clipX );
    if( smallGuiFont != None)
        smallFont    = smallGuiFont.GetFont( c.clipX );
    if( tinyGuiFont != None)
        tinyFont     = tinyGuiFont.GetFont( c.clipX );
    // and start with the right font
    c.font = standardFont;

    // draw all registered objects to the screen...
    for ( i = 0; i < myHudDelegates.length; ++i ) {
        c.font = standardFont;
        myHudDelegates[i].drawToHUD( c, scaleX, scaleY );
    }
    //TODO could be migrated to the delegates...
    if (ActiveMountPoint != None) {
        c.font = standardFont;
        ActiveMountPoint.DrawHUD(C);
    }

    //pause stuff stolen from the parent class
    if ( (Level.Pauser != None) && (Level.TimeSeconds > Level.PauseDelay + 0.2) )
    {
        C.Style = ERenderStyle.STY_Normal;
        UseLargeFont(C);
        PrintActionMessage(C, PausedMessage);
    }

    // secondary pass for debug output...
    if ( bShowDebugInfo ) {
        for ( i = 0; i < myHudDelegates.length; ++i ) {
            c.font = standardFont;
            myHudDelegates[i].drawDebugToHUD( c, scaleX, scaleY );
        }
        c.font      = standardFont;
        c.Style     = ERenderStyle.STY_Alpha;
        c.DrawColor = ConsoleColor;
        PlayerOwner.ViewTarget.DisplayDebug( C, XPos, YPos );
    }
    // draw messages over the final product...
    c.font = standardFont;
    DisplayMessagesEx( c, scaleX, scaleY );
    c.font = standardFont;

     // Added by Demiurge Studios (Movie)
    if(TextureMovie != none && TextureMovie.Movie != none && TextureMovie.Movie.IsPlaying())
    {
        if(TexMovieTranslucent)
            c.Style = ERenderStyle.STY_Translucent;
        else
            c.Style = ERenderStyle.STY_Normal;
        c.SetDrawColor(255,255,255);
        c.SetPos( TexMovieLeft*c.SizeX, TexMovieTop*c.SizeY );
        c.DrawTile(TextureMovie, (TexMovieRight-TexMovieLeft)*c.SizeX, (TexMovieBottom-TexMovieTop)*c.SizeY, 0, 0, TextureMovie.Movie.GetWidth(), TextureMovie.Movie.GetHeight());
     }
    // End Demiurge Studios (Movie)

    //greenish modulation


    //overColor2 = (R=20,G=192,B=20,A=255)
    //C.DrawColor.R = 80;
  //  C.DrawColor.G= 220;
//    C./DrawColor.B = 220;
    //C.Style = ERenderStyle.STY_Modulated;
  //  C.SetPos(0,0);
//    C.DrawTile(Material'Engine.MenuWhite', C.SizeX, C.SizeY,0.0,0.0,4,4);

}

/**
 * Breaks a string on the LINE_BREAK character, into an array of
 * lines.
 */
function SetMessage( out Array<String> lines, String msg ) {
    local int pos;
    local bool bDone;

    lines.length = 0;
    bDone = false;
    if ( msg == "" ) return;
    do {
        pos = InStr( msg, LINE_BREAK );
        if ( pos == -1 ) {
            pos = Len(msg);
            bDone = true;
        }
        lines.length = lines.length + 1;
        lines[lines.length - 1] = left( msg, pos );
        msg = right( msg, len(msg) - pos - 1 );
    } until ( bDone );
}

/**
 */
function MultiTimer( int timerID ) {
    switch( timerID ) {
    case SUBTITLE_UPDATE:
        //SetMessage( currentSubtitle.msg, subtitles.dequeueMessage() );
        //currentSubtitle.revealTime = Level.timeseconds;
        currentSubtitle.displayIdx += MAX_SUBTITLE_LINES;
        break;

    case INFO_UPDATE:
        //SetMessage( currentInfoMsg.msg, infoMsgs.dequeueMessage() );
        currentInfoMsg.msg.Length = 0;
        currentInfoMsg.revealTime = Level.timeseconds;
        break;

    default:
        super.MultiTimer( timerID );
    }
}


/****************************************************************
 * DisplayMessageEx
 * Similar to DisplayMessages, but different.
 ****************************************************************
 */
function DisplayMessagesEx( Canvas c, float scaleX, float scaleY ) {
    local int i, subtitleIdx;
    c.SetDrawColor( 255, 255, 255, 0 );

    // info messages...
    c.font = infoFont;
    if ( currentInfoMsg.msg.length > 0 ) {
        for ( i = 0; i < currentInfoMsg.msg.length; ++i ) {
            c.SetPos( scaleX, i * 20 * scaleY + 10 );      //used to be 40 for t.v. safe region
            c.bCenter = true;
            c.DrawText( currentInfoMsg.msg[i] );
            c.bCenter = false;
        }
    }

    // subtitles...
    if ( currentSubtitle.msg.length > 0 ) {
        c.font = subtitleFont;
        for ( i = 0; i < MAX_SUBTITLE_LINES; ++i ) {
            c.SetPos( 300 * scaleX, (700 + i * 20) * scaleY );
            subtitleIdx = currentSubtitle.displayIdx + i;
            if (subtitleIdx < 0 || subtitleIdx >= currentSubtitle.msg.length) {
                break;
            }
            c.DrawText( currentSubtitle.msg[subtitleIdx] );
        }
    }
}

/**
 */
exec function HideHud(){
   bShowHud = false;
}

/****************************************************************
 * DrawHUD
 ****************************************************************
 */
function DrawHud( Canvas C ) {
    Super.DrawHud(c);
}

/****************************************************************
 * BeginPlay
 ****************************************************************
 */
simulated event WorldSpaceOverlays() {
    local AdvancedWeapon aw;
    local Pawn p;

    super.WorldSpaceOverlays();
    if ( bShowDebugInfo && Pawn(PlayerOwner.ViewTarget) != None ) {
        p = Pawn( PlayerOwner.ViewTarget );
        aw = AdvancedWeapon( p.weapon );
        if ( aw != None ) {
            aw.drawDebugHack( self );
        }
    }

}

/**
 */
function BeginPlay() {

   // StandardGuiFont = new (self) class'BBGUI.BBSmallFont'; //(DynamicLoadObject("BBGUI.BBSmallFont", class'GUIFont'));
//    SubtitleGuiFont = new (self) class'BBGUI.BBSmallFont'; //GUIFont(DynamicLoadObject("BBGUI.BBSmallFont", class'GUIFont'));
//    InfoGuiFont     = new (self) class'BBGUI.BBSmallFont'; //GUIFont(DynamicLoadObject("BBGUI.BBSmallFont", class'GUIFont'));
//    BigGuiFont      = new (self) class'BBGUI.BBLargeFont';//GUIFont(DynamicLoadObject("BBGUI.BBLargeFont", class'GUIFont'));
//    SmallGuiFont    = new (self) class'BBGUI.BBSmallFont';// GUIFont(DynamicLoadObject("BBGUI.BBSmallFont", class'GUIFont'));

    // throw the hud itself into the list, for consistency.
    register( self );
    SetMultiTimer( SUBTITLE_UPDATE, 5, true );
}


/****************************************************************
 * DrawToHUD
 ****************************************************************
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {
}


/****************************************************************
 * drawDebugToHUD
 ****************************************************************
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ) {
    c.SetPos( HEADER_X * scaleX, HEADER_Y * scaleY );
    c.DrawText( "DEBUG HUD" );
}

/****************************************************************
 * DrawLevelAction
 ****************************************************************
 */

function bool DrawLevelAction( canvas C )
{
    return false;
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Subtitle="Subtitle"
     Info="Info"
     DEBUG_MSG="DEBUG"
     bShowHud=True
     infoMsgs=MessageQueue'AdvancedEngine.AdvancedHud.InfoQ1'
     Begin Object Class=BBSmallFont Name=SubtitleFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="SubtitleFnt1"
     End Object
     SubtitleGuiFont=BBSmallFont'AdvancedEngine.AdvancedHud.SubtitleFnt1'
     Begin Object Class=BBSmallFont Name=InfoFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="InfoFnt1"
     End Object
     InfoGuiFont=BBSmallFont'AdvancedEngine.AdvancedHud.InfoFnt1'
     Begin Object Class=BBLargeFont Name=BigFnt1
         FontArrayNames(0)="BBHUDFonts.LargeBelow800"
         FontArrayNames(1)="BBHUDFonts.LargeBelow1024"
         FontArrayNames(2)="BBHUDFonts.LargeBelow1280"
         FontArrayNames(3)="BBHUDFonts.LargeBelow1600"
         FontArrayNames(4)="BBHUDFonts.LargeAbove1600"
         Name="BigFnt1"
     End Object
     BigGuiFont=BBLargeFont'AdvancedEngine.AdvancedHud.BigFnt1'
     Begin Object Class=BBSmallFont Name=StandardFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="StandardFnt1"
     End Object
     StandardGuiFont=BBSmallFont'AdvancedEngine.AdvancedHud.StandardFnt1'
     Begin Object Class=BBSmallFont Name=SmallFnt1
         FontArrayNames(0)="BBHUDFonts.SmallBelow800"
         FontArrayNames(1)="BBHUDFonts.SmallBelow1024"
         FontArrayNames(2)="BBHUDFonts.SmallBelow1280"
         FontArrayNames(3)="BBHUDFonts.SmallBelow1600"
         FontArrayNames(4)="BBHUDFonts.SmallAbove1600"
         Name="SmallFnt1"
     End Object
     SmallGuiFont=BBSmallFont'AdvancedEngine.AdvancedHud.SmallFnt1'
     Begin Object Class=BBPlainSmGuiFont Name=TinyFnt1
         FontArrayNames(0)="BBTFonts.PlainSmGuiBelow800"
         FontArrayNames(1)="BBTFonts.PlainSmGuiBelow1024"
         FontArrayNames(2)="BBTFonts.PlainSmGuiBelow1280"
         FontArrayNames(3)="BBTFonts.PlainSmGuiBelow1600"
         FontArrayNames(4)="BBTFonts.PlainSmGuiAbove1600"
         Name="TinyFnt1"
     End Object
     TinyGuiFont=BBPlainSmGuiFont'AdvancedEngine.AdvancedHud.TinyFnt1'
     LoadingMessage=""
     SavingMessage=""
     PausedMessage=""
     DebugFlags=1
}
