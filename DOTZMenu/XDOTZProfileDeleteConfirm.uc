// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZProfileDeleteConfirm extends XDOTZErrorPage;

var sound ClickSound;

// Error string
var localized string error_string;
var int file_to_delete;
var string file_to_delete_name;

// Profiles
//var Profiler profiles;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   //profiles = new(self) class'DOTZProfiler';
}

/*****************************************************************
 * Opened
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);

   AddBackButton(cancel_string);
   AddSelectButton (accept_string);

   SetErrorCaption(error_string);
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
    file_to_delete = int(param1);
    file_to_delete_name = param2;
}

/*****************************************************************
 * Button A pressed
 *****************************************************************
 */

function DoButtonA ()
{
    Log("Deleting " $ file_to_delete_name);
    DOTZPlayerControllerBase(PlayerOwner()).DeleteProfile(file_to_delete);
    class'UtilsXbox'.static.Delete_Matching_Containers ("OWNER", file_to_delete_name);
    Controller.CloseMenu(true);
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
     error_string="Do you really want to remove this profile?"
     __OnKeyEvent__Delegate=XDOTZProfileDeleteConfirm.HandleKeyEvent
}
