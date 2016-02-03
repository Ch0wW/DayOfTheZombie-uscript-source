// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * MolotovWeapon - a pseudo-weapon for throwing Molotovs by hand.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class MolotovWeapon extends DOTZGrenadeWeapon
    config(user);

// Manually tune to be in-synch w/ throw anim.  See also FireOffset.
var() float SpawnDelay;

// internal...
var private Rotator SpawnDir;
var private Vector  SpawnLocn;
const SPAWN_DELAY_TIMER = 4382;


/**
 * A quick hack, since the default props don't seem to be sticking.
 */
function BeginPlay() {
    super.BeginPlay();
    default.staticReticule = none;
    StaticReticule = none;
}


/*****************************************************************
 * Fire
 * Overridden so you can't use Molotov cocktails underwater
 *****************************************************************
 */
simulated function Fire(float Value){
    if ( class'ExtinguishVolume' != Instigator.PhysicsVolume.class &&
         class'MovingExtinguishVolume' != Instigator.PhysicsVolume.class &&
        class'WaterVolume' != Instigator.PhysicsVolume.class){
        super.Fire(Value);
    }
}


/*****************************************************************
 * SpawnProjectile
 *****************************************************************
 */
function SpawnProjectile(){
  local Vector Start, X,Y,Z;

   Owner.MakeNoise(1.0);
   GetAxes(Instigator.GetViewRotation(),X,Y,Z);
   Start = GetFireStart(X,Y,Z);
   AdjustedAim = Instigator.AdjustAim(AmmoType, Start, AimError);
   // all timer for the animation to get to the release point before
   // spawning...
   SpawnDir = AdjustedAim;
   SpawnLocn = start;
   DOTZAmmunitionBase(AmmoType).SpawnProjectileEx( SpawnLocn, SpawnDir ,Owner);
}

/**
 * Replaces default weapon behaviour so that projectile is spawned
 * during the fire animation (instead of before).
 */
function ProjectileFire()
{
      SetMultiTimer( SPAWN_DELAY_TIMER, spawnDelay, false );
}

/*****************************************************************
 * Notify_SpawnProjectile
 * Called from the animation to let us know the best point to release the cocktail
 *****************************************************************
 */
function Notify_SpawnProjectile(){
        SpawnProjectile();

}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     SpawnDelay=2.000000
     PawnAnimationPackage="DOTZAHumans.3PMolotovCocktail"
     FireAnimName="MolotovCocktailFire"
     StandIdleAnimName="MolotovCocktailStandIdle"
     CrouchIdleAnimName="MolotovCocktailCrouchIdle"
     HitAnimName="MolotovCocktailHit"
     WeaponMode=WM_Single
     bCanDamageSelf=True
     HitSpread=0.000000
     OfficialName="Molotov Cocktail"
     AmmoName=Class'DOTZWeapons.MolotovAmmunition'
     PickupAmmoCount=2
     ReloadCount=1
     AutoSwitchPriority=-1
     FireOffset=(X=25.000000,Y=40.000000,Z=45.000000)
     InventoryGroup=8
     PickupClass=Class'DOTZWeapons.MolotovPickup'
     AttachmentClass=Class'DOTZWeapons.MolotovAttachment'
     ItemName="Molotovs"
     Mesh=SkeletalMesh'DOTZAWeapons.MolotovCocktail'
}
