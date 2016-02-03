// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AdvancedMaterialTrigger extends MaterialTrigger
implements(SaveHandler);


var bool bTriggered;
var Actor TriggerActor;
var Pawn TriggerInstigator;

/*****************************************************************
 * Reset
 *****************************************************************
 */
function Reset(){
	local int i;
	//super.PreSave();
	for( i=0;i<MaterialsToTrigger.Length;i++ )
	{
		if( MaterialsToTrigger[i] != None )
			MaterialsToTrigger[i].Reset();
	}

}

/*****************************************************************
 * PreSave
 * reset the materials because they do not save if they have
 * been triggered
 *****************************************************************
 */
function PreSave(){
    Reset();
}

/*****************************************************************
 * PostSave
 * Call super so you ONLY do the material swap,
 * not the state change in our own trigger method
 *****************************************************************
 */
function PostSave(){
    //super.PostSave();
    Reset();
    if (bTriggered == true){
        super.Trigger(TriggerActor, TriggerInstigator);
    }
}

/*****************************************************************
 * PostLoad
 * Call super so you ONLY do the material swap,
 * not the state change in our own trigger method
 *****************************************************************
 */
function PostLoad(){
    super.PostLoad();
    reset();
    if (bTriggered == true){
        super.Trigger(TriggerActor, TriggerInstigator);
    }
}

/*****************************************************************
 * Trigger
 * set you trigger data for later when you retrigger on the
 * postload/postsave
 *****************************************************************
 */
function Trigger(Actor Other, Pawn EventInstigator){

    super.trigger(Other, EventInstigator);

    TriggerActor = Other;
    TriggerInstigator = EventInstigator;
    bTriggered = !bTriggered;
}

defaultproperties
{
}
