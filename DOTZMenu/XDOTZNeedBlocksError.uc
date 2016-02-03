// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZNeedBlocksError extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string1;
var localized string error_string2;

var string blocks;
var string total_blocks;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    Super.InitComponent(MyController, MyOwner);
}

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddSelectButton (continue_no_save_string);
   AddBackButton (free_blocks_string);
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
    SetErrorCaption(error_string1 $ " " $ blocks $ " " $ error_string2);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    Log("Need blocks dismissed");
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Button B pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.OpenMenu("DOTZMenu.XDOTZNeedBlocksConfirm", blocks, total_blocks);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     error_string1="Your Xbox console doesn't have enough free blocks to save games. You need"
     error_string2="more free blocks. Press A to continue without saving or B to free more blocks."
     __OnKeyEvent__Delegate=XDOTZNeedBlocksError.HandleKeyEvent
}
