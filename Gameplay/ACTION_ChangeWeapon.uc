// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_ChangeWeapon extends ScriptedAction;

var(Action) class<Weapon> NewWeapon;

function bool InitActionFor(ScriptedController C)
{
	C.Pawn.PendingWeapon = Weapon(C.Pawn.FindInventoryType(newWeapon));
	C.Pawn.ChangedWeapon();

	return false;	
}

defaultproperties
{
}
