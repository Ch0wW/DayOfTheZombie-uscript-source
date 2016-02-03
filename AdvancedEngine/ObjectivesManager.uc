// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ObjectivesManager - holds the logic for the objectives system
 *
 * @version $Revision: #3 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 */
class ObjectivesManager extends Actor
   implements(EventDispatcher)
   implements(MessageDispatcher)
   implements(HudDrawable)
   notplaceable;



//===========================================================================
// COnfigurable
//===========================================================================
var() Material Backdrop;


//===========================================================================
// Internal data
//===========================================================================
var private GameSpecificLevelInfo theInfo;
var bool showObjectives;
var bool bMustShow;
var bool bAnyAreActive;
var Sound RevealSound;
var bool bUpdateRequired;
var Array<ObjectiveBase.ObjText> objectivesList;

const OBJ_SHOW_TIME  = 5;
const OBJ_HIDE_TIMER = 382058;
const OBJ_INITIAL_SHOW_TIMER = 382059;

const POS_Y = 140;


//===========================================================================
// Implementation
//===========================================================================

/**
 */
function Hide() {
    showObjectives = false;
    bMustShow = false;
    SetMultiTimer( OBJ_HIDE_TIMER, 0, false );
}

/**
 */
function Show( optional bool temporary ) {
    //there is nothing to show
    if (!AnyAreActive()){ return; }
    bUpdateRequired = true;

    if ( temporary && !bMustShow) {
        SetMultiTimer( OBJ_HIDE_TIMER, OBJ_SHOW_TIME, false );
        Level.GetlocalPlayerController().Pawn.PlaySound(RevealSound);
    }
    else {
        SetMultiTimer( OBJ_HIDE_TIMER, 0, false );
        bMustShow = true;
    }
    showObjectives = true;
}

/**
 *
 */
function BeginPlay() {
    local Array<Name> eventList;
    local int i;

    Super.BeginPlay();
    theInfo = GameSpecificLevelInfo(Level.GameSpecificLevelInfo);
    //            if ( !(theInfo != None ) ) {            Log( "(" $ self $ ") assertion violated: (theInfo != None )", 'DEBUG' );           assert( theInfo != None  );        }//    ;
    if ( theInfo == None ) return;
    theInfo.LevelObjectives.init( self, self );
    // add events from the level objectives to my bindings.
    theInfo.LevelObjectives.getEvents( eventList );
    for ( i = 0; i < eventList.length; ++i ) {
        bindEvent( eventList[i] );
    }
    SetMultiTimer(OBJ_INITIAL_SHOW_TIMER,0.5,false);

}

/**
 */
function PostLoad() {
    GotoState( 'Default' );
}

/**
 * Pass events through to the objectives...
 */
function TriggerEx( Actor sender, Pawn instigator, Name handler ) {
                // Log( self @ "Got an objective event:" @ handler  )    ;
    // dispatch event to the objective...
    theInfo.LevelObjectives.handleEvent( handler );
    bUpdateRequired=true;
    show( true );
}

/**
 */
function MultiTimer( int timerID ) {
    switch ( timerID ) {
    case OBJ_HIDE_TIMER:
        Hide();
        break;
     case OBJ_INITIAL_SHOW_TIMER:
        Show(true);
        break;
    default:
        super.MultiTimer( timerID );
    }
}

/**
 * Add the specified event to the event bindings table.  Uses the
 * handler to store the event name, since TriggerEx doesn't provide
 * this itself.
 */
function bindEvent( Name event ) {
    local EventHandlerMapping newBinding;

                // Log( self @ "Binding" @ event  )    ;
    newBinding.EventName = event;
    newBinding.HandledBy = event;
    EventBindings[EventBindings.length] = newBinding;
}

/**
 * Create an event on behalf of another object (the objectives objects
 * generally).
 */
function dispatchEvent( Name event ) {
    triggerEvent( event, self, none );
}

/**
 * Post a message on behalf of another object (an objective, typically).
 */
function DispatchMessage( String msg ) {
    Level.Game.Broadcast( self, msg,
                          class'AdvancedHud'.default.INFO );
}


/**
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {

    local int i;
    local PlayerController pc;
    local float maxLength;

    pc = Level.GetLocalPlayerController();
    if ( !showObjectives || theInfo == None
         || pc == none || pc.Pawn == none ) return;
    C.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetStandardFontRef();

    if (bUpdateRequired == true){
      objectivesList.Remove(0,objectivesList.length);
      theInfo.levelObjectives.getObjListText( objectivesList, 0 );
      bUpdateRequired = false;
    }

    // lay down the backdrop first
    c.SetPos( 0, (POS_Y - 17) * scaleY );
    // determine necessary width (approximately)
    maxLength = 0;
    for (i = 0; i<objectivesList.Length; i++){
       if (maxLength < Len(objectivesList[i].Text)){
          maxLength = Len(objectivesList[i].Text);
       }
    }
    maxLength = maxLength * 24;
    if (maxLength < 475){
        maxLength = 475;
    }
    c.DrawTileStretched( backdrop, maxLength * scaleX,
                         ((objectivesList.length + 1.5) * 35) * scaleY );

    // then type out the objectives list...
    for ( i = 0; i < objectivesList.length; ++i ) {
        if ( objectivesList[i].isComplete ) {
            c.SetDrawColor( 64, 64, 64 );
        }
        else {
            c.SetDrawColor( 255, 255, 255 );
        }
        c.setPos( (50 + objectivesList[i].indentLevel * 32) * scaleX,
                  (POS_Y + i * 38) * scaleY );
        c.drawText( objectivesList[i].text );
    }
}

/**
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ) {
}

/**
 */
auto state Default {
BEGIN:
    //NOTE A goofy hack to get this to happen after the player
    //     controller's PostBeginPlay();
    sleep( 0.5 );
                // Log( self @ "Re-registering with hud"  )    ;
    AdvancedHud( Level.GetLocalPlayerController().myHUD ).register( self );

}


function bool AnyAreActive(){
   local Array<ObjectiveBase.objText> objectivesList;
   local int i;

   //if any have already been set then skip the check
   if (bAnyAreActive == true){  return true; }

   theInfo.levelObjectives.getObjListText( objectivesList, 0 );

    //do a check to ensure that some are non-hidden
   for ( i = 0; i < objectivesList.length; ++i ) {
      if (objectivesList[i].Text != ""){
         bAnyAreActive = true;
         return true;
      }
   }
   return false;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     bHidden=True
     bHasHandlers=True
     DebugFlags=1
}
