// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * GrenadePickup -
 *
 * @version $1.0$
 * @author  Jesse (Jesse@digitalextremes.com)
 * @date    Jan 2004
 *****************************************************************
 */
class AdvancedGrenadePickup extends AdvancedWeaponPickup;

var localized string FullAmmoMessage;
const TEMPNOACTIONTIMER = 22;

var class<Ammunition> GrenadeAmmunitionClass;
var int PickupAmmoAmount;

/*****************************************************************
 * DoEquip
 *****************************************************************
 */
auto state Pickup{
   function DoEquip(actor Other){

      local Ammunition grenammo;
      local Weapon grenWeapon;
      local pawn otherPawn;
      local Inventory Copy;

      //can't pick up grenade pickup if you are full of grenades
      Grenammo = Ammunition(Pawn(Other).
         FindInventoryType(GrenadeAmmunitionClass));

      GrenWeapon = Weapon(Pawn(Other).
         FindInventoryType(InventoryType));

      //if you have a weapon and full ammo ... bail
      if (GrenWeapon != none && GrenAmmo != none &&
          Grenammo.AmmoAmount >= GrenAmmo.MaxAmmo) {
           SetMultiTimer(TEMPNOACTIONTIMER, 2, false);
           iActionablePriority = 0;
           return;
      }


      if (bPickedUpHack == true){
         return;
      }

      if( AdvancedValidTouch(Other)==true ){
         bPickedUpHack = true;
         otherPawn = Pawn(other);
         if ( other == None ) return;

         //add the weapon if none, otherwise just ammo
         if (GrenWeapon == none){
             otherPawn = Pawn(other);
             if ( other == None ) return;
             Copy = SpawnCopy(otherPawn);
             AnnouncePickup(otherPawn);
             OverrideAmmoCounts(otherPawn);
             if ( Copy != None ) Copy.PickupFunction(otherPawn);
             SetRespawn();
             SimDestroy();
         } else if (Grenammo.AmmoAmount < GrenAmmo.MaxAmmo) {
            grenammo.AddAmmo(PickupAmmoAmount);
            SetRespawn();
            SimDestroy();
         }
      }
    }
}

function MultiTimer(int ID){
    if (ID == TEMPNOACTIONTIMER){
      if (bPickedUpHack !=true){
        iActionablePriority = default.iActionablePriority;
      }
    }
    super.MultiTimer(ID);
}



/*****************************************************************
 * GetActionableMessage
 *****************************************************************
 */
function string GetActionableMessage(Controller C){
   local AdvancedPlayerController thePlayer;
   local AdvancedPawn thePawn;
   local Ammunition GrenAmmo;
   local Weapon GrenWeapon;

   thePlayer = AdvancedPlayerController(C);
   if (thePlayer == None){
      return "";
   }

   thePawn = AdvancedPawn(thePlayer.Pawn);
   if (thePawn == None){
      return "";
   }

   if (bPickedUpHack == true){
      return "";
   }

        //@@@ removed the render check because this object might be visible
    // on the client in MP and that will not update the render time, the net
    // result being that the server would need to be looking at this pickup for
    // a client to be able to pick it up
    //if (level.TimeSeconds - LastRenderTime > 0.5 ){
      //  return "";
    //}

    //can't pick up ammo if you are full
    GrenAmmo = Ammunition(thePawn.FindInventoryType(GrenadeAmmunitionClass));
    GrenWeapon = Weapon(thePawn.FindInventoryType(InventoryType));

    if ( GrenWeapon!= none && GrenAmmo != none &&
        GrenAmmo.AmmoAmount >= GrenAmmo.MaxAmmo)
    {
        return FullAmmoMessage;
    }

   return ActionPickupMessage;
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     FullAmmoMessage="Can't carry more grenades"
     PickupAmmoAmount=2
     ActionPickupMessage="Press Action to take the grenades"
     MaxDesireability=0.750000
     PickupMessage="You got the Grenades"
     DrawType=DT_StaticMesh
}
