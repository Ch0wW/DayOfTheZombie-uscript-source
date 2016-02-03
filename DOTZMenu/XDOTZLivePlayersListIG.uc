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

class XDOTZLivePlayersListIG extends XDOTZLiveFriendsListBaseIG;




//Page components
var Automated BBXListBox  PlayerDisplay;
var Automated GUILabel NameLabel;
var Automated GUILabel DeathsLabel;
var Automated GUILabel ScoreLabel;
var Automated GUILabel KillsLabel;

var ObjectPool objMaker;

//configurable stuff
var localized string PageCaption;

// Menus
var string PlayerSelectMenu;

var sound ClickSound;

// Players array

//var int myPRIIndex;
var bool bTeamGame;
var array<int> TeamScores;


const MAX_TAG_LEN = 15;

var int gametype; // look in AdvancedMPGameBase to see the gametype IDs

var Material KillsMat;
var Material RankMat;
var array<Material> TeamScoreMat;
var array<Material> TeamKillsMat;
var array<Material> TeamRankMat;
var array<Material> FlagHomeMat;
var array<Material> FlagHeldMat;
var array<Material> FlagDropMat;
var array<Material> TeamCTFScoreMat;

var Material BlueFlagMat;
var Material RedFlagMat;
var Material WaveMat;

var Automated BBXListBox IconPage;

/*
struct MyPRI
{
   var() string Gamertag;
   var() string PlayerName;
   var() int Score;
   var() int Deaths;
   var() int TeamIndex;
   var() int TeamID;
   var() string xnaddr;
   var() string xuid;
   var() int Ranking;
   var() int Kills;
};
var array<MyPRI> pris;
var array<MyPRI> oldpris;
*/

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
   Super.Initcomponent(MyController, MyOwner);
   // init my components...
   Add_Buttons ();
   PlayerDisplay.List.OnDrawItem = DrawBinding;
   bTeamGame = PlayerOwner().GameReplicationInfo.bTeamGame;

    gametype = PlayerOwner().GameReplicationInfo.MatchID;
   // If DM or TDM, change Kills to Score
   if( gametype == 1 || gametype == 2 )
   {
        KillsLabel.Caption = "Score";
        KillsLabel.WinLeft = 0.85;
   } else if( gametype == 4 )
   {
        KillsLabel.Caption = "Kills";
        KillsLabel.WinLeft = 0.85;
   } else if( gametype == 3 ) // CTF -> use Captures
        KillsLabel.Caption = "Captures";

   Refresh_Players_List ();

    // Add a fake entry, then draw icons on list
    IconPage.List.Add("");
   if ( PlayerOwner().GameReplicationInfo.MatchID == 1 )
        IconPage.List.OnDrawItem = DrawDMIcons;
   else if ( PlayerOwner().GameReplicationInfo.MatchID == 2 )
        IconPage.List.OnDrawItem = DrawTDMIcons;
   else if ( PlayerOwner().GameReplicationInfo.MatchID == 3 )
        IconPage.List.OnDrawItem = DrawCTFIcons;
   else if ( PlayerOwner().GameReplicationInfo.MatchID == 4 )
        IconPage.List.OnDrawItem = DrawINVIcons;
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied here.
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

}

/*****************************************************************
 * AddButtons
 *****************************************************************
 */

