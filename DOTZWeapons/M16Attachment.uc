// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * M16Attachment -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class M16Attachment extends AdvancedWeaponAttachment;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ThirdPersonMuzzleFlashClass=Class'BBParticles.BBPM16MuzzleFlash'
     TraceEmitterClass=Class'BBParticles.BBPMediumTracer'
     FireSound=Sound'DOTZXWeapons.Ranged.RangedM16Shoot'
     Mesh=SkeletalMesh'DOTZA3rdPersonWeapons.3PM16'
}
