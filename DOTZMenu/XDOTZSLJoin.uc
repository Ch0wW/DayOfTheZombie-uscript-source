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

class XDOTZSLJoin extends XDOTZLivePage;




//Page components
var Automated BBXListBox  HostsList;

//configurable stuff
var string ErrorMenu;

var localized string PageCaption;
var localized string DefaultPlayerName;

var sound ClickSound;

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */

function Refresh_Hosts_List () {
     local int num_hosts;
     local int host_id;
     local int error;
     local string host_name;

     HostsList.List.Clear();

     class'UtilsXbox'.static.Syslink_Refresh_Hosts ();

     // Check errors
     error = class'UtilsXbox'.static.Get_Last_Error();
     if (error > 0) {
        Controller.OpenMenu(ErrorMenu);
        return;
     }

     num_hosts = class'UtilsXbox'.static.Syslink_Get_Num_Hosts ();

     for (host_id = 0; host_id < num_hosts; ++host_id) {
        host_name = class'UtilsXbox'.static.Syslink_Get_Host_Name_At (host_id);
        HostsList.List.Add(host_name);
     }

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
   AddRefreshButton ();

   Refresh_Hosts_List ();
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

   //KillTimer();
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;
    local string playername;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case HostsList:
             list_index = HostsList.List.Index;

             if (list_index < 0 || list_index >= HostsList.List.ItemCount)
                return true;

             class'UtilsXbox'.static.Set_Reboot_Type(2);                // Is syslink client
             class'UtilsXbox'.static.Syslink_Select_Host (list_index);  // TODO: Controller 0

             // Display loading screen
             //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

             // Reboot!
             if (class'UtilsXbox'.static.Is_Signed_In()) {
                 playername = class'UtilsXbox'.static.Get_Current_Name();
                 if (playername == "")
                    playername = DefaultPlayerName;

                 Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect", "0.0.0.0"
                            $ "?XGAMERTAG=" $ EncodeStringURL(playername)
                            //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                            //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
                        );
             } else {
                 playername = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
                 if (playername == "")
                    playername = DefaultPlayerName;

                 Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect", "0.0.0.0"
                            $ "?XGAMERTAG=" $ EncodeStringURL(playername)
                            $ "?XUID=0"
                            //$ "?XNADDR=0"
                        );
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
    Log("Refreshing hosts list");
    Refresh_Hosts_List ();
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
     Begin Object Class=BBXListBox Name=HostsList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.750000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZSLJoin.ButtonClicked
         Name="HostsList_btn"
     End Object
     HostsList=BBXListBox'DOTZMenu.XDOTZSLJoin.HostsList_btn'
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     PageCaption="Join System Link Match"
     DefaultPlayerName="Player"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZSLJoin.HandleKeyEvent
}