function Add_Buttons () {
    //SetPageCaption (PageCaption);
    AddBackButton ();
    AddSelectButton ();
}

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */
function Refresh_Players_List () {
    local int num_players;
    local int friend_id;

    local int current_item_index;
    local int current_scroll;

    // Retrieve the current selection
    current_item_index = PlayerDisplay.List.Index;
    current_scroll = PlayerDisplay.List.Top;

    // Enumerate the list
    class'UtilsXbox'.static.Friends_Refresh_List ();

    // Clear the friends list
    PlayerDisplay.List.Clear();

    // Get the Pri array
    //PlayerOwner().GameReplicationInfo.GetPRIArray(pris);
    //PlayerOwner().GameReplicationInfo.GetOldPRIArray(oldpris);
    //RefreshAllInfo();
    //FilterDuplicates();

    DOTZPlayerControllerBase(PlayerOwner()).RefreshPRI( gametype );
    //PlayerOwner().RefreshPRI(gametype);
    if( PlayerOwner().GameReplicationInfo.Teams[0] != None )
        TeamScores[0] = int(PlayerOwner().GameReplicationInfo.Teams[0].Score);
    if( PlayerOwner().GameReplicationInfo.Teams[1] != None )
        TeamScores[1] = int(PlayerOwner().GameReplicationInfo.Teams[1].Score);

    // always sort on kills & deaths
    //SortListByWhatever();

    num_players = DOTZPlayerControllerBase(PlayerOwner()).pris.Length + DOTZPlayerControllerBase(PlayerOwner()).oldpris.length;
    for (friend_id = 0; friend_id < num_players; ++friend_id) {
        PlayerDisplay.List.Add("");
    }

    // If the item went missing, try to keep the selection at the same index
    if (current_item_index >= PlayerDisplay.List.ItemCount) {
        PlayerDisplay.List.Index = PlayerDisplay.List.ItemCount - 1;
    } else {
        PlayerDisplay.List.Index = current_item_index;
    }

    if (current_scroll >= PlayerDisplay.List.ItemCount) {
        PlayerDisplay.List.SetTopItem(PlayerDisplay.List.ItemCount - 1);
        PlayerDisplay.List.MyScrollBar.AlignThumb();
    } else {
        PlayerDisplay.List.SetTopItem(current_scroll);
        PlayerDisplay.List.MyScrollBar.AlignThumb();
    }
}

/*****************************************************************
 * FilterDuplicates
 * if the dude is in the PriArray, then remove them from the OldPriArray
 *****************************************************************
 */
 /*
function FilterDuplicates(){
   local int i,k;
   for(k=0; k<pris.length; k++){
//      log("comparing : " $ pris[k].gamertag);
      for (i=0; i<oldpris.length; i++){
      log("                           to : " $ oldpris[i].gamertag);
         if (pris[k].gamertag == oldpris[i].gamertag) {
  //          log("removing " $ oldpris[i].Gamertag);
            oldpris.remove(i,1);
         }
      }
   }

    // Find dupes in the old array
    for( k=0; k<oldpris.length; k++ )
    {
        for( i=0; i<oldpris.length; i++)
        {
            if( (k != i) && (oldpris[k].Gamertag == oldpris[i].Gamertag) )
                oldpris.Remove(i, 1);
        }
    }
}*/

/*****************************************************************
 * SortListByTeam
 *****************************************************************
 *//*
function SortListByTeam(){//array<PlayerReplicationInfo> pris){
   local int i,k;
   local MyPRI tempplayerinfo;
   //no sorting required for none team game
   if (bTeamGame == false){
      return;
   }

  // while(i<pris.length){
   for(k=0; k<pris.length-1; k++){
      for (i=0; i<pris.length-(k+1); i++){
         //Add Team blue to the end of the list
         if (pris[i].TeamIndex != 0) {
            tempPlayerInfo = pris[i];
            pris[i] = pris[i+1];
            pris[i+1] = tempPlayerInfo;
         }
      }
   }
}

*/
/*****************************************************************
 * SortListByTeam - screwed it up, but look at SortListByKills
 *****************************************************************
 *//*
function SortListByScore(){//array<PlayerReplicationInfo> pris){
   local int i,k;
   local MyPRI tempplayerinfo;

   for(k=0; k<pris.length-1; k++){
      for (i=0; i<pris.length-(k+1); i++){
         if (pris[i].Kills < pris[i+1].Kills ||
            ((pris[i].Kills == pris[i+1].Kills) && (pris[i].Deaths > pris[i+1].Deaths)) ) {
            tempPlayerInfo = pris[i];
            pris[i] = pris[i+1];
            pris[i+1] = tempPlayerInfo;
         }
      }
   }
}
*/
/*****************************************************************
 * SortListByWhatever - uses Score & Deaths if DM or TDM, else uses Kills & Deaths, also does ranking
 *****************************************************************
 *//*
function SortListByWhatever()
{
    local int i, k, s1, s2;
    local MyPRI tempplayerinfo;
    //local int currentRank;


    // First sort the players
    for(k=0; k <pris.length-1; k++)
    {
        for(i=0; i<pris.length-(k+1); i++)
        {
            if( gametype == 4 )
            {
                s1 = pris[i].Kills;
                s2 = pris[i+1].Kills;
            } else
            {
                s1 = pris[i].Score;
                s2 = pris[i+1].Score;
            }
            if(s1 < s2 || ((s1 == s2) && (pris[i].Deaths > pris[i+1].Deaths)) )
            {
                tempplayerinfo = pris[i];
                pris[i] = pris[i+1];
                pris[i+1] = tempplayerinfo;

                if( myPRIIndex == i )
                    myPRIIndex = i + 1;
                else if( myPRIIndex == (i + 1) )
                    myPRIIndex = i;
            }
        }
    }

    // Apply ranking
    for(i=0; i<pris.length; i++)
    {
        if( i == 0 )
            pris[i].Ranking = 1;
        else
        {
            if( gametype == 4 )
            {
                s1 = pris[i-1].Kills;
                s2 = pris[i].Kills;
            } else
            {
                s1 = pris[i-1].Score;
                s2 = pris[i].Score;
            }

            if( (s1 == s2) && (pris[i-1].Deaths == pris[i].Deaths) )
                pris[i].Ranking = pris[i-1].Ranking;
            else
                pris[i].Ranking = pris[i-1].Ranking + 1;
        }
    }
}
*/

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    super.Periodic();
    Refresh_Players_List ();
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
 * DrawBinding
 *****************************************************************
 */
