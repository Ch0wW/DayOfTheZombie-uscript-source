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

class XDOTZLiveFriendsList extends XDOTZLiveFriendsListBase;




//Page components
var Automated BBXListBox  FriendsList;

var Automated GUILabel   GamertagLabel;
var Automated GUILabel   GamertagField;
var Automated GUILabel   StatusLabel;
var Automated GUILabel   StatusField;

//configurable stuff
var localized string PageCaption;

var sound ClickSound;

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */

function Refresh_Friends_List () {
    local int num_friends;
    local int friend_id;

    local int current_item_index;
    local int current_scroll;

    // Retrieve the current selection
    current_item_index = FriendsList.List.Index;
    current_scroll = FriendsList.List.Top;

    // Enumerate the list
    if (!class'UtilsXbox'.static.Friends_Refresh_List () &&
        class'UtilsXbox'.static.Friends_Get_Num_Friends () == FriendsList.List.ItemCount)
       return;

    // Clear the friends list
    FriendsList.List.Clear();

    num_friends = class'UtilsXbox'.static.Friends_Get_Num_Friends ();
    for (friend_id = 0; friend_id < num_friends; ++friend_id) {
        FriendsList.List.Add("");
    }

    // If the item went missing, try to keep the selection at the same index
    if (current_item_index >= FriendsList.List.ItemCount) {
        FriendsList.List.Index = FriendsList.List.ItemCount - 1;
    } else {
        FriendsList.List.Index = current_item_index;
    }

    if (current_scroll >= FriendsList.List.ItemCount) {
        FriendsList.List.SetTopItem(FriendsList.List.ItemCount - 1);
        FriendsList.List.MyScrollBar.AlignThumb();
    } else {
        FriendsList.List.SetTopItem(current_scroll);
        FriendsList.List.MyScrollBar.AlignThumb();
    }

}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();

    Refresh_Friends_List ();
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

   FriendsList.List.OnDrawItem = DrawBinding;
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
   //Controller.MouseEmulation(false);
}

/*****************************************************************
 * DrawBinding
 *****************************************************************
 */
function DrawBinding(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
   local string        gamer_tag;
   local string        xuid;

   local Material      notification_status;
   local Material      voice_status;
   local int           remember_friend;

   // Test Item in bounds
   if (Item >= FriendsList.List.ItemCount || Item < 0 || !class'UtilsXbox'.static.Is_Signed_In()){
      return;
   }

   // Select the friend
   remember_friend = class'UtilsXbox'.static.Friends_Get_Selected();
   class'UtilsXbox'.static.Friends_Select (Item);
   //class'UtilsXbox'.static.VoiceChat_Select_Talker (-1);

   xuid = class'UtilsXbox'.static.Friends_Get_ID();
   class'UtilsXbox'.static.VoiceChat_Select_Talker_By_XUID (xuid);

   // Retrieve the item
   gamer_tag = class'UtilsXbox'.static.Friends_Get_Gamer_Tag();
   notification_status = Get_Friend_Status_Material();
   voice_status = Get_Voice_Status_Material_Friends();

   // Draw the item
   FriendsList.Style.DrawText(Canvas, MenuState, X+2*H*1.3, Y, W, H, TXTA_Left, gamer_tag);

   // Draw the icons
   if (notification_status != none) {
      Canvas.SetPos(X+0*H*1.3,Y);
      Canvas.DrawTile( notification_status, H, H, 0, 0, 64, 64 );
   }

   if (voice_status != none) {
      Canvas.SetPos(X+1*H*1.3,Y);
      Canvas.DrawTile( voice_status, H, H, 0, 0, 64, 64 );
   }

   if (bSelected) {
      Canvas.SetPos(X,Y);
      Canvas.DrawTileStretched( FriendsList.List.SelectedImage, W,H );

      // Update the status and gamertag items
      GamertagField.Caption = gamer_tag;
      StatusField.Caption = Get_Status_String();
   }

   class'UtilsXbox'.static.Friends_Select (remember_friend);
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;
    local FriendStatus friend_status;

    if (!accept_input)
        return true;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case FriendsList:
            list_index = FriendsList.List.Index;

            if (list_index < 0 || list_index >= FriendsList.List.ItemCount)
               return true;

            // Select the friend
            class'UtilsXbox'.static.Friends_Select (list_index);

            if ( class'UtilsXbox'.static.Friends_Get_Gamer_Tag() != "" ) {
                // Figure out friend status part
                friend_status = Get_Friend_Status();
                switch (friend_status) {
                    case OFFLINE:                        Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOffline"); break;
                    case APPEARS_OFFLINE:                Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOffline"); break;
                    case ONLINE_PLAYING:                 Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendPlaying"); break;
                    case ONLINE_PLAYING_JOINABLE:        Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendPlaying"); break;
                    case ONLINE_NOT_IN_GAME_SESSION:     Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOnline"); break;
                    case INVITE_RECEIVED:                Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendRecvInv"); break;
                    case INVITE_SENT:                    Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendSentInv"); break;
                    case REQUEST_RECEIVED_BY_YOU:        Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendRecvReq"); break;
                    case REQUEST_SENT_BY_YOU:            Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendSentReq"); break;
                };
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
     Begin Object Class=BBXListBox Name=FriendsList_btn
         bVisibleWhenEmpty=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.320000
         WinLeft=0.100000
         WinWidth=0.750000
         WinHeight=0.500000
         __OnClick__Delegate=XDOTZLiveFriendsList.ButtonClicked
         Name="FriendsList_btn"
     End Object
     FriendsList=BBXListBox'DOTZMenu.XDOTZLiveFriendsList.FriendsList_btn'
     Begin Object Class=GUILabel Name=GamertagLabel_lbl
         Caption="Gamertag:"
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.180000
         WinLeft=0.120000
         WinWidth=0.200000
         WinHeight=0.100000
         Name="GamertagLabel_lbl"
     End Object
     GamertagLabel=GUILabel'DOTZMenu.XDOTZLiveFriendsList.GamertagLabel_lbl'
     Begin Object Class=GUILabel Name=GamertagFieldLabel_lbl
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.180000
         WinLeft=0.275000
         WinWidth=0.650000
         WinHeight=0.100000
         Name="GamertagFieldLabel_lbl"
     End Object
     GamertagField=GUILabel'DOTZMenu.XDOTZLiveFriendsList.GamertagFieldLabel_lbl'
     Begin Object Class=GUILabel Name=StatusLabel_lbl
         Caption="Presence:"
         StyleName="BBXSquareButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.230000
         WinLeft=0.120000
         WinWidth=0.200000
         WinHeight=0.100000
         Name="StatusLabel_lbl"
     End Object
     StatusLabel=GUILabel'DOTZMenu.XDOTZLiveFriendsList.StatusLabel_lbl'
     Begin Object Class=GUILabel Name=StatusFieldLabel_lbl
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.230000
         WinLeft=0.275000
         WinWidth=0.650000
         WinHeight=0.100000
         Name="StatusFieldLabel_lbl"
     End Object
     StatusField=GUILabel'DOTZMenu.XDOTZLiveFriendsList.StatusFieldLabel_lbl'
     PageCaption="Friends"
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveFriendsList.HandleKeyEvent
}
