// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZExitScreenDemo - the demo exit screen advertising page
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    June 23, 2005
 */

class XDOTZExitScreenDemo extends XDOTZDemo;





// For counting down
var int iteration;
var bool bCanExit;

var Material ExitBackGround;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
    Super.Initcomponent(MyController, MyOwner);
    bCanExit = false;
    LiveCaption.bVisible = false;
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

function Periodic()
{
    if(bCanExit)
        return;

    ++iteration;

    if (iteration >= 5)
    {
        Log("User can exit now...");
        bCanExit = true;
        // They dont want button press, so quit now
        Controller.ConsoleCommand("Quit");
        Controller.CloseMenu(true);
        //Background = ExitBackGround;
    }
}

function SetLoginName()
{
}

event Opened( GUIComponent Sender )
{
    super.Opened(Sender);
}


event Closed(GUIComponent Sender, bool bCancelled) {
     Super.Closed(Sender,bCancelled);
     Controller.MouseEmulation(false);
}


function DoButtonA ()
{
    if (bCanExit)
    {
        Controller.ConsoleCommand("Quit");
        Controller.CloseMenu(true);
    }
}

function DoButtonB ()
{
    DoButtonA ();
}

function DoButtonStart ()
{
    DoButtonA ();
}


event NotifyLevelChange() {
    Controller.CloseMenu(true);
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     period=1.000000
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZExitScreenDemo.HandleKeyEvent
}