function DrawBinding(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){

   // Test Item in bounds
   if (Item >= PlayerDisplay.List.ItemCount || Item < 0 ){
      return;
   }

  // NameLabel.Caption = "old:" $ string(oldpris.length);
  // DeathsLabel.Caption = "pri: " $ string(pris.length);


   //draw active players at the top of the list
   if (Item < DOTZPlayerControllerBase(PlayerOwner()).pris.length){
      DrawActivePlayer(Canvas, Item, X, Y, W, H, bSelected);

   //draw inactive players at the bottom of the list
   } else if (Item < (DOTZPlayerControllerBase(PlayerOwner()).oldpris.length + DOTZPlayerControllerBase(PlayerOwner()).pris.Length)){
      //different list, can't just use the item
      DrawInactivePlayer(Canvas, (Item - DOTZPlayerControllerBase(PlayerOwner()).pris.Length), X, Y , W, H, bSelected);
   }

    // Draw the icons
    //if (PlayerOwner().GameReplicationInfo.MatchID == 1)
     //   DrawDMIcons(Canvas, Item, X, Y, W, H);
}

/*
function dumpplayers(){
   local int i;
   Log("PRIArray");
   for (i=0;i < DOTZPlayerControllerBase(PlayerOwner()).pris.Length; i++){
      Log(DOTZPlayerControllerBase(PlayerOwner()).pris[i].Gamertag $ " : " $ DOTZPlayerControllerBase(PlayerOwner()).pris[i].PlayerName );
   }

   Log("oldPRIArray");
   for (i=0;i < DOTZPlayerControllerBase(PlayerOwner()).oldpris.Length; i++){
      Log(DOTZPlayerControllerBase(PlayerOwner()).oldpris[i].Gamertag $ " : " $ DOTZPlayerControllerBase(PlayerOwner()).oldpris[i].PlayerName );
   }


}
*/

/*****************************************************************
 * DrawActivePlayer
 * Draws all the details of a player that is still in the game to
 * the Display List.
 *****************************************************************
 */
