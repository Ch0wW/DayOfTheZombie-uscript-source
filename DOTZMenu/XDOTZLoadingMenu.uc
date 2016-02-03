// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for Desert Thunder, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #3 $
 * @date    Sept 2003
 */
class XDOTZLoadingMenu extends XDOTZPageBase;



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
   // init my components...
    if (Frand() > 0.5){
        Background = AltBackground;
    }

   PlayerOwner().ConsoleCommand("STOPMUSIC");
   PlayerOwner().ConsoleCommand("STOPSOUNDS");

   // Make sure rumble is stopped
   class'UtilsXbox'.static.Stop_Rumble();
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
    super.Opened(Sender);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);

   Log("Closeed the loading menu man, so long sucker, see you some other time");
   Controller.MouseEmulation(false);
}

/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */
function bool HandleKeyEvent(out byte Key,out byte State,float delta) {
    //@@@ need to do something about the button-skipping problem here?
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
         WinTop=0.095000
         WinLeft=0.155000
         WinWidth=0.800000
         WinHeight=0.100000
         RenderWeight=0.900000
         Name="Loading_control"
     End Object
     LoadingMsgBox=GUILabel'DOTZMenu.XDOTZLoadingMenu.Loading_control'
     Begin Object Class=GUILabel Name=Fact_control
         FocusedTextColor=(B=255)
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
     FactMsgBox=GUILabel'DOTZMenu.XDOTZLoadingMenu.Fact_control'
     facts(0)="Scientists believe the undead can smell living human flesh from up to a mile away."
     facts(1)="Although the living dead will devour any part of the human body, they especially crave fresh brains."
     facts(2)="The walking dead are driven solely by primal human instincts, mainly hunger."
     facts(3)="The recently deceased have the capacity to learn basic tasks. Some may even appear to have limited cognitive abilities."
     facts(4)="The awakened dead remember parts of their living experiences and will attempt to re-enact them, almost by habit."
     facts(5)="Flesh eaters will, for the most part, ignore other flesh eaters."
     facts(6)="The ever hungry can learn to use weapons after a lot of trial and error."
     facts(7)="Re-animated corpses are no longer your parent, sibling, co-worker or friend. They are horrible monsters that must be destroyed."
     facts2(0)="Chuck a Molotov cocktail at those creatures to slow them; throw it near their feet and watch them burst into flames!"
     facts2(1)="Try to remain silent and out of sight; stagnant corpses will wander aimlessly until they hear or see you."
     facts2(2)="The fastest way to kill stale skins is to destroy the brain. A clean head shot with a powerful weapon is all it takes."
     facts2(3)="Use melee weapons in close quarters to conserve ammunition."
     facts2(4)="Be sure to search desks, cabinets and lockers. Caches of health and ammo can be found there."
     facts2(5)="Always close doors behind you. Although the withered will eventually break through, this slows them down significantly and lets you hear them coming."
     facts2(6)="Not only does shooting off the soulless walkers' legs slow them down, it is a heck of a good time!"
     facts2(7)="Shooting off a flesh feaster's arms makes him a lot less dangerous. Watch out though, he can still bite!"
     facts3(0)="Crawlers are especially dangerous because they attack your tender, juicy mid section. Kill them before they kill you."
     facts3(1)="Beware - dead heads with weapons are extra dangerous and difficult to kill."
     facts3(2)="The secondary melee attack is slow but can knock down those things, buying you precious seconds to escape."
     facts3(3)="Use the three zoom levels on the sniper rifle for better accuracy."
     facts3(4)="The axe can chop off the unburied's head with just one swing."
     facts3(5)="The hammer is very light, making it ideal for rapid pummeling of the once human."
     facts3(6)="The golf club is the longest of the melee weapons. Use it to club bloodless wretches from a distance."
     facts3(7)="The lead pipe is heavy but delivers a painfully powerful blow."
     facts4(0)="Although you can knock down the recently expired with your fists, it does them absolutely no harm."
     facts4(1)="The shotgun is great for close encounters, but useless at a distance."
     facts4(2)="The glock is a rapid fire semi-automatic. You can quickly throw a lot of lead from this little gun."
     facts4(3)="The revolver has a lot of stopping power. It can blow off limbs with a single shot."
     facts4(4)="Use the dash to get away from dangerous situations, but beware – you'll eventually run out of breath, slowing you down significantly."
     facts4(5)="You can only carry one melee weapon at a time."
     AltBackground=Texture'DOTZTInterface.Load.Loading2'
     Background=Texture'DOTZTInterface.Load.1Load'
     bAllowedAsLast=True
     WinHeight=1.000000
     __OnKeyEvent__Delegate=XDOTZLoadingMenu.HandleKeyEvent
}
