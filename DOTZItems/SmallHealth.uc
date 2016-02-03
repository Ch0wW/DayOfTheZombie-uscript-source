// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/****************************************************************
 * HealthPack
 *
 * Things that you should touch to "get". They can be turned on and
 * look special.
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 ****************************************************************
 */
class SmallHealth extends AdvancedHealthPack
placeable;



//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     HealthAmount=10.000000
     HealSound=Sound'DOTZXInterface.PickupHealthSmall'
     StaticMesh=StaticMesh'DOTZSSpecial.Pickups.SmallHealth'
     CollisionRadius=10.000000
     CollisionHeight=15.000000
}