function DrawActivePlayer(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
   local string        gamer_tag;
   local string        xuid;
   local Material      notification_status;
   local Material      voice_status;
   local int           remember_friend;
   local int           remember_talker;
   local int           f;
   local color         colors[5];
   local GUIFont       Fonts[5];


  //if (pris[Item] == none){
    //  return;
   //}

   // Select the friend
   remember_friend = class'UtilsXbox'.static.Friends_Get_Selected();
   remember_talker = class'UtilsXbox'.static.VoiceChat_Get_Selected();

   // Retrieve the item
   gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Gamertag);
   if (Len(gamer_tag) > MAX_TAG_LEN){
      gamer_tag = Left(gamer_tag, MAX_TAG_LEN) $ "...";
   }
   xuid = DOTZPlayerControllerBase(PlayerOwner()).pris[Item].xuid;

   class'UtilsXbox'.static.Friends_Select_By_XUID (xuid);
   class'UtilsXbox'.static.VoiceChat_Select_Talker_By_XUID (xuid);

   notification_status = Get_Friend_Status_Material();
   voice_status = Get_Voice_Status_Material_Players();

   // Draw the item

   // Remember font colors & fontnames
   for (f = 0; f < 5; ++f)
   {
       colors[f] = PlayerDisplay.Style.FontColors[f];
       Fonts[f] = PlayerDisplay.Style.Fonts[f];
       PlayerDisplay.Style.Fonts[f] = Controller.GetMenuFont("XPlainSmallFont");
    }

   // if this is a team game, change the colors
   if (bTeamGame == true) {
       for (f = 0; f < 5; ++f) {
           if (DOTZPlayerControllerBase(PlayerOwner()).pris[Item].TeamIndex == 0) {
               PlayerDisplay.Style.FontColors[f].R = 255;
               PlayerDisplay.Style.FontColors[f].G = 111;
               PlayerDisplay.Style.FontColors[f].B = 111;
           } else {
               PlayerDisplay.Style.FontColors[f].R = 111;
               PlayerDisplay.Style.FontColors[f].G = 111;
               PlayerDisplay.Style.FontColors[f].B = 255;
           }
       }
      //Score = pris[Item].Team.Score;
   } else {
      //Score = pris[Item].Score;
   }
   //Deaths = pris[Item].Deaths;
   //Kills = pris[Item].Kills;

   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.79,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Deaths));

   if( gametype == 4 )  // if Invasion, just use kills
        PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.93,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Kills));
   else
        PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.93,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Score));

   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.16, Y, W, H, TXTA_Left, gamer_tag);
   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.1, Y, W, H, TXTA_Left, "" @ DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Ranking);


   // Restore Font colors & font names
   for (f = 0; f < 5; ++f)
   {
       PlayerDisplay.Style.FontColors[f] = colors[f];
       PlayerDisplay.Style.Fonts[f] = Fonts[f];
    }

   // Draw the icons
   if (notification_status != none) {
      Canvas.SetPos(X+W*0.01,Y);
      Canvas.DrawTile( notification_status, H, H, 0, 0, 64, 64 );
   }

   if (voice_status != none) {
      Canvas.SetPos(X+W*0.05,Y);
      Canvas.DrawTile( voice_status, H, H, 0, 0, 64, 64 );
   }

   if (bSelected) {
      Canvas.SetPos(X,Y);
      Canvas.DrawTileStretched( PlayerDisplay.List.SelectedImage, W,H );

      // Update the status and gamertag items
      //GamertagField.Caption = gamer_tag;
      //StatusField.Caption = Get_Status_String();
   }

   class'UtilsXbox'.static.Friends_Select (remember_friend);
   class'UtilsXbox'.static.VoiceChat_Select_Talker (remember_talker);


}

/*****************************************************************
 * DrawInactivePlayer
 * Draws the inactive player to an element in the Display list
 *****************************************************************
 */
