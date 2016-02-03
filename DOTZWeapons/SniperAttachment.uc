// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * SniperAttachment -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class SniperAttachment extends AdvancedWeaponAttachment;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ThirdPersonMuzzleFlashClass=Class'BBParticles.BBPSniperRifleMuzzleFlash'
     TraceEmitterClass=Class'BBParticles.BBPMediumTracer'
     FireSound=Sound'DOTZXWeapons.Mixdown.MixdownRangedSniperRifleShoot'
     Mesh=SkeletalMesh'DOTZA3rdPersonWeapons.3PSniperRifle'
}
