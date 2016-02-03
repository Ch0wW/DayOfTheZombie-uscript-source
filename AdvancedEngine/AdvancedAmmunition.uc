// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * HGAmmo -
 *
 * Used to add the ability to make the ammunition infinite
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class AdvancedAmmunition extends Ammunition;




var() bool Infinite;
var int DamageAmount;
var bool bUnderBotControl;
var bool bDoesSpecialDamage;

var class<emitter> ImpactEmitter;
var class<emitter> ImpactDirt;
var class<emitter> ImpactFlesh;
var class<emitter> ImpactMetal;
var class<emitter> ImpactPlant;
var class<emitter> ImpactRock;
var class<emitter> ImpactWater;
var class<emitter> ImpactWood;
var class<emitter> ImpactIce;
var class<emitter> ImpactSnow;
var class<emitter> ImpactGlass;

var class<projector> ImpactProjector;

var const float MinTimeBetweenEffects;
var private float LastEffectTime;

var int MomentumTransfer;


/*****************************************************************
 * PlayBulletHit
 *****************************************************************
 */
function PlayBulletHit(Material HitObject,  vector Loc, rotator Rotate){

   local class<Emitter> FinalEmitter;
   local float timeSinceLastEffect, currentTime;
//   local vector X,Y,Z;

   //GetAxes(rotation, X,Y,Z);

   // limit effects so that insane rate-of-fire does not result in
   // insane-performance-hit.
   currentTime         = Level.TimeSeconds;
   timeSinceLastEffect = currentTime - lastEffectTime;
   if ( timeSinceLastEffect < minTimeBetweenEffects ) return;
   else lastEffectTime = currentTime;

   //look for a material specific impact type
   switch (HitObject.SurfaceType){
   case EST_DIRT:
      FinalEmitter = ImpactDirt;
      break;
   case EST_METAL:
      FinalEmitter = ImpactMetal;
      break;
   case EST_PLANT:
      FinalEmitter = ImpactPlant;
      break;
   case EST_ROCK:
      FinalEmitter = ImpactRock;
      break;
   case EST_WATER:
      FinalEmitter = ImpactWater;
      break;
   case EST_WOOD:
      FinalEmitter = ImpactWood;
      break;
    case EST_ICE:
      FinalEmitter = ImpactIce;
      break;
   case EST_SNOW:
      FinalEmitter = ImpactSnow;
      break;
   case EST_GLASS:
      FinalEmitter = ImpactGlass;
      break;
   case EST_FLESH:
      FinalEmitter = ImpactFlesh;
      break;

   default:
      FinalEmitter = ImpactEmitter;
   }

   //if you are missing the material specific stuff then try the default
   if (FinalEmitter == None){ FinalEmitter = ImpactEmitter; }

   //now try to play the final sound/emitter
   if (FinalEmitter !=None){  Spawn(FinalEmitter,,,Loc,Rotate); }


}




/*****************************************************************
 * ProcessTraceHit
 *****************************************************************
 */
function ProcessTraceHitOnMat(Weapon W, Actor Other, Vector HitLocation,
                         vector HitNormal, vector X, vector Y, vector Z,
                         Material HitMaterial)
{
   local int RealDamage;

   //   if (Infinite == false){ AmmoAmount -= 1; }
   if ( Other == None ){ return; }

   RealDamage = ModifyDamage(HitLocation, DamageAmount);

   //you hit part of the planet, spawn appropriate emmitter
   if ( Other.bWorldGeometry || (Mover(Other) != None) ){

      //make some noise and flashies
      PlayBulletHit(HitMaterial, HitLocation + HitNormal*3, rotator(HitNormal));
      //This is a special case where you hit a vehicle
      if (RailShooter(Other)!= None){
         RailShooter(Other).TakeSomeDamage(RealDamage,Instigator);
      }
      Other.TakeDamage(RealDamage, W.Instigator,
                       HitLocation, vect(0,0,0), MyDamageType);

   //not shooting youself
   } else if ( Other != W.Instigator ){

      //Is this a person that needs to be hurt, or just more of the planet
      if ( Pawn(Other)!= None  &&
           Level.GetLocalPlayerController().Pawn != Pawn(Other)){

            //pawn spawns it's own blood'n'stuff
            if (ImpactFlesh != none){
             Spawn(ImpactFlesh,,,HitLocation+HitNormal*3);
             Spawn(ImpactFlesh,,,HitLocation+HitNormal*3);
            }

      //you hit something (not a pawn)
      } else if (Level.GetLocalPlayerController().Pawn != Pawn(Other)){
         //make some noise and flashies
         PlayBulletHit(HitMaterial, HitLocation+HitNormal*3, rotator(HitNormal));


      }

      //ah..here be the pain
                  // Log( self @ "The Pawns velocity: " $ Other.Velocity )    ;

      Other.TakeDamage(RealDamage,W.Instigator,
                       HitLocation,MomentumTransfer*(-HitNormal),MyDamageType);
                  // Log( self @ "The Pawns velocity After: " $ Other.Velocity )    ;
   }


   //spawn a projector
    if (ImpactProjector != none) {
        Spawn(ImpactProjector,,,HitLocation + (20 * HitNormal) ,rotator(-HitNormal));
    }

}


