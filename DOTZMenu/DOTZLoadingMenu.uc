// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for Desert Thunder, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #4 $
 * @date    Sept 2003
 */
class DOTZLoadingMenu extends DOTZPageBase;



var Automated GUILabel LoadingMsgBox;
var Automated GUILabel FactMsgBox;

var const localized array<string> facts;
var const localized array<string> facts2;
var const localized array<string> facts3;
var const localized array<string> facts4;

var Material AltBackground;

 /*****************************************************************
  * InitComponent
  *****************************************************************
  */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
    Log(self $ "InitComponent");
    if (Frand() > 0.5){
        Background = AltBackground;
        }
   // init my components...

}


/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the menu to load
 * Param2 - the name of the sub menu to load on top of the first menu
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

    local texture test;
    local float factrange;
    local int temp;

   Log(self $ " test " $ param1 $ " " $ param2);


    if (param1 != ""){
        LoadingMsgBox.Caption = param1;

    }
    if (param2 != ""){

        test = texture( FindObject(param2,class'Texture'));
        if (test != none){
            Background = test;
        }
    }

    factrange = int(FRand() * 3);
    switch(factrange){
      case 0:
         FactMsgBox.Caption = facts[FRand() * facts.Length];
         break;
      case 1:
         FactMsgBox.Caption = facts2[FRand() * facts2.Length];
         break;
      case 3:
         FactMsgBox.Caption = facts3[FRand() * facts3.Length];
         break;
      case 4:
         FactMsgBox.Caption = facts4[FRand() * facts4.Length];
         break;
      default:
         temp = facts.length;
         FactMsgBox.Caption = facts[FRand() * facts.Length];
         break;
    }

}

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   super.opened(Sender);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);

    Log(self $ "Closed");
   //Controller.MouseEmulation(false);
}

/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */
function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    //@@@ need to do something about the button-skipping problem here?
    //Log(self $ "HandleKeyEvent");
   return true;
}


/*****************************************************************
 * NotifyLevelChange
 *
 *****************************************************************
 */
event NotifyLevelChange() {
   Controller.CloseMenu(true);
}



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=GUILabel Name=Loading_control
         StyleName="BBXSquareButton"
         WinTop=0.097000
         WinLeft=0.155000
         WinWidth=0.800000
         WinHeight=0.100000
         RenderWeight=0.900000
         Name="Loading_control"
     End Object
     LoadingMsgBox=GUILabel'DOTZMenu.DOTZLoadingMenu.Loading_control'
     Begin Object Class=GUILabel Name=Fact_control
         TextFont="PlainMedGuiFont"
         bMultiLine=True
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.150000
         WinWidth=0.700000
         WinHeight=0.800000
         RenderWeight=0.900000
         Name="Fact_control"
     End Object
     FactMsgBox=GUILabel'DOTZMenu.DOTZLoadingMenu.Fact_control'
     facts(0)="For best results, try using the shotgun close up."
     facts(1)="A zombie with no limbs is still a hungry zombie."
     facts(2)="Running out of ammo? Try using melee weapons to get around single zombies."
     facts(3)="Keep an eye out for health packs."
     facts(4)="Not all melee weapons are created equal, try new ones."
     facts(5)="Set yourself on fire? Find some water to put yourself out."
     facts(6)="Facing a group of zombies? Look for some explosive barrels to take them all out at once."
     facts(7)="To destroy a zombie more efficiently, aim for the head."
     facts2(0)="Have you found all the kung fu fists?"
     facts2(1)="A well aimed shot will sever a zombie's limbs."
     facts2(2)="Contrary to popular belief zombies can be killed without destroying the brain, if you can hack them up enough."
     facts2(3)="Zombies will attack by tearing at your flesh, or by biting if they don't have any arms."
     facts2(4)="Keep an eye out for ammo, there's bound to be some in hidden caches."
     facts2(5)="Zombies will bust through wooden doors, but closing doors can buy you precious time to escape."
     facts2(6)="Zombie's are relentless. Blowing off a zombie's legs will only slow them down."
     facts2(7)="Some zombies will puke infectious vomit. The effects are temporary...if it doesn't kill you."
     facts3(0)="Some zombies will explode. It's gross, so try to avoid it."
     facts3(1)="Zombies with weapons are the toughest to kill."
     facts3(2)="Attacks that knock zombies down also do less damage."
     facts3(3)="The axe is the only melee weapon that can sever a zombie's limb."
     facts3(4)="The lead pipe is slow, but incredibly powerful."
     facts3(5)="You can run short distances, you breath heavier as you get tired out."
     facts3(6)="The golf club has the longest range of any melee weapon."
     facts3(7)="Hogarth Morten is the janitor of Fencott college. He is not a stable person."
     facts4(0)="Johnny Anderson had only a few months until graduation before the plague hit."
     facts4(1)="Have you played on-line yet? The invasion game type is cooperative. You versus zombies."
     facts4(2)="Sgt. Daniel Travis was part of an elite special forces team sent to contain the infection. They failed."
     facts4(3)="Burning a zombie takes a long time, and it can't smell good either."
     facts4(4)="Zombies are attracted to noise. Shooting you weapon is a good way to alert zombies to your presence."
     AltBackground=Texture'DOTZTInterface.Load.Loading2'
     Background=Texture'DOTZTInterface.Load.1Load'
     bAllowedAsLast=True
     WinHeight=1.000000
     __OnKeyEvent__Delegate=DOTZLoadingMenu.HandleKeyEvent
}