function DrawInactivePlayer(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
   local string        gamer_tag;
   local color         colors[5];
   //local int           Deaths;
   //local int           Score;
   //local int           Kills;
   local int           f;
   local int           remember_friend;
   local int           remember_talker;
   local string        xuid;
   local Material      notification_status;
   local Material      voice_status;
   local GUIFont       Fonts[5];

  //if (oldpris[Item] == none ){
      //return;
   //}

   // Select the friend
   remember_friend = class'UtilsXbox'.static.Friends_Get_Selected();
   remember_talker = class'UtilsXbox'.static.VoiceChat_Get_Selected();


   gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Gamertag);
   if (Len(gamer_tag) > MAX_TAG_LEN){
      gamer_tag = Left(gamer_tag, MAX_TAG_LEN) $ "...";
   }
   //Deaths = oldpris[Item].Deaths;
   //Score = oldpris[Item].Score;
   //Kills = oldpris[Item].Kills;

   xuid = DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].xuid;


   class'UtilsXbox'.static.Friends_Select_By_XUID (xuid);
   class'UtilsXbox'.static.VoiceChat_Select_Talker_By_XUID (xuid);

   notification_status = Get_Friend_Status_Material();
   voice_status = Get_Voice_Status_Material_Players();


   // Remember font colors
   for (f = 0; f < 5; ++f)
   {
       colors[f] = PlayerDisplay.Style.FontColors[f];
       Fonts[f] = PlayerDisplay.Style.Fonts[f];
       PlayerDisplay.Style.Fonts[f] = Controller.GetMenuFont("XPlainSmallFont");
    }

   // if this is a team game, change the colors
   for (f = 0; f < 5; ++f) {
      PlayerDisplay.Style.FontColors[f].R = 90;
      PlayerDisplay.Style.FontColors[f].G = 90;
      PlayerDisplay.Style.FontColors[f].B = 90;
   }

   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.79,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Deaths));

   if( gametype == 4 )  // if Invasion, just use kills
        PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.93,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Kills));
   else
        PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.93,Y,W,H,TXTA_LEFT, string(DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Score));

   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.16, Y, W, H, TXTA_Left, gamer_tag);
   PlayerDisplay.Style.DrawText(Canvas, MenuState, X+W*0.1, Y, W, H, TXTA_Left, "" @ DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Ranking);

   // Restore Font colors
   for (f = 0; f < 5; ++f){
       PlayerDisplay.Style.FontColors[f] = colors[f];
       PlayerDisplay.Style.Fonts[f] = Fonts[f];
   }

   // Draw the icons
   if (notification_status != none) {
      Canvas.SetPos(X+W*0.01,Y);
      Canvas.DrawTile( notification_status, H, H, 0, 0, 64, 64 );
   }

   if (voice_status != none) {
      Canvas.SetPos(X+W*0.05,Y);
      Canvas.DrawTile( voice_status, H, H, 0, 0, 64, 64 );
   }

  if (bSelected) {
      Canvas.SetPos(X,Y);
      Canvas.DrawTileStretched( PlayerDisplay.List.SelectedImage, W+W*0.02,H );

      // Update the status and gamertag items
      //GamertagField.Caption = gamer_tag;
      //StatusField.Caption = Get_Status_String();
   }

   class'UtilsXbox'.static.Friends_Select (remember_friend);
   class'UtilsXbox'.static.VoiceChat_Select_Talker (remember_talker);

}



/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;

    local string gamer_tag;
    local string xuid;

    if (!accept_input)
        return true;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case PlayerDisplay:
             list_index = PlayerDisplay.List.Index;

             if (list_index < 0 || list_index >= PlayerDisplay.List.ItemCount)
                return true;

             // Check player is you
             if (DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).pris[list_index].Gamertag) == class'UtilsXbox'.static.Get_Current_Name())
                return true;

             // If we are in a live match, then list is selectable
             if (class'UtilsXbox'.static.Get_Reboot_Type() == 3 ||
                 class'UtilsXbox'.static.Get_Reboot_Type() == 4) {
                 // Select the player
                 if (list_index < DOTZPlayerControllerBase(PlayerOwner()).pris.Length) {
                    gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).pris[list_index].Gamertag);
                    xuid = DOTZPlayerControllerBase(PlayerOwner()).pris[list_index].xuid;
                 } else {
                    gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).oldpris[list_index - DOTZPlayerControllerBase(PlayerOwner()).pris.Length].Gamertag);
                    xuid = DOTZPlayerControllerBase(PlayerOwner()).oldpris[list_index - DOTZPlayerControllerBase(PlayerOwner()).pris.Length].xuid;
                 }

                 // Select the friend
                 class'UtilsXbox'.static.Friends_Select_By_XUID (xuid);
                 class'UtilsXbox'.static.VoiceChat_Select_Talker_By_XUID (xuid);

                 // Open the manage player menu
                 Controller.OpenMenu(PlayerSelectMenu, gamer_tag, xuid);
             }
             break;
    };

   return true;
}


/*****************************************************************
 * What happens if the A button is pressed
 *****************************************************************
 */