/****************************************************************
 * ModifyDamage
 ****************************************************************
 */
function int ModifyDamage(vector Hitlocation, int DamageAmount){
   return ReduceForRange(Hitlocation, DamageAmount);
}


/****************************************************************
 * ReduceForRange
 ****************************************************************
 */
function int ReduceForRange(vector HitLocation, float inDamageAmount){

   local AdvancedPawn ThePawn;
   local vector HitDistance;
   local float DistancePastRange;
   local float WeaponRange;

   //   ThePlayer = AdvancedPlayerController(Level.GetLocalPlayerController());
   ThePawn = AdvancedPawn(Owner);
   WeaponRange = AdvancedWeapon(ThePawn.Weapon).EffectiveRange;

   //do bother, this weapon must use a different system
   if (WeaponRange == 0){
      return inDamageAmount;
   }

   //   HitDistance = HitLocation - ThePlayer.Pawn.Location;
   HitDistance = HitLocation - ThePawn.Location;
   DistancePastRange = Vsize(HitDistance) - WeaponRange;

   if (DistancePastRange > 0 ){
      //apply some reduction
      inDamageAmount = Max(0, inDamageAmount - inDamageAmount * (DistancePastRange/WeaponRange));

   }

   return inDamageAmount;
}



/****************************************************************
 * SpawnProjectile
 ****************************************************************
 */
function SpawnProjectile(vector Start, rotator Dir)
{
   local Projectile newProj;

   newProj = Spawn(ProjectileClass,,, Start,Dir);
   if (bUnderBotControl){
      newProj.SetPhysics(PHYS_Projectile);
   }
}


/*****************************************************************
 * SpawnProjectileEx
 * Exactly the same but better
 *****************************************************************
 */
function SpawnProjectileEx(vector Start, rotator Dir, Actor OwnedBy){
   local Projectile newProj;
   local int i;

   newProj = Spawn(ProjectileClass,OwnedBy,,Start,Dir);


   //you are spawing in a wall, so "bounce" off the wall and spawn behind the player
   for (i = 0; i<5; i++){
       if (newProj == none ){
            newProj = Spawn(ProjectileClass, OwnedBy,,Start - (vector(Dir) * i * 5), Dir);
            log("Spawn projectile" @ i @ start + (vector(Dir) * i * 5));
            if (newProj !=none){
                //play sound
                newProj.PlaySound(newProj.ImpactSound);
            }
       }
   }
   if (newProj != none){
        newProj.Velocity += OwnedBy.Velocity;
   }
}

/****************************************************************
 * HasAmmo
 ****************************************************************
 */
/*
simulated function bool HasAmmo()
{
      if (AmmoAmount > 0  ||
          (Level.GetLocalPlayerController() != none &&
          Level.GetLocalPlayerController().Pawn != None &&
          Level.GetLocalPlayerController().Pawn.Weapon != None &&
          Level.GetLocalPlayerController().Pawn.Weapon.ReloadCount > 0)){
         return true;
      }
}
*/

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     bDoesSpecialDamage=True
     MinTimeBetweenEffects=0.200000
     bTravel=False
}
