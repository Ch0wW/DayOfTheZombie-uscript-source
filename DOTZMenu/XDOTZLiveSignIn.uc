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

class XDOTZLiveSignIn extends XDOTZLivePage;




//Page components
var Automated BBXListBox  AccountList;

// Menu locations
var string PasswordMenu;         // Password menu location
var string ErrorMenu;
var string SigningInMenu;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;


/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();

    Refresh_Accounts_List ();
}

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */

function Refresh_Accounts_List () {
    local int account_id;
    local int num_accounts;
    local string account_name;
    local int error;

    local int current_item_index;
    local int current_scroll;

    // Retrieve the current selection
    current_item_index = AccountList.List.Index;
    current_scroll = AccountList.List.Top;


    // Refresh the accoutns list
    class'UtilsXbox'.static.Refresh_Accounts ();
    num_accounts = class'UtilsXbox'.static.Get_Num_Accounts ();

    // Clear the list
    AccountList.List.Clear();

    // Check for live sign in errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    if (error > 0) {
        Controller.OpenMenu(ErrorMenu);
    } else {

        // Add all the items to the list
        for (account_id = 0; account_id < num_accounts; ++account_id) {
            account_name = class'UtilsXbox'.static.Get_Account_Name (account_id);
            AccountList.List.Add(account_name);
        }

    }

    // If the item went missing, try to keep the selection at the same index
    if (current_item_index >= AccountList.List.ItemCount) {
        AccountList.List.Index = AccountList.List.ItemCount - 1;
    } else {
        AccountList.List.Index = current_item_index;
    }

    if (current_scroll >= AccountList.List.ItemCount) {
        AccountList.List.SetTopItem(AccountList.List.ItemCount - 1);
        AccountList.List.MyScrollBar.AlignThumb();
    } else {
        AccountList.List.SetTopItem(current_scroll);
        AccountList.List.MyScrollBar.AlignThumb();
    }

    // Make sure the selection does show up
    if (num_accounts > 0 && AccountList.List.Index < 0)
        AccountList.List.Index = 0;
}

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();
   AddSignUpButton ();

   Refresh_Accounts_List ();
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
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
    local bool requires_password;
    local int list_index;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;

    Log("Button Clicked");


    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case AccountList:
             list_index = AccountList.List.Index;

             if (list_index < 0 || list_index >= AccountList.List.ItemCount)
                return true;

             class'UtilsXbox'.static.Select_Account (list_index);      // TODO: Controller 0

             requires_password = class'UtilsXbox'.static.Needs_Password ();

             if (requires_password) {
                 return Controller.OpenMenu(PasswordMenu);
             } else {
                 Controller.OpenMenu(SigningInMenu);
             }


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
 * X Button pressed
 *
 *****************************************************************
 */

function DoButtonX ()
{
    Controller.OpenMenu("DOTZMenu.XDOTZLiveNewAccount");
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
     Begin Object Class=BBXListBox Name=AccountList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZLiveSignIn.ButtonClicked
         Name="AccountList_btn"
     End Object
     AccountList=BBXListBox'DOTZMenu.XDOTZLiveSignIn.AccountList_btn'
     PasswordMenu="DOTZMenu.XDOTZLivePassword"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     SigningInMenu="DOTZMenu.XDOTZLiveSigningIn"
     PageCaption="Sign In"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveSignIn.HandleKeyEvent
}
