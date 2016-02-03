// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ActionableSkeletalMesh
 *
 * Uses a skeltal mesh and plays animations in a sequence. Thus you
 * can 'action' many functions out of an object
 ****************************************************************
 */

class ActionableSkeletalMesh extends AdvancedActor
placeable;

struct AttachedActors{
   var() name BoneName;
   var() name ActorTag;
};

struct ActionData{
   var() name AnimationName;
   var() sound AnimationSound;
   var() bool bVisibleInside;
};

var() int iActionablePriority;
var() localized string ActionMessage;
var() array<ActionData> ActionSeq;
var() array<AttachedActors> MyAttachedActors;
var() bool bRequireAnimCompletion;
var(Events) name ActionEvent;

//internal
var int currentIndex;
var bool busy;

var string Section;
var string Package;

var int iOldIndex; //replication stuff
const REP_INDEX = 111;

/****************************************************************
 * SetinitialState
 ****************************************************************
 */
function SetInitialState(){
    iRepIndex = currentIndex;
    super.SetInitialState();
    AttachItems();

  //  Package = class'Utils'.static.GetLocalizedPackage(string(self.class));
//    Section = class'Utils'.static.GetLocalizedSection(string(self.class));
//    ActionMessage = Localize(Section, "ActionMessage", Package);
}


/*****************************************************************
 * PostNetBeginPlay
 * Sets the client to figure out what state the server version is
 * in
 *****************************************************************
 */
simulated function PostNetBeginPlay(){
    if (Role < ROLE_Authority){
        SetMultitimer(REP_INDEX,0.3,true);
        iOldIndex = -1;
    }
}

/*****************************************************************
 * MultiTimer
 * Periodically check to see if the server has changed the state
 *****************************************************************
 */
simulated function MultiTimer(int SlotID){

    switch(SlotID){
    case REP_INDEX:
        if (iRepIndex != iOldIndex){
           PlayAnim(ActionSeq[iRepIndex].AnimationName);
            iOldIndex = iRepIndex;
        }
        break;
    }
}

/*****************************************************************
 * Check
 * Debuggin tool for LD's ... never used
 *****************************************************************
 */
function Check(){
    AttachItems();
}

/*****************************************************************
 * AttachItems
 * Puts the items on the bones
 *****************************************************************
 */
function AttachItems(){
   local int i;
   local actor temp;
   local bool error;
   local bool found;

   //look through the list of attached actors
   for (i=0; i < MyAttachedActors.Length; i++){

      error = false;
      found = false;

      //find them in the level
      ForEach AllActors(class'Actor', temp, MyAttachedActors[i].ActorTag){

        found = true;
         //attach them to the listed bones
        temp.SetCollision(false,false,false);
        error = AttachToBone(temp, MyAttachedActors[i].BoneName);
        if (error == false){
            Log ("ERROR: Could not attach : " $ temp $ " to : " $ MyAttachedActors[i].BoneName $ " on actor : " $ self);
        }
      }

      if (found == false){
        Log ("ERROR: Could not find : " $ MyAttachedActors[i].ActorTag $ " to attach to : " $ self);
      }

   }


}

/****************************************************************
 * DoActionableAction
 ****************************************************************
 */
function DoActionableAction(Controller C){
    if (busy == true && bRequireAnimCompletion == true){
        return;
    }
    busy = true;

    TriggerEvent(ActionEvent,Self,C.Pawn);

   //restart when done
   if (currentIndex >= ActionSeq.Length){
      currentIndex=0;
   }

   PlayAnim(ActionSeq[currentIndex].AnimationName);
   PlaySound(ActionSeq[currentIndex].AnimationSound);

   if (ActionSeq[currentIndex].bVisibleInside == true){
      bBlockZeroExtentTraces = false;
      iActionablePriority = 1;
   } else {
      iActionablePriority = default.iActionablePriority;
      bBlockZeroExtentTraces = true;
   }

   iRepIndex = currentIndex;
   currentIndex++;

}



/****************************************************************
 * GetActionableMessage
 ****************************************************************
 */
function string GetActionableMessage(Controller C){

    //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up



//   if (level.TimeSeconds - LastRenderTime <= 0.5 ){
    return ActionMessage;
//   }
}

/****************************************************************
 * GetActionablePriority
 ****************************************************************
 */
function int GetActionablePriority(Controller C){

    //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up

//   if (level.TimeSeconds - LastRenderTime <= 0.5 ){
    return iActionablePriority;
//   }
}

/****************************************************************
 * AnimEnd
 ****************************************************************
 */
function AnimEnd(int Channel){
   busy = false;
}

/*****************************************************************
 * PostLoad
 * reset the animation state of the mesh after a load
 *****************************************************************
 */
function PostLoad() {
    local int lastanimindex;

    lastanimindex = currentindex - 1;
    if (lastanimindex < 0) lastanimindex = ActionSeq.Length - 1;
    if ( lastAnimIndex >= 0 ) PlayAnim(ActionSeq[lastanimindex].AnimationName);
    super.PostLoad();
}

defaultproperties
{
     iActionablePriority=9
     ActionMessage="Press Action to search"
     bRequireAnimCompletion=True
     DrawType=DT_Mesh
     bCollideActors=True
     bBlockActors=True
     bProjTarget=True
     bUseCylinderCollision=True
     RemoteRole=ROLE_SimulatedProxy
}
