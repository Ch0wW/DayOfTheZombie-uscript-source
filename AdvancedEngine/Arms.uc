// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Arms extends Inventory
     implements (HudDrawable);

var int DisplayFOV;

//var AdvancedHud myHud;

/*****************************************************************
 * RegisterWithHud
 *****************************************************************
 */
//function RegisterWithHud(AdvancedHud TheHud){
// MyHud = theHud;
//   MyHud.register(self);
//}


/*****************************************************************
 * DrawToHud
 *****************************************************************
 */
function DrawToHud( Canvas c, float scaleX, float scaleY ) {

   local rotator NewRot;

    // render the weapon first, so that the indicators will get drawn
    // over it.
   //    if (Level.GetLocalPlayerController().Pawn.IsFirstPerson()){
   if (bHidden == false){
       SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
       NewRot = Instigator.GetViewRotation();
       SetRotation(NewRot);
       C.DrawActor(self,false,true,DisplayFOV);
       //}
   }

}

/*****************************************************************
 * DrawDebugToHud
 *****************************************************************
 */
function DrawDebugToHud( Canvas canvas, float scaleX, float scaleY );



function Animend(int channel){
   AdvancedPawn(Instigator).ArmAnimEnd();
   super.animend(channel);
}

defaultproperties
{
     DisplayFOV=60
     PlayerViewOffset=(X=20.000000,Y=4.000000,Z=-17.000000)
     DrawType=DT_Mesh
}
