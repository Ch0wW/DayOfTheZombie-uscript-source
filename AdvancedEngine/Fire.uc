// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Fire extends AdvancedActor
placeable;

#exec Texture Import File=Textures\FireIcon.tga Name=FireIcon Mips=Off MASKED=1

struct IgnitionData{
   var name ActorName;
   var float age;
   var bool bStillInRange;
};

var() class<Emitter> FlameEmitterClass;
var() class<Emitter> FadingEmitterClass;
var() int DamagePerSec;
var() int FireBurnRadius;
var() int FadeRate;
var() int IgnitionTime;
var() bool bSourceFades;
var() bool bChildrenFade;
var() Actor BaseActor;
var() Actor NetBaseActor;
var() bool bStartsEnabled;
var() bool bDamageEnabled;
var() int iDamageRequired;
var() bool bFadeWhenBaseDestroyed;
var() class<Fire> ChildFireType;
var() class<DamageType> FireDamageType;
var() sound FireSound;

//Events
var(Events) editconst Name hFireOn;
var(Events) editconst Name hFireOff;

//internal
var array<IgnitionData> CloseStuff;
var int FadeStep;
var Emitter FlameEmitter;
var int iTotalDamage;


const BURNTIMER = 1;
var int BURNFREQ;


replication
{
    // Variables the server should send to the client.
    reliable if( bNetDirty && (Role==ROLE_Authority) )
        FlameEmitter, NetBaseActor;
}

/****************************************************************
 * PostBeginPlay
 * turn on the fire emitter
 ****************************************************************
 */
function PostBeginPlay(){

   if (bStartsEnabled){
      CreateFire();
   }
   FadeStep = FadeRate;
   if (BaseActor !=None){
      self.SetBase(BaseActor);
   }
}


/****************************************************************
 * MultiTimer
 * This timer is the fire's lifeline to action. Checks to see if it
 * should damage people, fade out, and spread flames
 ****************************************************************
 */
function MultiTimer(int ID){

   if (ID == BURNTIMER){
      if (CheckExtinguish()){
         return;
      }
      SpreadFlames();
   } else {
      Super.MultiTimer(ID);
   }
}


/****************************************************************
 * CheckExtinguish
 * This manages the fade out timers, when they reach zero (or if
 * another condition satisfies requirements) this function will
 * facilitate the destruction of this actor
 ****************************************************************
 */
function bool CheckExtinguish(){

   //if in water speed things along
   if (class'MovingExtinguishVolume' == PhysicsVolume.class ||
       class'ExtinguishVolume' == PhysicsVolume.class ||
       PhysicsVolume.Isa('WaterVolume')){
      bSourceFades = true;
      FadeStep = 1;
   }


   //calc fadeout stuff
   if (bSourceFades == true){
      FadeStep = FadeStep - 1;
   //   Log(self $ float(FadeStep)/float(FadeRate));
      if (FadeStep <= 0){
         DestroyFire();
         return true;
      }
   }

   //If this fire has been attached to something, but not so by the LD
   //then when the base is destroyed
   if ((Base == None || Base.bHidden == true) &&
       bFadeWhenBaseDestroyed == true){
      DestroyFire();
      return true;
   }

   return false;
}


/****************************************************************
 * SpreadFlames
 * This looks around for near by actors, does damage to them, and
 * tries to spread fire to appropriate actors. It calls a couple of
 * list managing functions to accomplish this.
 ****************************************************************
 */
function SpreadFlames(){

   local Fire FireActor;
   local Pawn NearActor;
   local bool bHasFire;


   //look if you should burn someone
   Foreach Radiusactors(class'Pawn',NearActor, FireBurnRadius ){

      //assume they are not burning
      bHasFire = false;

      //burning or not damage them
      if (DamagePerSec > 0){
         NearActor.TakeDamage(DamagePerSec,None,vect(0,0,0),vect(0,0,0),FireDamageType);
      }

      //bail if the actor is already burning
      foreach NearActor.BasedActors(class'Fire', FireActor){
         bHasFire = true;
      }

      if (bHasFire == False
          && IgnitionTimeElapsed(NearActor.name)==true
          && NearActor.Health > 0){

         FireActor = Spawn(childFireType,,,NearActor.location);
         FireActor.bSourceFades = bChildrenFade;
         FireActor.bChildrenFade = bChildrenFade;
         FireActor.bHardAttach = true;
         FireActor.SetBase(NearActor);
         FireActor.CreateFire();
      }
   }

   //prepare for next update
   CleanUpIgnitionData();

}

