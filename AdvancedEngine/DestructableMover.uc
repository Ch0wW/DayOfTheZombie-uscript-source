// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DestructableMover extends ActionableMover;



//Damage is represented by an emitter (ie smoke), a relative location
//to spawn that emitter and an absolute damage value that the emitter
//becomes active at.
struct DamageStruct{
   var bool bCompleted;
   var() class<Emitter> DamageEmitter;
   var() vector         SpawnLocation;
   var() int            DamageRequirement;
   var() StaticMesh     DamageMesh;
   var() Sound          DamageSound;
   var() bool           bUnlocks;
};


//LD stuff
var() int DamageCapacity;
//special emitter for destruction
var() class<Emitter> DestructionEmitter;
//minimum amount of damage you must do to damage this
var() int minDamageThreshold;
//list of things that happen when vehicle is damaged
var() array<DamageStruct> DamageEffects;
var() bool bTakesDamageFromPlayer;

var array<Emitter> CurrentEmitters;
var(Events) const editconst Name hDestroy;

var array<sound> DestructionSound;


/*****************************************************************
 * TakeDamage
 *****************************************************************
 */
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
				Vector momentum, class<DamageType> damageType)
{

   if (Damage < minDamageThreshold){
      return;
   }

   if (instigatedBy == Level.GetLocalPlayerController().Pawn &&
       bTakesDamageFromPlayer == false){
      return;
   }

   Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
   DamageCapacity = DamageCapacity - Damage;
   SpawnEffects();
   if (DamageCapacity <= 0 ){
      Blowup();
   }
}

/*****************************************************************
 * SpawnEffects
 *****************************************************************
 */
function SpawnEffects(){
   local int i;

   for (i = 0; i < DamageEffects.length; i++){
      if (float(DamageEffects[i].DamageRequirement) >= DamageCapacity){

         //Do your damage stuff
         if (DamageEffects[i].bCompleted != true){

              //swap meshes
            if (DamageEffects[i].DamageMesh != None){
               //swap the mesh
               SetStaticMesh (DamageEffects[i].DamageMesh);
            }
            //door is damaged enough that locking doesn't make sense?
            if (DamageEffects[i].bUnlocks == true){
               bLocked = false;
            }

            //Create an emitter
            if (DamageEffects[i].DamageEmitter != None){
               CurrentEmitters[i] = Spawn(DamageEffects[i].DamageEmitter,
                              ,, Location+DamageEffects[i].SpawnLocation);
               CurrentEmitters[i].bHardAttach=true;
               CurrentEmitters[i].SetBase(Self);
               DamageEffects[i].DamageEmitter = None;


            //why? cause the emitters aren't loud enough and I didn't feel like
            //adding a stupid sound to everything
            PlaySound(DestructionSound[Frand() * DestructionSound.length]);

            }


            //Play a sound
            if (DamageEffects[i].DamageSound != None){
               PlaySound(DamageEffects[i].DamageSound, 	SLOT_Misc,255,,5000,,false );
            }

         }
      }
   }
}

/*****************************************************************
 * Blowup
 *****************************************************************
 */
function Blowup(){
   local Emitter temp;

   bHidden = true;
   SetCollision(false,false,false);

   //why? cause the emitters aren't loud enough and I didn't feel like
   //adding a stupid sound to everything
   PlaySound(DestructionSound[Frand() * DestructionSound.length]);

   if (DestructionEmitter != None){
      temp = Spawn(DestructionEmitter);
      temp.AutoDestroy = true;
   }
}

/*****************************************************************
 * TriggerEx
 *****************************************************************
 */
function TriggerEx(Actor Other,Pawn Instigator, Name handler){
   switch (handler){
   case hDestroy:
      BlowUp();
      break;
   }
   Super.TriggerEx(Other,Instigator,handler);
}


/*****************************************************************
 * DoActionableAction
 *****************************************************************
 */
function DoActionableAction(Controller theController){
    //don't do stuff when you are blownup
    if (bHidden == false){
        Super.DoActionableAction(theController);
    }
 }

defaultproperties
{
     bTakesDamageFromPlayer=True
     hDestroy="Destroy"
}
