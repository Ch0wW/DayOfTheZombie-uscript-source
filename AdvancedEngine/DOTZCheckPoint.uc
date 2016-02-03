// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZCheckPoint - Its a checkpoint for DOTZ
 *
 * @version $Revision: #1 $
 * @author  Seelan V. (seelan@digitalextremes.com)
 * @date    July 2005
 */
class DOTZCheckPoint extends CheckPoint
    placeable;

const TOUCH_TIMER = 11111;
var localized string SaveMessage;


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
event PostBeginPlay(){
    log(self $ " PostBeginPlay");
    Super.PostBeginPlay();
}

/*****************************************************************
 * PostLinearLoad
 *****************************************************************
 */
event PostLinearLoad(){
   local Pawn TempPawn;
   log(self $ " calling activate");
   bPostLinearize=true;
   //redo the touching call
   foreach TouchingActors(class'Pawn', TempPawn){
      Activate(TempPawn);
   }
}


/*****************************************************************
 * Activate
 * Do what a checkpoint does!
 *****************************************************************
 */
function Activate(Actor Other){
   local String mapname, tmpname;
    local int count, i;
    local DOTZCheckPoint cp;

    log(self $ " Activate 1: " $ bTouchable $ " " $ bPostLinearize);
    if( !bTouchable )
        return;

    log(self $ " Activate 2");
    if( !Other.IsA( 'PlayerPawnBase' ) )
        return;

    Log("*** Touched:" @ self);

    // Turn actor off and do a save at this check point
    bTouchable = false;

    // If ActiveCheckPointID == id, then this is a load to this checkpoint
    if( Level.ActiveCheckPointID == id )
    {
        // Disable all checkpoints before this (including this)
         foreach AllActors( class'DOTZCheckPoint', cp )
        {
            if( cp.id <= id )
            {
                cp.bTouchable = false;
            }
            Log( "Disabled CheckPoint:" @ cp );
        }

        return;
    }

    // Not a load, so must be saving

    // Dont save if no space left
    if( !class'UtilsXbox'.static.Get_Save_Enable() )
        return;

    if( GameSpecificLevelInfo(Level.GameSpecificLevelInfo) != none )
        tmpname = GameSpecificLevelInfo(Level.GameSpecificLevelInfo).LevelName;
    else
        tmpname = "default";
    mapname = tmpname @ "-" @ "Checkpoint" @ id;

    // Set this to be the latest checkpoint
    Level.ActiveCheckPointID = id;
    log(Level.ActiveCheckPointID);

    // Check if checkpoint save exists
    count = class'Profiler'.static.GetTotalCheckpoints();
    for( i = 0; i < count; i++ )
    {
        tmpname = class'Profiler'.static.GetCheckpoint(i);
        log("name of checkpoint: " $ tmpName $ " vs. " $ MapName);
        if( tmpname == mapname )
        {
            // Checkpoint save exists, ask user
            Level.GetLocalPlayerController().SetPause( true );
            Level.GetLocalPlayerController().Player.GuiController.OpenMenu("DOTZMenu.XDOTZOverwriteCheckpoint", mapname, SaveMessage);
            return;
        }
    }
    // Only come back here if no checkpoint with same mapname exists
    if( id != 1)
        AdvancedHud(Level.GetLocalPlayerController().myHud).Message(Level.GetLocalPlayerController().PlayerReplicationInfo, SaveMessage, 'INFO');
      log("blah");
    Level.Game.ConsoleCommand( "SaveCheckPoint \"" $ mapname $ "\"");
}

// This is triggered when player walks over checkpoint
event Touch(Actor Other)
{
   if (bPostLinearize == true){
      Activate(Other);
   }
}

defaultproperties
{
     SaveMessage="Saving..."
     bStatic=False
     bNoDelete=False
     bCollideActors=True
     CollisionRadius=80.000000
     CollisionHeight=100.000000
}