function DoButtonA ()
{
    /*local FriendStatus friend_status;

    // Figure out friend status part
    friend_status = Get_Friend_Status();
    switch (friend_status) {
        case OFFLINE:                        Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOfflineIG"); break;
        case APPEARS_OFFLINE:                Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOfflineIG"); break;
        case ONLINE_PLAYING:                 Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOnlineIG"); break;
        case ONLINE_NOT_IN_GAME_SESSION:     Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendOnlineIG"); break;
        case INVITE_RECEIVED:                Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendRecvInvIG"); break;
        case INVITE_SENT:                    Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendSentInvIG"); break;
        case REQUEST_RECEIVED_BY_YOU:        Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendRecvReqIG"); break;
        case REQUEST_SENT_BY_YOU:            Controller.OpenMenu("DOTZMenu.XDOTZLiveFriendSentReqIG"); break;
    };*/

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



/*****************************************************************
 * DrawDMIcons - draw the deathmatch icons
 *
 *****************************************************************
 */
function DrawDMIcons(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected)
{
    local float scaleX, scaleY;
    local int StatLocation, StatSpace, LeftMargin, LeftMarginPlus, TeamLeftMargin;

    scaleX = 0.5;
    scaleY = 0.5;

    StatLocation = 130;
    StatSpace = 55;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + 30;
    TeamLeftMargin = 170 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(RankMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(KillsMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Score));
}

/*****************************************************************
 * DrawTDMIcons - draw the team deathmatch icons
 *
 *****************************************************************
 */
function DrawTDMIcons(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected)
{
    local float scaleX, scaleY;
    local int StatLocation, StatSpace, LeftMargin, LeftMarginPlus, TeamLeftMargin;
    local int TeamNum, EnemyTeamNum;

    // Get team number
    //if (PlayerOwner().PlayerReplicationInfo.Team != none){
      //TeamNum = PlayerOwner().PlayerReplicationInfo.Team.TeamIndex;
    TeamNum = DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].TeamIndex;

      if (TeamNum == 0) {
         EnemyTeamNum = 1;
      } else if (TeamNum == 1) {
         EnemyTeamNum = 0;
      }
   //} else {
   //   TeamNum = -1;
    //  EnemyTeamNum = -1;
   //}

    scaleX = 0.5;
    scaleY = 0.5;

    StatLocation = 130;
    StatSpace = 55;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + 30;
    TeamLeftMargin = 320 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamRankMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamKillsMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Score));


     StatLocation = 130;
    //your team
    Canvas.SetPos(TeamLeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamScoreMat[TeamNum],64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin+10,190*scaleY);
    Canvas.DrawText(string(TeamScores[TeamNum]));

    //enemy team
    Canvas.SetPos(TeamLeftMargin +40,StatLocation* scaleY);
    Canvas.DrawTile(TeamScoreMat[EnemyTeamNum],64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin+40+10, 190 * scaleY);
    Canvas.DrawText(string(TeamScores[EnemyTeamNum]));
}

/*****************************************************************
 * DrawCTFIcons - draw the ctf icons
 *
 *****************************************************************
 */
function DrawCTFIcons(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected)
{
    local float scaleX, scaleY;
    local int StatLocation, StatSpace, LeftMargin, LeftMarginPlus, TeamLeftMargin;
    local int TeamNum, EnemyTeamNum;
    local CTFFlag tempFlag;

    // Get team number
    //if (PlayerOwner().PlayerReplicationInfo.Team != none){
     // TeamNum = PlayerOwner().PlayerReplicationInfo.Team.TeamIndex;
    TeamNum = DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].TeamIndex;

      if (TeamNum == 0) {
         EnemyTeamNum = 1;
      } else if (TeamNum == 1) {
         EnemyTeamNum = 0;
      }
  // } else {
   //   TeamNum = -1;
   //   EnemyTeamNum = -1;
  // }

    scaleX = 0.5;
    scaleY = 0.5;

    StatLocation = 130;
    StatSpace = 55;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + 30;
    TeamLeftMargin = 320* scaleX;

/*
    // Rank
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamRankMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation*scaleY);
    Canvas.DrawText(string(PlayerOwner().PlayerReplicationInfo.Ranking));
    StatLocation += StatSpace;
*/
    // Score
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamCTFScoreMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Score));

    StatLocation = 130;

    // Which type of flag to draw
    foreach PlayerOwner().AllActors(class'CTFFlag', tempFlag){
      if (tempFlag.TeamType == 0){
         //red flag status
         if (tempFlag.bHome == true){
            RedFlagMat = FlagHomeMat[0];
         } else if (tempFlag.bHeld){
            RedFlagMat = FlagHeldMat[0];
         } else {
            RedFlagMat = FlagDropMat[0];
         }
      } else {
         //blue flag status
         if (tempFlag.bHome){
            BlueFlagMat = FlagHomeMat[1];
         } else if (tempFlag.bHeld){
            BlueFlagMat = FlagHeldMat[1];
         } else {
            BlueFlagMat = FlagDropMat[1];
         }
      }
   }

    //red team
    Canvas.SetPos(TeamLeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(RedFlagMat,64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin+10,190*scaleY);
    Canvas.DrawText(string(TeamScores[0]));

    //blue team
    Canvas.SetPos(TeamLeftMargin +40,StatLocation* scaleY);
    Canvas.DrawTile(BlueFlagMat,64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin+40+10, 190 * scaleY);
    Canvas.DrawText(string(TeamScores[1]));
}


