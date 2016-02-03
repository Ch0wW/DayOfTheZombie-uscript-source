// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * SpecialItem -
 *
 * Things that you should touch to "get". They can be turned on and
 * look special.
 *
 * @version $1.0$
 * @author  Jesse LaChapelle (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 ****************************************************************
 */
class SpecialItem extends AdvancedActor
    implements(HudDrawable)
    placeable;



var() bool bTurnsInvisible;
var() bool bStartsEnabled;
var() bool bDeactivates;

var() localized String ActionMessage;
var() localized String DisabledMessage;
var() Shader ActiveShader;
var(Events) Name SpecialItemEvent;
var(Events) Name DisabledUseEvent;

// an optional fancy icon for the hud
var() const Material HudIcon;
// location on the reference hud of the top-left corner of the icon
var() const int IconPositionX;
var() const int IconPositionY;
// drawable part of the icon material, in texels.
var() const int IconSizeX;
var() const int IconSizeY;

var() Sound ActionSound;
var() Sound DisabledSound;

//handlers
var(Events) editconst const Name hEnableItem;
var(Events) editconst const Name hDisableItem;
var(Events) editconst const Name hShowIcon;
var(Events) editconst const Name hHideIcon;


// internal
var bool bIsEnabled;
var bool bIconVisible;
const INIT_HACK_TIMER = 3854;


/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function PostBeginPlay(){

    Super.PostBeginPlay();
    //glowing stuff
    CopyMaterialsToSkins ();

    if (bStartsEnabled == true){
        TurnShaderOnOff(true);
        bIsEnabled = true;
    }
}

/**
 */
function PostLoad() {
    super.PostLoad();
    // re-register with the hud...
    SetMultiTimer( INIT_HACK_TIMER, 0.1, false );
}

/****************************************************************
 * TurnShaderOnOff
 ****************************************************************
 */
function TurnShaderOnOff(bool Active) {
    local Material MatHolder;
    local Shader current;
    local int i;

    //if it should be turned on
    if (Active){
       if (StaticMesh != none){
            bHidden = false;
       }
       if (!bIsEnabled){
          if (ActiveShader == None) return;

          for (i = 0; i < Skins.Length; ++i) {
             if (Skins[i] == None) { break; }
             //make a new material out of the glowing shader
             MatHolder = Skins[i];
             //make the diffuse channel of the shader into existing skin
             ActiveShader.Diffuse = MatHolder;
             Skins[i] = ActiveShader;
          }
       }
    }

    //otherwise turn it off if it can
    else {
        if (ActiveShader == None) return;
        for (i = 0; i < Skins.Length; ++i) {
            if (Skins[i] == None) break;
            current = Shader( Skins[i] );
            if ( current == None || current.diffuse == None ) break;
            Skins[i] = current.diffuse;
        }
    }
}

/****************************************************************
 * TriggerEx
 ****************************************************************
 */
event TriggerEx( Actor Other, Pawn EventInstigator, Name Handler ) {
                // Log( self @ Handler )    ;

    switch ( handler ) {

    // enable the mount
    case hEnableItem:
        TurnShaderOnOff(true);
        bIsEnabled=true;
        break;

    // disable the mount
    case hDisableItem:
        TurnShaderOnOff(false);
        bIsEnabled = false;
        break;

    // show icon on the hud
    case hShowIcon:
        SetIconVisible( true );
        break;

    // stop showing icon on the hud
    case hHideIcon:
        SetIconVisible( false );
        break;

    default:
        super.TriggerEx( other, eventInstigator, handler );
        break;
    }
}

function MultiTimer( int timerID ) {
    if ( timerID == INIT_HACK_TIMER ) {
        SetIconVisible( bIconVisible );
    }
    else super.MultiTimer( timerID );
}

/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller C){

   if (bIsEnabled == true){

      if (bDeactivates == true){
         //turn yourself invisible
         if (bTurnsInvisible == true){
            bHidden = true;
            SetCollision(false,false,false);
            bIsEnabled = false;
         } else {
            TurnShaderOnOff(false);
            bIsEnabled = false;
         }
      }

      //create an event
      TriggerEvent(SpecialItemEvent,self, None);
      PlaySound(ActionSound);

   } else {

      TriggerEvent(DisabledUseEvent,self, None);
      PlaySound(DisabledSound);

   }
}

/****************************************************************
 * GetActionableMessage
 ****************************************************************
 */
function string GetActionableMessage(Controller C){

    //if you are enabled and have a mesh that is rendered, or enabled and don't have a mesh
    // &&((level.TimeSeconds - LastRenderTime <= 0.5 && StaticMesh != none) ||  StaticMesh == None )
   if (bIsEnabled == true){
      return ActionMessage;
   } else {
      return DisabledMessage;
   }
}

/****************************************************************
 * GetActionablePriority
 ****************************************************************
 */
function int GetActionablePriority(Controller C){

    //if you are enabled and have a mesh that is rendered, or enabled and don't have a mesh
//    ((level.TimeSeconds - LastRenderTime <= 0.5 && StaticMesh != none) ||  StaticMesh == None )
   if (bIsEnabled == true){
      return iActionablePriority;
   } else {
      return 0;
   }
}


/****************************************************************
 * SetIconVisible
 ****************************************************************
 */
function SetIconVisible( bool makeVisible ) {
    local AdvancedHud hud;
    hud = AdvancedHud( AdvancedPlayerController(Level.GetLocalPlayerController()).myHud );
    if ( makeVisible && hudIcon != None ) {
        bIconVisible = true;
        hud.register( self );
    }
    else {
        bIconVisible = false;
        hud.unregister( self );
    }
}


/****************************************************************
 * drawToHud
 ****************************************************************
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {

    if ( AdvancedPlayerController(Level.GetLocalPlayerController()).IsDead() == false){
      c.setPos( iconPositionX * scaleX, iconPositionY * scaleY );
      c.DrawTile( hudIcon, iconSizeX * scaleX, iconSizeY * scaleY,
                0, 0, IconSizeX, IconSizeY );
    }
}


/****************************************************************
 * drawDebugToHud
 ****************************************************************
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY );


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bTurnsInvisible=True
     bDeactivates=True
     ActionMessage="Press Action to pick up this special item"
     IconPositionX=1130
     IconPositionY=370
     IconSizeX=128
     IconSizeY=128
     hEnableItem="ENABLE_ITEM"
     hDisableItem="DISABLE_ITEM"
     hShowIcon="SHOW_ICON"
     hHideIcon="HIDE_ICON"
     iActionablePriority=10
     bHasHandlers=True
     bCollideActors=True
     bBlockPlayers=True
     bProjTarget=True
}
