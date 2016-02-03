// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class DOTZMeleeAmmunition extends MeleeAmmunition;


var class<Emitter> PrimaryFleshImpact;
var class<Emitter> SecondaryFleshImpact;

/*****************************************************************
 * ProcessTraceHitOnMat
 *****************************************************************
 */
function ProcessTraceHitOnMat(Weapon W, Actor Other, Vector HitLocation,
                         Vector HitNormal, Vector X, Vector Y, Vector Z,
                         Material HitMaterial)
{
   //set the properties for this type of swing with a melee weapon
   //(i.e. different swings do different emitters)
   if (MeleeWeapon(Instigator.Weapon).bDoAltFire==true){
        if (SecondaryFleshImpact != none){
            ImpactFlesh = SecondaryFleshImpact;
        }
   } else {
        if (PrimaryFleshImpact !=None){
            ImpactFlesh = PrimaryFleshImpact;
        }
   }

   //Log(ImpactFlesh);

   Super.ProcessTraceHitOnMat(W,Other,HitLocation,HitNormal,X,Y,Z,HitMaterial);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AltDamageAmount=50
     StdDamageAmount=30
     ImpactEmitter=Class'BBParticles.BBPMeleeImpactBase'
     ImpactDirt=Class'BBParticles.BBPMeleeImpactDirt'
     ImpactFlesh=Class'BBParticles.BBPBlood'
     ImpactMetal=Class'BBParticles.BBPMeleeImpactMetal'
     ImpactPlant=Class'BBParticles.BBPMeleeImpactPlant'
     ImpactRock=Class'BBParticles.BBPMeleeImpactRock'
     ImpactWater=Class'BBParticles.BBPMeleeImpactWater'
     ImpactWood=Class'BBParticles.BBPMeleeImpactWood'
     ImpactIce=Class'BBParticles.BBPMeleeImpactIce'
     ImpactGlass=Class'BBParticles.BBPMeleeImpactGlass'
     MyDamageType=Class'DOTZEngine.DOTZBluntImpactDamage'
}