/*****************************************************************
 * DrawINVIcons - draw the invasion icons
 *
 *****************************************************************
 */
function DrawINVIcons(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected)
{
    local float scaleX, scaleY;
    local int StatLocation, StatSpace, LeftMargin, LeftMarginPlus, TeamLeftMargin;

    scaleX = 0.5;
    scaleY = 0.5;

    StatLocation = 130;
    StatSpace = 55;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + 30;
    TeamLeftMargin = 320 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamRankMat[0],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(TeamKillsMat[0],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation*scaleY);
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Kills));


    StatLocation = 130;

    // wave number
    Canvas.SetPos(TeamLeftMargin,StatLocation* scaleY);
    Canvas.DrawTile(WaveMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(TeamLeftMargin+30,StatLocation*scaleY);
    Canvas.DrawText(string(TeamScores[0]));
}

/*
function RefreshAllInfo(){
    local int i, j, k;
    local bool bSkip;

    // Get all the PRI info
    //for(i=0;i<pris.length;i++){
    //  ObjMaker.FreeObject(pris[i]);
    //}
   // for(i=0;i<oldpris.length;i++){
    //  ObjMaker.FreeObject(oldpris[i]);
    //}

    pris.Remove(0, pris.Length);
    oldpris.Remove(0, oldpris.Length);
    for( i=0; i<PlayerOwner().GameReplicationInfo.PRIArray.Length; i++ )
    {
        //if( pris[i] == None )
            //pris[i] = PlayerReplicationInfo(ObjMaker.AllocateObject(class'PlayerReplicationInfo'));
            pris.Length = pris.Length + 1;
        pris[i].Gamertag = PlayerOwner().GameReplicationInfo.PRIArray[i].Gamertag;
        pris[i].PlayerName = PlayerOwner().GameReplicationInfo.PRIArray[i].PlayerName;
        pris[i].Score = PlayerOwner().GameReplicationInfo.PRIArray[i].Score;
        pris[i].Deaths = PlayerOwner().GameReplicationInfo.PRIArray[i].Deaths;
        pris[i].TeamIndex = PlayerOwner().GameReplicationInfo.PRIArray[i].Team.TeamIndex;
        pris[i].TeamID = PlayerOwner().GameReplicationInfo.PRIArray[i].TeamID;
        pris[i].xnaddr = PlayerOwner().GameReplicationInfo.PRIArray[i].xnaddr;
        pris[i].xuid = PlayerOwner().GameReplicationInfo.PRIArray[i].xuid;
        pris[i].Ranking = PlayerOwner().GameReplicationInfo.PRIArray[i].Ranking;
        pris[i].Kills = PlayerOwner().GameReplicationInfo.PRIArray[i].Kills;

        if( PlayerOwner().GameReplicationInfo.PRIArray[i] == PlayerOwner().PlayerReplicationInfo )
            myPRIIndex = i;
    }

    k = 0;
    for( i=0; i<PlayerOwner().GameReplicationInfo.OldPRIArray.Length; i++ )
    {
        bSkip = false;
        for( j=0; j<pris.length; j++ )
        {
            if( pris[j].Gamertag == PlayerOwner().GameReplicationInfo.OldPRIArray[i].Gamertag )
            {
                bSkip = true;
                break;
            }
        }
        if(bSkip)
            continue;
        for( j=0; j<oldpris.length; j++ )
        {
            if( oldpris[j].Gamertag == PlayerOwner().GameReplicationInfo.OldPRIArray[i].Gamertag )
            {
                bSkip = true;
                break;
            }
        }
        if(bSkip)
            continue;

        //if( oldpris[i] == None )
            //oldpris[k] = PlayerReplicationInfo(ObjMaker.AllocateObject(class'PlayerReplicationInfo'));
            oldpris.Length = oldpris.Length + 1;
        oldpris[k].Gamertag = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Gamertag;
        oldpris[k].PlayerName = PlayerOwner().GameReplicationInfo.OldPRIArray[i].PlayerName;
        oldpris[k].Score = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Score;
        oldpris[k].Deaths = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Deaths;
        oldpris[k].TeamIndex = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Team.TeamIndex;
        oldpris[k].TeamID = PlayerOwner().GameReplicationInfo.OldPRIArray[i].TeamID;
        oldpris[k].xnaddr = PlayerOwner().GameReplicationInfo.OldPRIArray[i].xnaddr;
        oldpris[k].xuid = PlayerOwner().GameReplicationInfo.OldPRIArray[i].xuid;
        oldpris[k].Ranking = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Ranking;
        oldpris[k].Kills = PlayerOwner().GameReplicationInfo.OldPRIArray[i].Kills;
        k++;
    }

    // Take out any duplicates
    //FilterDuplicates();
    // Sort the array & do ranking
    SortListByWhatever();

    // Get the GameRepInfo stuff
    //if( PlayerOwner().GameReplicationInfo.Teams != None)
    //{
        TeamScores[0] = int(PlayerOwner().GameReplicationInfo.Teams[0].Score);
        TeamScores[1] = int(PlayerOwner().GameReplicationInfo.Teams[1].Score);
    //}
}
*/


