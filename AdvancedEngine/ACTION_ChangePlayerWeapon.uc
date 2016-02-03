// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class ACTION_ChangePlayerWeapon extends ScriptedAction;

var(Action) class<Weapon> NewWeapon;

function bool InitActionFor(ScriptedController C)
{
//	C.Level.GetLocalPlayerController().Pawn.PendingWeapon = Weapon(C.Level.GetLocalPlayerController().Pawn.FindInventoryType(newWeapon));
//	C.Level.GetLocalPlayerController().Pawn.ChangedWeapon();
      /*
   local inventory inv, best;
   inv = C.Pawn.inventory;
    //reset you pending weapon
    while(inv !=None){
        if (Weapon(inv) != none){
            if (Best == none ||
                RateWeapon(Weapon(inv)) > RateWeapon(Weapon(best))){
                if (Weapon(inv).HasAmmo()){
                    Best = inv;
                }
            }
        }
        inv = inv.inventory;
    }
        */
    C.Level.GetLocalPlayerController().ClientSetWeapon(NewWeapon);

	return false;
}

defaultproperties
{
}
