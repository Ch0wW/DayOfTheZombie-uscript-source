// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class FireAxeAmmunition extends DOTZMeleeAmmunition;

defaultproperties
{
     PrimaryFleshImpact=Class'BBParticles.BBPBloodAxePrimary'
     SecondaryFleshImpact=Class'BBParticles.BBPBloodAxeSecondary'
     AltDamageAmount=100
     StdDamageAmount=55
     AltMomentumDir=(X=-1.000000)
     MyDamageType=Class'DOTZEngine.DOTZSharpImpactDamage'
}
