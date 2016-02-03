// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZSLMainMenu extends XDOTZLivePage;



//Page components
var Automated GuiButton  HostButton;
var Automated GuiButton  JoinButton;

//configurable stuff
var string HostMenu;
var string JoinMenu;
var string ErrorMenu;

//configurable stuff
var localized string PageCaption;


var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
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
   Controller.MouseEmulation(false);
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case HostButton:
             return Controller.OpenMenu(HostMenu);
             break;

        case JoinButton:
             return Controller.OpenMenu(JoinMenu);
             break;

    };

   return false;
}

/*****************************************************************
 * B Button pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUIButton Name=HostButton_btn
         Caption="Create match"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.400000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSLMainMenu.ButtonClicked
         Name="HostButton_btn"
     End Object
     HostButton=GUIButton'DOTZMenu.XDOTZSLMainMenu.HostButton_btn'
     Begin Object Class=GUIButton Name=JoinButton_btn
         Caption="Join match"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.500000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSLMainMenu.ButtonClicked
         Name="JoinButton_btn"
     End Object
     JoinButton=GUIButton'DOTZMenu.XDOTZSLMainMenu.JoinButton_btn'
     HostMenu="DOTZMenu.XDOTZSLCreateMatch"
     JoinMenu="DOTZMenu.XDOTZSLJoin"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     PageCaption="System Link"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZSLMainMenu.HandleKeyEvent
}
