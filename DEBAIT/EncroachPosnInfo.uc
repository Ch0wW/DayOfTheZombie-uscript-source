// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * EncroachPosnInfo - why a whole class for what amounts to a struct?
 *     Because structs aren't passed by reference in UnrealScript.  :-(
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Dec 2003
 */
class EncroachPosnInfo extends Object;

var AdvancePosition  pos;
var VGSPAIController agent;
var bool             inPosition;

defaultproperties
{
}
