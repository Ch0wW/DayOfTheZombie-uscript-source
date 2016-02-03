// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * FrontAttackPoint - a trivial subclass with a unique icon (helpful for
 *                    debugging)
 *
 * @version $Rev: 5335 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Month 2004
 */
class FrontAttackPoint extends AttackPoint;

#exec texture Import File=Textures/FrontAttackPointIcon.tga Name=FrontAttackPointIcon Mips=Off MASKED=1

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Texture=Texture'AdvancedEngine.FrontAttackPointIcon'
}
