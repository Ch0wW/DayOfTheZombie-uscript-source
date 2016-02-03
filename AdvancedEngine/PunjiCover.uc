// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * PunjiCover -
 * 
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 ****************************************************************
 */
class PunjiCover extends AdvancedActor
placeable;

const TRAP_DELAY = 17333;
const TRAP_CHECK = 17334;

var() Sound WarningSound;
var() class<Emitter> ActivationEmitter;
var() Sound ActivationSound;

/****************************************************************
 * PostBeginPlay 
 ****************************************************************
 */
function PostBeginPlay(){
 SetMultiTimer(TRAP_CHECK,0.1,true);
 Super.PostBeginPlay();
}

/****************************************************************
 * Touch
 ****************************************************************
 */
function PreActivateTrap(){
   local Actor Stander;

   //affect anyone standing on you
   ForEach BasedActors( class'Actor', Stander ){
      if (Pawn(Stander) != None){
         PlaySound(WarningSound);         
         SetMultiTimer(TRAP_CHECK, 0, false);
         SetMultiTimer(TRAP_DELAY, 0.3, false);
      }
   }
}

/****************************************************************
 * MultiTimer 
 ****************************************************************
 */
function MultiTimer(int ID){
   switch ID{
    case TRAP_CHECK:
      PreActivateTrap();
      break;
   case TRAP_DELAY:
      ActivateTrap();
      break;
   }
}



/****************************************************************
 * ActivateTrap 
 ****************************************************************
 */
function ActivateTrap(){

   local Actor Stander;

   //collision changed so you can fall through
   bBlockActors   = false;
   bBlockPlayers  = false;
   bCollideWorld  = false;
   Spawn(ActivationEmitter);
   PlaySound(ActivationSound);         
   //affect anyone standing on you
   ForEach BasedActors( class'Actor', Stander ){
      Stander.SetPhysics(PHYS_Falling);
   }
   Destroy();
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     DrawType=DT_StaticMesh
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
