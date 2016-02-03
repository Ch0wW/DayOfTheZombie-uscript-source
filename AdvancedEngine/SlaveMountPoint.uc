// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * SlaveMountPoint - 
 *
 *  This mount point needs to coordinate its behaviour with a master
 *  mount point. Once it registers with its master it will mimic the
 *  state and timer of the master mount point.
 *
 * Despite the name, this type of mount point is NOT oppressed and is
 * designed to perform its tasks and enjoy them. It suffers no
 * persecution and is recognized as a fair and equal partner in the
 * mounting system
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Dec 2003
 */
class SlaveMountPoint extends MountPoint;

var MasterMountPoint TheMaster;

/****************************************************************
 * PostBeginPlay 
 * Find your master and tell him you exist
 ****************************************************************
 */
function PostBeginPlay()
{
   local MasterMountPoint tempMaster;
   
   //look for the master of your group
   foreach AllActors(class'MasterMountPoint',tempMaster)
   {
      if (tempMaster.MountGroup == MountGroup){
         TheMaster = tempMaster;
         break;
      }
   }
   TheMaster.NotifyExistance(self);

   Super.PostBeginPlay();
}

/****************************************************************
 * DoUnMount
 * Let the master know that the player has left
 ****************************************************************
 */
function bool DoUnMount(){
   //inform the master that you have been unmounted
   TheMaster.NotifyUnMounted(self);
   return Super.DoUnMount();
}

/****************************************************************
 * DoMount
 * Let the master know that the player has mounted
 ****************************************************************
 */
function bool DoMount(Pawn PawnToMount){
   //inform the master that you have been mounted
   TheMaster.NotifyMounted(self);
   return Super.DoMount(PawnToMount);
}



//===========================================================================
// Events
//===========================================================================



/****************************************************************
 * Trigger
 ****************************************************************
 */
event Trigger( Actor Other, Pawn EventInstigator ) {
}

//===========================================================================
// States
//===========================================================================

State Enabled{
 begin:
   //   Log ("Slave is enabled");
}

State Disabled{
 begin:
   // Log ("Slave is disabled");
}

defaultproperties
{
}
