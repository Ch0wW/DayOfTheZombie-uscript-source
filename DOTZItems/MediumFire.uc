// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class MediumFire extends DOTZFire;

defaultproperties
{
     FlameEmitterClass=Class'BBParticles.BBPFireMedium'
     FadingEmitterClass=Class'BBParticles.BBPFireMediumFade'
     DamagePerSec=5
     FadeRate=15
     IgnitionTime=2
     ChildFireType=Class'DOTZItems.PawnFire'
}
