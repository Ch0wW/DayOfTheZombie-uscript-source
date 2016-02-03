// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DestructableMesh - a static mesh that can be damaged.  This differs from
 *      DestructEffectsActor in that here the focus is on what happens to the
 *      mesh BEFORE it is destroyed, whereas DestructEffectsActors don't do much
 *      until AFTER they are destroyed.
 *
 * @version $Rev: 5335 $
 * @author  Jesse LaChapelle (jesse@digitalextremes.com)
 * @date    May 2004
 */
class DestructableMesh extends ActionableStaticMesh;


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
};


//LD stuff
var() int DamageCapacity;

//special emitter for destruction
var() class<Emitter> DestructionEmitter;
//minimum amount of damage you must do to damage this
var() int minDamageThreshold;
//list of things that happen when damaged
var() array<DamageStruct> DamageEffects;
var() bool bTakesDamageFromPlayer;
var() bool bDisappearOnDestruction;

//internal


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

            //Create an emitter
            if (DamageEffects[i].DamageEmitter != None){
               CurrentEmitters[i] = Spawn(DamageEffects[i].DamageEmitter,
                              ,, Location+DamageEffects[i].SpawnLocation);
               CurrentEmitters[i].bHardAttach=true;
               CurrentEmitters[i].SetBase(Self);
               DamageEffects[i].DamageEmitter = None;

               PlaySound(DestructionSound[Frand() * DestructionSound.length]);

            }
            //Play a sound
            if (DamageEffects[i].DamageSound != None){
               PlaySound(DamageEffects[i].DamageSound);
            }
            //swap meshes
            if (DamageEffects[i].DamageMesh != None){
               //swap the mesh
               SetStaticMesh (DamageEffects[i].DamageMesh);
            }
            DamageEffects[i].bCompleted = true;
         }
      }
   }
}

/*****************************************************************
 * Blowup
 *****************************************************************
 */
function Blowup() {
    local Emitter temp;

    if ( bDisappearOnDestruction ) {
        bHidden = true;
        SetCollision(false,false,false);
    }
    else {
        // make sure we're showing the most damaged mesh...
        DamageCapacity = 0;
        SpawnEffects();
    }

  //  PlaySound(DestructionSound[Frand() * DestructionSound.length]);
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

    default:
        Super.TriggerEx(Other,Instigator,handler);
   }
}

defaultproperties
{
     bTakesDamageFromPlayer=True
     bDisappearOnDestruction=True
     hDestroy="Destroy"
     bHasHandlers=True
}
