// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ShotgunAttachment -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Nov 2003
 *****************************************************************
 */
class ShotgunAttachment extends AdvancedWeaponAttachment;

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ThirdPersonMuzzleFlashClass=Class'BBParticles.BBPShotgunMuzzleFlash'
     FireSound=Sound'DOTZXWeapons.Mixdown.MixdownRangedShotgunShoot'
     Mesh=SkeletalMesh'DOTZA3rdPersonWeapons.3PShotgun'
}
