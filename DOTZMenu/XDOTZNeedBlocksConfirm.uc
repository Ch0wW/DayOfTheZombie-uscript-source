// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZNeedBlocksConfirm extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

var string blocks;
var string total_blocks;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   SetErrorCaption(error_string);
   AddBackButton(cancel_string);
   AddSelectButton (continue_string);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the title
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    blocks = param1;
    total_blocks = param2;
    Log("Blocks needed " $ param1);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    class'UtilsXbox'.static.Dashboard_Free_Blocks(int(total_blocks));
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string="You are about to leave the game and enter the Xbox Dashboard. do you wish to continue?"
     __OnKeyEvent__Delegate=XDOTZNeedBlocksConfirm.HandleKeyEvent
}
