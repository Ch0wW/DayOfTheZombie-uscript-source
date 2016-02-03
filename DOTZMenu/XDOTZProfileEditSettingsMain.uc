// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZProfileEditSettingsMain extends XDOTZProfileEditSettings;

/*****************************************************************
 * InitDynamicValues
 * So we can initialize from other delegates too
 *****************************************************************
 */
function AddButtons(){
   AddBackButton ();
   //AddSelectButton ();
   AddSaveButton ();
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */
function DoButtonB ()
{
    CloseMenu ();
}

/*****************************************************************
 * Close menus
 *
 *****************************************************************
 */
function CloseMenu ()
{
    Controller.CloseMenu(true);
}

defaultproperties
{
     __OnActivate__Delegate=XDOTZProfileEditSettingsMain.HandleActivate
     __OnKeyEvent__Delegate=XDOTZProfileEditSettingsMain.HandleKeyEvent
}
