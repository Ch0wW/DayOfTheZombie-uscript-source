// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Smashable - interface for things that bots can smash to get through.
 *
 * @version $Rev: 5335 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    July 2004
 */
class Smashable extends Object
   abstract
   interface;

/**
 * Returns a reference to the object's attack point, which contains
 * hints for how to smash through this obstacle.  Returns None if the
 * object can't be attacked.
 */
function AttackPoint getAttackPoint( Actor attacker );

/**
 * Returns a reference to the actor being smashed.  Useful for aiming things
 * at it.
 */
function Actor getSmashActor();

/**
 * Called each time a bot tries to smash the object.
 * (actually, right now called when the bot gives up, and just needs the object
 * to go away)
 *
 * @returns true if the object has been destroyed, false otherwise.
 */
function bool doSmash( Pawn instigator );

defaultproperties
{
}
