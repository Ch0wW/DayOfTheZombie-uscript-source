// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZUmover - All the DOTZAI specific stuff is in here.
 *
 * @version $Revision: #2 $
 * @author  Jesse (jesse@digitalextremes.com)
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    June 2004
 */
class DOTZDestructableMesh extends DestructableMesh
   implements( Smashable );

var(DestructableMesh) Vector AttackLocation;
var(DestructableMesh) bool bShowAttackPoint;

var AttackPoint MyAttackPoint;


//===========================================================================
// Smashable interface
//===========================================================================

/**
 */
function AttackPoint getAttackPoint( Actor a ) {
    if ( MyAttackPoint != None && MyAttackPoint.bEnabled ) {
        return MyAttackPoint;
    }
    else return None;
}

/**
 */
function Actor GetSmashActor() {
    return self;
}

/**
 */
function bool DoSmash( Pawn instigator ) {
    if (DamageCapacity > 0){
        TakeDamage( 100, instigator, location, vect(0,0,0), class'SmashDamage' );
    }
    return (DamageCapacity <= 0);
}


//===========================================================================
//
//===========================================================================

/*****************************************************************
 * PostBeginPlay
 * Drop an attackpoint so the bots will know what they can break
 *****************************************************************
 */
function PostBeginPlay(){
   BecomeAttractive();
}

/*****************************************************************
 * BecomeAttractive
 * Sorry Neil, this won't help you!
 *****************************************************************
 */
function BecomeAttractive(){
   local vector adjustment;
   adjustment = ( AttackLocation >> rotation) + location;

   if (MyAttackPoint == None){
      MyAttackPoint = Spawn(class'AttackPoint',,,adjustment);
   }
   if (MyAttackPoint!=None){
      MyAttackPoint.EnableMe();
      MyAttackPoint.bHidden = !bShowAttackPoint;
   }
}


/*****************************************************************
 * DisableAttraction
 *****************************************************************
 */
function DisableAttraction(){
   if (MyAttackPoint !=None){
      MyAttackPoint.DisableMe();
   }
}


/*****************************************************************
 * BlowUp
 *****************************************************************
 */
function Blowup(){
    Super.BlowUp();
    MyAttackPoint.DisableMe();
}


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     AttackLocation=(X=32.000000,Y=-50.000000,Z=50.000000)
     bWorldGeometry=True
}
