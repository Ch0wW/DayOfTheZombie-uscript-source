// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * DOTZMainMenu - the main menu for Desert Thunder, based on the Warfare
 *              "GUI" package.
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class DOTZESRBMenu extends DOTZPageBase;




 /*****************************************************************
  * InitComponent
  *****************************************************************
  */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);

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

   Log(self $ " test " $ param1 $ " " $ param2);


    if (param1 != ""){

        test = texture( FindObject(param2,class'Texture'));
        if (test != none){
            Background = test;
        }
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
     Background=Texture'DOTZTInterface.Menu.ESRB'
     bAllowedAsLast=True
     WinHeight=1.000000
     __OnKeyEvent__Delegate=DOTZESRBMenu.HandleKeyEvent
}
