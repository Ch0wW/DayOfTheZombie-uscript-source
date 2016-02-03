// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZSPDeadDemo - demo dead menu
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 24, 2005
 */

class XDOTZSPDeadDemo extends XDOTZInGamePage;



//Page components
var Automated GuiButton  RevertToLastSaveButton;
var Automated GuiButton  QuitButton;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);


    Log(self $ "InitComponent");
    SetPageCaption (PageCaption);
    //AddBackButton ();
    AddSelectButton ();
}


/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    //don't exactly know what is going on here, but if you leave this
    //page and return to it, it seems to have nothing focused properly
    //so rather than understanding the problem, we 'fix' it by force as
    //is the game development way apparently.
    SetFocus(RevertToLastSaveButton);
    RevertToLastSaveButton.SetFocus(none);

}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   Controller.MouseEmulation(false);
}



function Periodic ()
{
    super.Periodic();
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

    PlayerOwner().PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {

        case RevertToLastSaveButton:
             return Controller.OpenMenu("");
             break;

        case QuitButton:
             Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
             Controller.ConsoleCommand("RestartLevel");
             break;
    };

   return false;
}

/*****************************************************************
 * Continue if B pressed too
 *
 *****************************************************************
 */

function DoButtonB ()
{

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
     Begin Object Class=GUIButton Name=RevertToLastSaveButton_btn
         Caption="Load Game"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         __OnClick__Delegate=XDOTZSPDeadDemo.ButtonClicked
         Name="RevertToLastSaveButton_btn"
     End Object
     RevertToLastSaveButton=GUIButton'DOTZMenu.XDOTZSPDeadDemo.RevertToLastSaveButton_btn'
     Begin Object Class=GUIButton Name=QuitButton_btn
         Caption="Quit"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.300000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.080000
         TabOrder=1
         bFocusOnWatch=True
         __OnClick__Delegate=XDOTZSPDeadDemo.ButtonClicked
         Name="QuitButton_btn"
     End Object
     QuitButton=GUIButton'DOTZMenu.XDOTZSPDeadDemo.QuitButton_btn'
     PageCaption="You Died Loser"
     ClickSound=Sound'DOTZXInterface.Select'
     WinTop=0.250000
     WinHeight=0.500000
     __OnKeyEvent__Delegate=XDOTZSPDeadDemo.HandleKeyEvent
}
