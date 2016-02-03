// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZLiveNewAccount extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   class'UtilsXbox'.static.Sign_Out();

   SetErrorCaption(error_string);
   AddBackButton(cancel_string);
   AddSelectButton(new_account_string);
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    Controller.OpenMenu("DOTZMenu.XDOTZLiveNewAccountConfirm");
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
     error_string="Do you want to sign up for a Xbox Live account? Press A to sign up for Xbox Live or B to cancel."
     __OnKeyEvent__Delegate=XDOTZLiveNewAccount.HandleKeyEvent
}
