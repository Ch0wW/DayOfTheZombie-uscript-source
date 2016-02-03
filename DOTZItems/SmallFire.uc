// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class SmallFire extends DOTZFire;

defaultproperties
{
     FlameEmitterClass=Class'BBParticles.BBPFireSmall'
     FadingEmitterClass=Class'BBParticles.BBPFireSmallFade'
     DamagePerSec=4
     FireBurnRadius=100
     FadeRate=15
     IgnitionTime=3
     ChildFireType=Class'DOTZItems.PawnFire'
}
