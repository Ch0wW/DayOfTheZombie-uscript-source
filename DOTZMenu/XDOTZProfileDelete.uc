// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZProfileDelete extends XDOTZProfileBase;




//Page components
var Automated BBXListBox  ProfileList;

//configurable stuff
var localized string PageCaption;

var string ProfileConfirmMenu;         // Profile menu location

var sound ClickSound;

// Profiles
//var Profiler profiles;

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */

function Refresh_Profiles_List () {
   local int profile_count;
   local int p;

   profile_count = DOTZPlayerControllerBase(PlayerOwner()).GetProfileCount();

   ProfileList.List.Clear();
   for (p = 0; p < profile_count; ++p)
       ProfileList.List.Add(DOTZPlayerControllerBase(PlayerOwner()).GetProfileName(p));
}

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

  // profiles = new(self) class'DOTZProfiler';

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    Refresh_Profiles_List ();
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
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;
    local string list_item;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;


    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case ProfileList:
             list_index = ProfileList.List.Index;
             list_item = ProfileList.List.GetItemAtIndex(list_index);

             if (list_index < 0 || list_index >= ProfileList.List.ItemCount)
                 return true;

             Controller.OpenMenu(ProfileConfirmMenu, string(list_index), list_item);
             break;
    };

   return true;
}

/*****************************************************************
 * B Button pressed
 *
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
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
     Begin Object Class=BBXListBox Name=ProfileList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZProfileDelete.ButtonClicked
         Name="ProfileList_btn"
     End Object
     ProfileList=BBXListBox'DOTZMenu.XDOTZProfileDelete.ProfileList_btn'
     PageCaption="Delete Profile"
     ProfileConfirmMenu="DOTZMenu.XDOTZProfileDeleteConfirm"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZProfileDelete.HandleKeyEvent
}
