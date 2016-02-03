// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * RifleAttachment -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class RifleAttachment extends AdvancedWeaponAttachment;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ThirdPersonMuzzleFlashClass=Class'BBParticles.BBP22RifleMuzzleFlash'
     TraceEmitterClass=Class'BBParticles.BBPLightTracer'
     FireSound=Sound'DOTZXWeapons.Mixdown.MixdownRanged22RifleShoot'
     Mesh=SkeletalMesh'DOTZA3rdPersonWeapons.3P22Rifle'
}
