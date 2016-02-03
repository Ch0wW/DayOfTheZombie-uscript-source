// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XDOTZProfileSelectIntro extends XDOTZProfileSelect;

var string MainMenu;    // Single Player menu location

/*****************************************************************
 * Add buttons
 *****************************************************************
 */

function AddButtons () {
   AddSelectButton ();
   AddBackButton();
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    // Autoselect if only one profile
    if (ProfileList.List.ItemCount == 1) {
        if (DOTZPlayerControllerBase(PlayerOwner()).LoadProfile(0))  {
            ProfileSelected();
        }
    }
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.OpenMenu(MainMenu, "ProfileHack");
}

/*****************************************************************
 * Called after profile is selected
 *
 *****************************************************************
 */

function ProfileSelected() {
    Controller.OpenMenu(MainMenu);
}

/*****************************************************************
 * Default properties
 *
 *****************************************************************
 */

defaultproperties
{
     MainMenu="DOTZMenu.XDOTZMainMenu"
     __OnKeyEvent__Delegate=XDOTZProfileSelectIntro.HandleKeyEvent
}