/****************************************************************
 * IgnitionTimeElapsed
 * This is a list management function that maintains a list of all the
 * nearby actors and how long they have been there. This is called
 * once per update for each nearby actor.
 ****************************************************************
 */
function bool IgnitionTimeElapsed(name ActorName){

   local int i;

   //no need for all this complexity just burn!!!
   if (IgnitionTime == 0){
      return true;
   }

   //go through the list once,
   for( i=0; i<CloseStuff.Length; i++){

      //if you find it, mark it as valid still
      //and increase the age
      if (CloseStuff[i].ActorName == ActorName){
         CloseStuff[i].bStillInRange = true;
         CloseStuff[i].age += BURNFREQ;

         //been here long enough to burn
         if (CloseStuff[i].age > IgnitionTime){
            return true;
         }

         //found the actor, not ready to burn
         return false;
      }
   }

   //save insertion spot
   i = CloseStuff.length;
   //increase array length
   CloseStuff.length = CloseStuff.length+1;
   //add to the list
   CloseStuff[i].ActorName = ActorName;
   CloseStuff[i].age = 0;
   CloseStuff[i].bStillInRange = true;
   return false;


}

/****************************************************************
 * CleanUpIgnitionData
 * Another list management function. Deletes any actors in the list
 * that are no longer near by. Called once per update.
 ****************************************************************
 */
function CleanUpIgnitionData(){
   local int i;
   for (i =0; i< CloseStuff.length; i++){

      //if not in range remove from the list
      if (CloseStuff[i].bStillInRange == false){
         CloseStuff.remove(i,1);

      //otherwise reset the data for next update
      } else {
         CloseStuff[i].bStillInRange = false;
      }
   }
}


/****************************************************************
 * TriggerEx
 * Fire can be event triggered
 ****************************************************************
 */
function TriggerEx(Actor Sender, Pawn Instigator, Name Handler){

   if (Handler == hFireOn){
      CreateFire();
   }
   else if(Handler == hFireOff){
      DestroyFire();
   }
}

/****************************************************************
 * TakeDamage
 * Fire can be damage triggered
 ****************************************************************
 */
function TakeDamage( int Damage,Pawn instigatedBy,Vector hitlocation,
                     vector momentum, class<DamageType> damageType ) {
   if (iTotalDamage == -1 || bDamageEnabled == false){
      return;
   }
   iTotalDamage = iTotalDamage + Damage;
   if (iTotalDamage > iDamageRequired){
      iTotalDamage = -1;
      CreateFire();
   }
}


/****************************************************************
 * CreateFire
 * Starts the emitters and starts the updating
 ****************************************************************
 */
function CreateFire(){
   //spawn the flame looking bit if you are not already burning
   if (FlameEmitter == None){
      FlameEmitter = Spawn(FlameEmitterClass);
      FlameEmitter.bHardAttach = true;
      FlameEmitter.SetBase(self);
      BURNFREQ += (Frand() * 0.3) - 1.5;
      SetMultiTimer(BURNTIMER, BURNFREQ, true);

      if ( FireSound != none){
        AmbientSound = FireSound;
      }
      NetBaseActor = Base;
   }
}

/****************************************************************
 * DestroyFire
 * Clears out the emitter and destroys this actor
 ****************************************************************
 */
function DestroyFire(){
   FlameEmitter.Destroy();
   FlameEmitter = Spawn(FadingEmitterClass);
   SetMultiTimer(BURNTIMER, 0, false);
   AmbientSound = none;
   Self.SetBase(none);
   Self.Destroy();

}


function Destroyed(){
 if ((FlameEmitter.Class != FadingEmitterClass) && FlameEmitter !=None){
    FlameEmitter.Destroy();
 }
 AmbientSound = none;
 super.Destroyed();
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     DamagePerSec=1
     FireBurnRadius=150
     FadeRate=10
     IgnitionTime=5
     bSourceFades=True
     bChildrenFade=True
     bDamageEnabled=True
     iDamageRequired=10
     bFadeWhenBaseDestroyed=True
     FireDamageType=Class'Gameplay.Burned'
     hFireOn="FLAME_ON"
     hFireOff="FLAME_OFF"
     BURNFREQ=2
     bHidden=True
     bHasHandlers=True
     bHardAttach=True
     bCollideActors=True
     bProjTarget=True
     bUseCylinderCollision=True
     Texture=Texture'AdvancedEngine.FireIcon'
}
