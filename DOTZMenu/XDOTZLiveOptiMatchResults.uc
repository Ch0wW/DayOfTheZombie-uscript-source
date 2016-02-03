// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveOptiMatchResults extends XDOTZLiveMatchPage;



//Page components
var Automated BBXListBoxSm  ResultsList;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);
   // init my components...

   SetPageCaption (PageCaption);
   AddBackButton ();
   AddSelectButton ();

   ResultsList.List.OnDrawItem = DrawBinding;
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    local int num_results;
    local int cur_result;

    super.Opened(Sender);

    ResultsList.List.Clear();

    num_results = class'UtilsXbox'.static.Match_Get_Num_Sessions ();
    for (cur_result = 0; cur_result < num_results; ++cur_result) {
        ResultsList.List.Add("");
    }

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
 * DrawBinding
 *****************************************************************
 */
function DrawBinding(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
   local int           remember_match;

   // Test Item in bounds
   if (Item >= ResultsList.List.ItemCount || Item < 0){
      return;
   }

   // Select the friend
   remember_match = class'UtilsXbox'.static.Match_Get_Selected();
   class'UtilsXbox'.static.Match_Select(Item);

   // Draw the item
   ResultsList.Style.DrawText(Canvas, MenuState, X + (H / 2.0), Y, W, H, TXTA_Left, class'UtilsXbox'.static.Match_Get_SessionName());
   ResultsList.Style.DrawText(Canvas, MenuState, X + (W / 2.0), Y, W, H, TXTA_Left, IntToGameType (class'UtilsXbox'.static.Match_Get_GameType()));

   ResultsList.Style.DrawText(Canvas, MenuState, X + W - H * 2.0, Y, W, H, TXTA_Left,
            string(class'UtilsXbox'.static.Match_Get_PublicFilled() + class'UtilsXbox'.static.Match_Get_PrivateFilled())
            $ "/" $ string(class'UtilsXbox'.static.Match_Get_MaxPlayers()) );

   if (bSelected) {
      Canvas.SetPos(X,Y);
      Canvas.DrawTileStretched( ResultsList.List.SelectedImage, W,H );
   }

   class'UtilsXbox'.static.Match_Select(remember_match);
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */

function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;


    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case ResultsList:
            list_index = ResultsList.List.Index;

            if (list_index < 0 || list_index >= ResultsList.List.ItemCount)
               return true;

            class'UtilsXbox'.static.Match_Select(list_index);

            // Currently viewd session is already selected
            // so all we have to do is reboot.

            class'UtilsXbox'.static.Set_Reboot_Type(4);   // Is live client

            // Display loading screen
            //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");

            // Not joining a friend
            class'UtilsXbox'.static.Live_Client_Set_Joining_Friend(false);
            class'UtilsXbox'.static.Live_Client_Set_Joining_Cross(false);

            // Reboot!
            //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox

            // 0.0.0.0 Gets replaced with the real IP after reboot
            Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect", "0.0.0.0"
                    //$ "?XGAMERTAG=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Current_Name())
                    //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                    //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
                );


            break;
    };

   return true;
}

/*****************************************************************
 * B Button pressed
 *****************************************************************
 */

function DoButtonB ()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * NotifyLevelChange
 *****************************************************************
 */

event NotifyLevelChange()
{
    Controller.CloseMenu(true);
}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=BBXListBoxSm Name=ResultsList_btn
         bVisibleWhenEmpty=True
         StyleName="BBXInvisibleSm"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZLiveOptiMatchResults.ButtonClicked
         Name="ResultsList_btn"
     End Object
     ResultsList=BBXListBoxSm'DOTZMenu.XDOTZLiveOptiMatchResults.ResultsList_btn'
     PageCaption="OptiMatch"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveOptiMatchResults.HandleKeyEvent
}
