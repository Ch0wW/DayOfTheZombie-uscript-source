// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MolotovProjectile -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class MolotovProjectile extends DOTZProjectileBase;

var class<fire> FireActor;
var class<fire> SmallFireActor;
var StaticMesh unBurningMesh;

/*****************************************************************
 * PostBeginPlay
 * Give your newly spawned projectile a velocity
 *****************************************************************
 */
function PostBeginPlay()
{
   local vector Dir;

   //Give your projectile a velocity
   Dir = vector(Rotation);
   velocity = (speed * Dir) + owner.velocity;
   LocalRandSpin(12000);
   if (abs(RotationRate.Pitch)<10000){RotationRate.Pitch=10000;}
   if (abs(RotationRate.Roll)<10000) {RotationRate.Roll=10000;}
   Super.PostBeginPlay();
}

/*****************************************************************
 * RandSpin
 *****************************************************************
 */
function LocalRandSpin(float spinRate)
{
   DesiredRotation = RotRand();
   RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
   RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
   RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
}

/*****************************************************************
 * Explode
 *****************************************************************
 */
function Explode(vector hitLocation, vector hitnormal){
    local Fire MyFire, MyFire2;
    local int i, randy, randx;

     if ( class'ExtinguishVolume' == PhysicsVolume.class ||
         class'MovingExtinguishVolume' == PhysicsVolume.class ||
        PhysicsVolume.IsA('WaterVolume')){
        return;

    }

    super.Explode(hitlocation, hitnormal);
    MyFire = Spawn(FireActor,,,hitlocation);
    MyFire.bFadeWhenBaseDestroyed = false;
    MyFire.bSourceFades = true;
    MyFire.DamagePerSec = 12;
    MyFire.IgnitionTime = 0;
   // MyFire.ChildFireType = class'DOTZItems.MediumFire';
    MyFire.CreateFire();


     for (i=0;i<4;i++){
        randy = Frand() * 500 - 250;
        randx = Frand() * 500 - 250;

        MyFire2 = Spawn(SmallFireActor,,,hitlocation);
        MyFire2.bFadeWhenBaseDestroyed = false;

        MyFire2.FadeStep = 5;
        MyFire2.IgnitionTime = 0;
        MyFire2.DamagePerSec = 8;
        MyFire2.bSourceFades = true;
     //   MyFire2.ChildFireType = class'DOTZItems.MediumFire';

        MyFire2.bCollideWorld = true; //so you don't fall into
                                    //the world and screw yourself right up
        MyFire2.Velocity.Z = 800;
        MyFire2.Velocity.Y = randx;
        MyFire2.Velocity.X = randy;

        MyFire2.SetPhysics(PHYS_Falling);
        MyFire2.CreateFire();

     }
}

/*****************************************************************
 * Landed
 *****************************************************************
 */
simulated function Landed( vector HitNormal ){
    if (PhysicsVolume.class == class'ExtinguishVolume' ||
        PhysicsVolume.class == class'MovingExtinguishVolume'){
      HitWall( HitNormal, none );
    } else {
      Explode(Location,  vect(0,0,1));
    }
}

/*****************************************************************
 * HitWall
 *****************************************************************
 */
simulated function HitWall(vector HitNormal, actor Wall){

   if (PhysicsVolume.class == class'ExtinguishVolume' ||
       PhysicsVolume.class == class'MovingExtinguishVolume'){
       Velocity = 0.4*((Velocity dot HitNormal) * HitNormal * -2 + Velocity);
       speed = VSize(Velocity);
       if ( Velocity.Z > 400 )
          Velocity.Z = 0.5 * (400 + Velocity.Z);
       else if ( speed < 20 )
       {
          bBounce = False;
          SetPhysics(PHYS_None);
       }
   } else {
        super.HitWall(HitNormal, Wall);
   }
//   PlaySound(BounceSound);
}


event PhysicsVolumeChange( PhysicsVolume NewVolume ){

    local emitter temp;

    if ( class'ExtinguishVolume' == NewVolume ||
         class'MovingExtinguishVolume' == NewVolume ||
        NewVolume.Isa('WaterVolume')){
            SetStaticMesh(UnBurningMesh);
    }

    foreach basedactors(class'Emitter', temp){
        temp.destroy();
    }

    super.PhysicsVolumeChange( NewVolume);
}

/**
 */
function ProcessTouch(Actor Other, Vector HitLocation) {}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     FireActor=Class'DOTZItems.MedMolotovFire'
     SmallFireActor=Class'DOTZItems.SmallMolotovFire'
     unBurningMesh=StaticMesh'DOTZSWeapons.Ranged.MolotovCocktailProjectile'
     TrailEmitter=Class'BBParticles.BBPMolotovTrail'
     ExplosionEmitter=Class'BBParticles.BBPMolotovImpact'
     Damage=90.000000
     DamageRadius=400.000000
     MomentumTransfer=80000.000000
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DOTZSWeapons.Ranged.MolotovCocktailProjectile'
     bBounce=True
     bFixedRotationDir=True
     bRotateToDesired=True
     LifeSpan=5.000000
}
