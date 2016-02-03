// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AdvancedProjectile -
 *
 * The parent class of all projectiles. Pretty empty at this point,
 * just some examples of defaults you can override really.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 */
class AdvancedProjectile extends Projectile;

// effects settings
var class<Emitter> TrailEmitter;
var class<Emitter> ExplosionEmitter;
var class<emitter> BloodEmitter;


// internal
var Emitter trail;


/**
 */
simulated function PostNetBeginPlay () {
    super.PostNetBeginPlay();
    if ( TrailEmitter != None ) {
        trail = Spawn( TrailEmitter, self );
        trail.LifeSpan = 5.0;
        trail.SetBase( self );
    }
}

/**
 */
simulated function Destroyed () {
    local int i;

    if ( trail != None ) {
        // force the trail emitter to get cleaned up...
        for ( i = 0; i < trail.Emitters.Length; i++) {
            trail.Emitters[i].AutoDestroy = true;
        }
        trail.AutoDestroy = true;
        trail.AutoReset = false;
        trail.Kill();
    }
    Super.Destroyed ();
}


simulated function Touch(Actor Other){
   if (Other.IsA('Pawn') == true && Instigator != Pawn(Other)){
      Spawn(BloodEmitter,,,location);
   }
   Super.Touch(Other);
}



/*****************************************************************
 * Explode
 * Overridden to make it actually do damage by blowing up!
 *****************************************************************
 */
simulated function Explode(vector HitLocation, vector HitNormal)
{
   BlowUp(HitLocation);
   if (ExplosionEmitter != none){
      Spawn(ExplosionEmitter,,, location);
   }
   if (ImpactSound != None){
      PlaySound(ImpactSound);
   }

   Destroy();
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Speed=1500.000000
}
