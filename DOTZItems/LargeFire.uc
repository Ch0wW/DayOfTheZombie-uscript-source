// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class LargeFire extends DOTZFire;

defaultproperties
{
     FlameEmitterClass=Class'BBParticles.BBPFireLarge'
     FadingEmitterClass=Class'BBParticles.BBPFireLargeFade'
     DamagePerSec=6
     FireBurnRadius=200
     FadeRate=15
     IgnitionTime=1
     ChildFireType=Class'DOTZItems.PawnFire'
}
