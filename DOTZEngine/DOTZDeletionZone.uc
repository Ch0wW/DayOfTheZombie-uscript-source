// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZDeletionZone extends ZoneInfo;

var() bool bAutoDeletion;

var(Events) const editconst Name hDeleteActors;

/*****************************************************************
 * ActorLeaving
 *****************************************************************
 */
function ActorLeaving(actor Other){
    if (bAutoDeletion == true && Other.IsA('HumanPawn')){
        DeleteActors();
    }
}

/*****************************************************************
 * Trigger
 *****************************************************************
 */
function Trigger(Actor Other, Pawn EventInstigator){
    DeleteActors();
}

/*****************************************************************
 * TriggerEx
 *****************************************************************
 */
function TriggerEx(Actor Other, Pawn Instigator, name Handler){

    switch (handler){
    case hDeleteActors:
        DeleteActors();
        break;
   }
   Super.TriggerEx(Other,Instigator,handler);
}

/*****************************************************************
 * DeleteActors
 *****************************************************************
 */
function DeleteActors()
{
    local actor temp;
    local emitter temp2;

    foreach ZoneActors(class'actor', temp){
        if ( temp.Region.Zone == self.Region.Zone &&
            !temp.IsA('HumanPawn') &&
            !temp.IsA('PlayerController') &&
            !temp.IsA('Inventory') &&
            !temp.IsA('WeaponAttachment') &&
            !temp.IsA('HUD') &&
            !temp.IsA('Info') &&
            !temp.IsA('AdvancedSubtitleMgr') &&
            !temp.IsA('ObjectivesManager')){
           temp.Destroy();
           log("Deleting : " $ temp);
        }
    }

   //seems not everything is listed in ZoneActors
	foreach DynamicActors(class'Emitter', temp2){
      if (temp2.Region.Zone == self.Region.Zone){
			temp2.Destroy();
         log("Deleting : " $ temp2);
      }
   }


}


//-----------------------------------------------------------
//
//-----------------------------------------------------------

defaultproperties
{
     hDeleteActors="DELETE_ACTORS"
     bStatic=False
     bHasHandlers=True
}
