// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AdvancedSkeletalEmitter extends AdvancedActor;

var name AnimationName;

simulated function PostNetBeginPlay(){
   super.PostNetBeginPlay();
   PlayAnim(AnimationName);
   SetMultiTimer(1,3.0,false);
}

function MultiTimer(int SlotID){
   switch(SlotID){
      case 1:
      Destroy();
      break;
   }
}


event AnimEnd(int channel){
   bHidden=true;
   self.Destroy();
}

defaultproperties
{
     DrawType=DT_Mesh
}
