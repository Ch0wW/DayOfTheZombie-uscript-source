// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZRestartDemo - restart demo
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #1 $
 * @date    July 7, 2005
 */
class XDOTZRestartDemo extends XDOTZDemo;




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
        Background = ExitBackGround;
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
        Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
        Controller.ConsoleCommand("RestartLevel");
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
     Background=Texture'DOTZTInterface.Demo.BoilerPlate'
     __OnKeyEvent__Delegate=XDOTZRestartDemo.HandleKeyEvent
}
