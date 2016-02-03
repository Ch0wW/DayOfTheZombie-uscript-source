// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ActionableStaticMesh extends AdvancedActor;

//different message while locked
var() localized string ActionMessage;
//displays a message and accepts user action input
var() bool bActionable;
var() int NumberOfUsesAllowed;
var(ActionSound) Sound ActionSound;
var(ActionMesh) StaticMesh ActionMesh;
var(events) name ActionEvent;
var(ActionMaterial) Material MaterialToSwap;
var(ActionEmitter) class<Emitter> ActionEmitter;
var(ActionEmitter) vector EmitterOffset;
var(ActionEmitter) rotator EmitterRotation;

enum MESH_ACTION{
   MA_NONE,
   MA_TOGGLE,
   MA_SWAP_ONCE
};

enum SOUND_ACTION{
   SA_NONE,
   SA_PLAY,
   SA_PLAY_ONCE,
   SA_TOGGLE_AMBIENT
};

enum MATERIAL_ACTION{
    MA_NONE,
    MA_TRIGGER
};

enum EMITTER_ACTION{
    EA_NONE,
    EA_SPAWN,
    EA_TOGGLE
};

var(ActionMesh) MESH_ACTION MeshAction;
var(ActionSound) SOUND_ACTION SoundAction;
var(ActionMaterial) MATERIAL_ACTION MaterialAction;
var(ActionEmitter) EMITTER_ACTION EmitterAction;

//internal
var int iActionablePriority;
var bool bOriginalMesh;
var bool bOriginalAmbient;
var Material OrigMaterial;
var bool bNotPlayedYet;
var bool bNotSwappedYet;
var int iUseCount;
var Emitter savedEmitter;

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
    CopyMaterialsToSkins();
    OrigMaterial = Skins[1];
}


/*****************************************************************
 * GetActionablePriority
 *****************************************************************
 */
function int GetActionablePriority(Controller C){

    //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up

//    if (level.TimeSeconds - LastRenderTime <= 0.5 ){
  //      return 0;
  //  }

   //exceeded usage alotment
   if (NumberOfUsesAllowed != -1 && iUseCount >= NumberOfUsesAllowed){
    return 0;
   }

   //return normal priority
   if (bHidden == false && bActionable == true){
    return iActionablePriority;
   } else {
    return 0;
   }
}

/*****************************************************************
 * GetActionableMessage
 *****************************************************************
 */
function string GetActionableMessage(Controller C){

/*
 if (level.TimeSeconds - LastRenderTime > 0.5 ){
    return "";
 }
 */

   //use have exceeded the use count
   if (NumberOfUsesAllowed != -1 && iUseCount >= NumberOfUsesAllowed){
    return "";
   }

   if (bHidden == false && bActionable == true){
         return ActionMessage;
   } else {
      return "";
   }
}

/*****************************************************************
 * DoActionableAction
 *****************************************************************
 */
function DoActionableAction(Controller thecontroller){

   local vector emitterLocation;

   // so you can limit the number of uses
   if (NumberOfUsesAllowed != -1 && iUseCount >= NumberOfUsesAllowed){
    return;
   }
   iUseCount++;

   TriggerEvent(ActionEvent, self, thecontroller.pawn);

   // SOUND ACTION
   //-------------------------------
   if (SoundAction != SA_NONE){

      //PLAY SOUND WHEN ACTION IS PRESSED
      if (SoundAction == SA_PLAY){
         PlaySound(ActionSound);

      //PLAY BUT ONLY ONCE
      } else if (SoundAction == SA_PLAY_ONCE && bNotPlayedYet == true){
         bNotPlayedYet = false;
         PlaySound(ActionSound);

      //TOGGLE THE AMBIENT SOUND
      } else if (SoundAction == SA_TOGGLE_AMBIENT){

         if (bOriginalAmbient == true){
            bOriginalAmbient = false;
            ambientSound = ActionSound;
         } else {
            bOriginalAmbient = true;
            AmbientSound = default.ambientSound;
         }
      }

   }

   //MESH ACTION
   //-------------------------------
   if (MeshAction != MA_NONE){

      //TOGGLE MESH
      if (MeshAction == MA_TOGGLE){
         if (bOriginalMesh == true){
            SetStaticMesh(ActionMesh);
            bOriginalMesh = false;
         } else {
            SetStaticMesh(default.StaticMesh);
            bOriginalMesh = true;
         }

      //SWAP MESH ONCE
      } else if (MeshAction == MA_SWAP_ONCE && bNotSwappedYet){
         bNotSwappedYet = false;
         SetStaticMesh(ActionMesh);
      }

   }

   //MATERIAL ACTION
   //-------------------------------
   if (MaterialAction != MA_NONE){

    if (OrigMaterial != none && MaterialToSwap != none){
        if (Skins[1] == OrigMaterial){
            Skins[1] = MaterialToSwap;
        } else {
            Skins[1] = OrigMaterial;
        }
    }
   }

   //EMITTER ACTION
   //-------------------------------
   if (EmitterAction != EA_NONE){

    emitterLocation = Location + EmitterOffset;
    //SPAWN
    if (EmitterAction == EA_SPAWN){
        savedEmitter = Spawn(ActionEmitter,None,'',EmitterLocation, Rotation + EmitterRotation);

    } else if (EmitterAction == EA_TOGGLE){
        if (savedEmitter == none){
            savedEmitter = Spawn(ActionEmitter,,,EmitterOffset, Rotation+ EmitterRotation);
        } else {
            savedEmitter.destroy();
        }
    }

   }

   return;
}

function Trigger(Actor Other, Pawn EventInstigator){
    DoActionableAction( EventInstigator.Controller);
}

defaultproperties
{
     bActionable=True
     NumberOfUsesAllowed=-1
     SoundAction=SA_PLAY
     iActionablePriority=2
     bOriginalMesh=True
     bOriginalAmbient=True
     bNotPlayedYet=True
     bNotSwappedYet=True
     DrawType=DT_StaticMesh
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bEdShouldSnap=True
}
