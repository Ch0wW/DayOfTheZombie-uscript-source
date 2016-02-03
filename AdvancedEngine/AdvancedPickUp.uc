// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AdvancedPickup extends Pickup;

var bool bPickedUpHack;

const STARTDELAY = 233;

enum DIFF_TYPE{
   DT_ANY,
   DT_EASY,
   DT_EASY_AND_NORMAL,
   DT_EASY_NORMAL_AND_HARD
};

var() DIFF_TYPE DifficultySetting;


/*****************************************************************
 * SimDestroy
 * Might need to respawn this later, so don't really destroy it
 *****************************************************************
 */
function SimDestroy(){
    SetCollision(false,false,false);
    bHidden=true;
    iActionablePriority=0;
    //Log("Sim destroy");
}


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
   super.PostBeginPlay();
   //no rotating please!
   SetPhysics(PHYS_None);
   //yes I know, magic number -1, shut up, no one cares!
   SetMultiTimer(STARTDELAY,1,false);
}

function DetermineDifficulty(){
   if (DifficultySetting != DT_ANY &&
      (DifficultySetting-1) < AdvancedGameInfo(Level.Game).iDifficultyLevel){
      SimDestroy();
   }
}

function MultiTimer(int ID){
    if ( ID == STARTDELAY){
      DetermineDifficulty();
    }
    super.MultiTimer(ID);
}


/*****************************************************************
 * GetActionablePriority
 *****************************************************************
 */
function int GetActionablePriority(Controller C){
    if (bPickedUpHack == true){
        return 0;
    }
    return iActionablePriority;
}

defaultproperties
{
     RespawnTime=60.000000
     RespawnEffectTime=0.000000
     bNetInitialRotation=True
     bBlockPlayers=True
     bProjTarget=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
