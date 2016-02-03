// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class AnimatedObject extends AdvancedActor
   implements( SaveHandler )
   placeable;

//displays a message and accepts user action input
var(events) name ActionEvent;

enum ACTIVATE_TYPE{
   TT_DAMAGED,
   TT_STARTS_ON,
   TT_STARTS_OFF
};

struct AnimInfo
{
   var() string AnimName;
   var bool bAdded;
   var MeshAnimation ObjRef;
};

var() ACTIVATE_TYPE ActivationType;
var() name AnimationName;
var() int AnimationRate;
var() array<AnimInfo> AdditionalAnimPkg;
var() int ShadowDistance;
var() bool bUseShadow;
var() bool bAnimationLoops;



//Events
var(Events) editconst Name hAnimateOn;
var(Events) editconst Name hAnimateOff;

//internals
var transient ShadowProjector FancyShadow;
var bool bAnimating;

/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
function PostBeginPlay(){
   local int i;
   CheckShadow();
   for (i=0; i< AdditionalAnimPkg.Length; i++){
      AddAnimationPackage(AdditionalAnimPkg[i].AnimName);
   }
   if ( ActivationType == TT_STARTS_ON){
      Animate(true);
   }
}

/*****************************************************************
 * TakeDamage
 *****************************************************************
 */
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                     Vector momentum, class<DamageType> damageType){
   super.TakeDamage(Damage, InstigatedBy, hitlocation, momentum,DamageType);
   if (ActivationType == TT_DAMAGED){
      Animate(true);
   }
}

/*****************************************************************
 * Animate
 *****************************************************************
 */
function Animate(bool bShouldAnimate){
   if (bShouldAnimate == true){
      bAnimating=true;
      if (bAnimationLoops){
         LoopAnim(AnimationName,AnimationRate);
      } else {
         PlayAnim(Animationname, AnimationRate);
      }
   } else {
      bAnimating=false;
      LoopAnim(AnimationName,0);
   }
}


/*****************************************************************
 * TriggerEx
 *****************************************************************
 */
function TriggerEx(Actor sender, Pawn instigator, name handler){
   switch(handler){
      case hAnimateOn:
         Animate(true);
      break;
      case hAnimateOff:
         Animate(false);
      break;
   }

}

/*****************************************************************
 * Called right before the game is saved.
 *****************************************************************
 */
function PreSave() {
   DestroyShadows();
}

/*****************************************************************
 * After saving is complete (broken).
 *****************************************************************
 */
function PostSave() {
   CheckShadow();

}


/*****************************************************************
 * PostLoad
 *****************************************************************
 */
function PostLoad() {
   local int i;
   super.PostLoad();
   for (i=0; i< AdditionalAnimPkg.Length; i++){
      AddAnimationPackage(AdditionalAnimPkg[i].AnimName, true);
   }
   Animate(bAnimating);

   CheckShadow();
}

/*****************************************************************
 * AddAnimationPackages
 * This method dynamically loads additional animation packages. If
 * the name of animations in the packages are distinct then the animations
 * are appended. If the name of the animations are identical than (seinsibly)
 * the last package loaded defines the behaviour of the animation.
 * PLEASE: make sure that the skeleton is the same for all packages used.
 *****************************************************************
 */
simulated function AddAnimationPackage(string AnimPackage, optional bool bForce){

    local MeshAnimation AdditionalAnims;
    local int i;

   if (AnimPackage == ""){
      return;
   }

    if (!bForce){
       //if you have added this then forget it;
       for (i=0; i<AdditionalAnimPkg.length; i++){
         if (AnimPackage == AdditionalAnimPkg[i].AnimName &&
             AdditionalAnimPkg[i].bAdded == true){
            return;
         }
       }
    }
    AdditionalAnims = MeshAnimation( DynamicLoadObject(AnimPackage,
                                            class'MeshAnimation') );
    if ( AdditionalAnims!= none ) {

       //update the list of animations you are linked to
       for (i=0; i<AdditionalAnimPkg.length; i++){
         if (AnimPackage == AdditionalAnimPkg[i].AnimName){
             AdditionalAnimPkg[i].bAdded = true;
             LinkSkelAnim( AdditionalAnims );
            // Log(self $ "The additional animation package: " $ AnimPackage $ " ADDED!");
             return;
         }
       }

        //trying to append the animations added to the complete list
        AdditionalAnimPkg.length = AdditionalAnimPkg.Length + 1;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].AnimName = AnimPackage;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].bAdded = true;
        AdditionalAnimPkg[AdditionalAnimPkg.length-1].ObjRef = AdditionalAnims;

        LinkSkelAnim( AdditionalAnims );
    }  else {
        Log(self $  "The additional animation package: " $ AnimPackage $ " is missing.");
    }
}


/*****************************************************************
 * CheckShadow
 *****************************************************************
 */
function CheckShadow() {
   DestroyShadows();
    if ( fancyShadow == none && bUseShadow == true) {
       FancyShadow = Spawn(class'AdvancedShadowProjector', self, '', location);
       FancyShadow.ShadowActor        = self;
       FancyShadow.LightDirection     = Normal(vect(0,0,1));
       FancyShadow.LightDistance      = 380;
       FancyShadow.MaxTraceDistance   = 350;
       FancyShadow.bBlobShadow        = false;
       FancyShadow.bShadowActive      = true;
       FancyShadow.bProjectOnUnlit    = true;
       FancyShadow.bProjectStaticMesh = false;
       FancyShadow.bProjectParticles  = false;
       FancyShadow.bProjectActor      = true;
       FancyShadow.InitShadow();
   }

}

/*****************************************************************
 * DestroyShadows
 *****************************************************************
 */
function DestroyShadows(){
   //if you were using a projector
   if (FancyShadow != None){
      FancyShadow.ShadowActor = none;
      FancyShadow.Destroy();
      FancyShadow = none;
   }
}

defaultproperties
{
     ActivationType=TT_STARTS_ON
     AnimationRate=1
     ShadowDistance=380
     bAnimationLoops=True
     hAnimateOn="ANIMATE_ON"
     hAnimateOff="ANIMATE_OFF"
}
