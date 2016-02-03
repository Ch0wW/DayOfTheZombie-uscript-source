// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * AttackPoint -
 *
 * @version $Rev: 5335 $
 * @author  Name (email@digitalextremes.com)
 * @date    Month 2004
 */
class AttackPoint extends Actor;

#exec texture Import File=Textures/AttackPointIcon.tga Name=AttackPointIcon Mips=Off MASKED=1

//===========================================================================
// Internal data
//===========================================================================
var bool bEnabled;


//===========================================================================
// Interface to bots...
//===========================================================================

/**
 */
function bool CanBeAttacked() {
    return bEnabled;
}

/**
 */
function vector GetAttackLocation() {
    return location;
}

/**
 */
function rotator GetAttackDirection() {
    return rotation;
}


//===========================================================================
// Interface for actors implementing Smashable.
//===========================================================================

/**
 * Activate
 */
function EnableMe(){
    bEnabled = true;
}


/**
 * Deactivate
 */
function DisableMe(){
    bEnabled = false;
}


//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     Texture=Texture'AdvancedEngine.AttackPointIcon'
}
