// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//  XDOTZErrorPage - Base class for error pages
//-----------------------------------------------------------

class DOTZInGamePage extends DOTZPageBase;

var Automated GUILabel   PageCaption;
var automated GUIButton  InGameBackground;     // Button placed in the background

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.Initcomponent(MyController, MyOwner);
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
 * Sets the caption displayed at the top of the page
 *****************************************************************
 */

function SetPageCaption(string caption) {
    PageCaption.Caption = caption;
}

/*****************************************************************
 * HandleKeyEven
 * It was like this when I got here
 *****************************************************************
 */

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

    // A short pause
    if (!accept_input) return false;

    // Key down only
    if (State != 1) return false;
    //Log(" *** Button down " $ Key);

    if (Key == 27) {  //Esc
        // Unpause if this is the last menu
        if (BBGUIController(Controller).GetMenuStackSize() == 1) {
            Controller.ViewportOwner.Actor.SetPause(false);
        }

        Controller.CloseMenu(true);
    }

    //for working with PC
    /*if (Key == 13){ //Enter
      DoButtonA();
    } else if (Key == 27){  //Esc
      DoButtonB();
    } else if  (Key == 32){
      DoButtonStart();
    }*/

    return true;
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=PageCaption_lbl
         bMultiLine=True
         StyleName="BBRoundButton"
         bVisible=False
         bNeverFocus=True
         WinTop=0.120000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="PageCaption_lbl"
     End Object
     PageCaption=GUILabel'DOTZMenu.DOTZInGamePage.PageCaption_lbl'
     Begin Object Class=GUIButton Name=InGameBackground_btn
         StyleName="BBHorizontalBarSolid"
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         WinHeight=1.000000
         RenderWeight=0.100000
         Name="InGameBackground_btn"
     End Object
     InGameBackground=GUIButton'DOTZMenu.DOTZInGamePage.InGameBackground_btn'
     ClickSound=Sound'DOTZXInterface.Select'
     bRequire640x480=False
     bAllowedAsLast=True
     WinTop=0.100000
     WinLeft=0.100000
     WinWidth=0.800000
     WinHeight=0.850000
}