//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBXListBox Name=PlayerDisplay_btn
         bVisibleWhenEmpty=True
         StyleName="BBXInvisible"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.220000
         WinLeft=0.010000
         WinWidth=0.955000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZLivePlayersListIG.ButtonClicked
         Name="PlayerDisplay_btn"
     End Object
     PlayerDisplay=BBXListBox'DOTZMenu.XDOTZLivePlayersListIG.PlayerDisplay_btn'
     Begin Object Class=GUILabel Name=DeathsLabel_lbl
         Caption="Deaths"
         TextFont="XPlainLittleFont"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.150000
         WinLeft=0.700000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="DeathsLabel_lbl"
     End Object
     DeathsLabel=GUILabel'DOTZMenu.XDOTZLivePlayersListIG.DeathsLabel_lbl'
     Begin Object Class=GUILabel Name=KillsLabel_lbl
         Caption="Kills"
         TextFont="XPlainLittleFont"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.150000
         WinLeft=0.810000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="KillsLabel_lbl"
     End Object
     KillsLabel=GUILabel'DOTZMenu.XDOTZLivePlayersListIG.KillsLabel_lbl'
     PageCaption="Players"
     PlayerSelectMenu="DOTZMenu.XDOTZLivePlayerSelectIG"
     ClickSound=Sound'DOTZXInterface.Select'
     KillsMat=Texture'DOTZTInterface.HUD.HudIconNoTeamKills'
     RankMat=Texture'DOTZTInterface.HUD.HudIconNoTeamPlayerRank'
     TeamScoreMat(0)=Texture'DOTZTInterface.HUD.HudIconTDMTeamRed'
     TeamScoreMat(1)=Texture'DOTZTInterface.HUD.HudIconTDMTeamBlue'
     TeamKillsMat(0)=Texture'DOTZTInterface.HUD.HudIconRedKills'
     TeamKillsMat(1)=Texture'DOTZTInterface.HUD.HudIconBlueKills'
     TeamRankMat(0)=Texture'DOTZTInterface.HUD.HudIconRedPlayerRank'
     TeamRankMat(1)=Texture'DOTZTInterface.HUD.HudIconBluePlayerRank'
     FlagHomeMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagAtBase'
     FlagHomeMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagAtBase'
     FlagHeldMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagStolen'
     FlagHeldMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagStolen'
     FlagDropMat(0)=Texture'DOTZTInterface.HUD.HudIconCTFTeamRedFlagDropped'
     FlagDropMat(1)=Texture'DOTZTInterface.HUD.HudIconCTFTeamBlueFlagDropped'
     TeamCTFScoreMat(0)=Texture'DOTZTInterface.HUD.HudIconRedPlayerScore'
     TeamCTFScoreMat(1)=Texture'DOTZTInterface.HUD.HudIconBluePlayerScore'
     WaveMat=Texture'DOTZTInterface.HUD.HudIconINRedWaves'
     Begin Object Class=BBXListBox Name=IconPage_img
         bVisibleWhenEmpty=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.050000
         WinLeft=0.010000
         WinWidth=0.920000
         WinHeight=0.170000
         Name="IconPage_img"
     End Object
     IconPage=BBXListBox'DOTZMenu.XDOTZLivePlayersListIG.IconPage_img'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLivePlayersListIG.HandleKeyEvent
}
