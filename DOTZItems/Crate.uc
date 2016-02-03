// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Crate extends PushableObject
placeable;

var Fire FireActor;
var StaticMesh BurntMesh;
var bool bBurnt;
var() class<Fire> FireType;

/****************************************************************
 * PostBeginPlay
 ****************************************************************
 */
function PostBeginPlay(){
   Super.PostBeginPlay();

   FireActor = Spawn(FireType,none,'',location + vect(0,0,60));
   FireActor.bDamageEnabled = false;
   FireActor.bSourceFades = true;
   FireActor.bStartsEnabled = false;
   FireActor.SetBase(self);
}

/****************************************************************
 * TakeDamage
 ****************************************************************
 */
function TakeDamage( int Damage,Pawn instigatedBy,Vector hitlocation,
                     Vector momentum, class<DamageType> damageType ) {


   Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

   if (FireActor != None && bBurnt == false){
      FireActor.CreateFire();
      SetStaticMesh(BurntMesh);
      bBurnt = true;
   }
}

defaultproperties
{
     BurntMesh=StaticMesh'DOTZSIndustrial.Outdoor.WoodenBox'
     FireType=Class'DOTZItems.SmallFire'
     ActionMsg="Press Action to push crate"
     iMinimumWallDistance=100
     SlidingSound=Sound'DOTZXActionObjects.Crate.CratePush'
     KickedSound=Sound'DOTZXActionObjects.Crate.CrateKick'
     StaticMesh=StaticMesh'DOTZSIndustrial.Outdoor.WoodenBox'
}
