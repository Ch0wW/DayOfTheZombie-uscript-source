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

class DOTZPlayersListIG extends DOTZInGamePage;




const REFX = 1280;
const REFY = 960;

//Page components
var Automated BBListBox  PlayerDisplay;
var Automated GUILabel NameLabel;
var Automated GUILabel DeathsLabel;
var Automated GUILabel ScoreLabel;
var Automated GUILabel KillsLabel;

var Automated GUIButton   BackButtonLabel;

var ObjectPool objMaker;

//configurable stuff
var localized string PageCaption;
var localized string score_txt;
var localized string kills_txt;
var localized string captures_txt;

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
var int TabKey;

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

   local int i;
    local string keyname, localizedkeyname, alias;

   Super.Initcomponent(MyController, MyOwner);
   // init my components...
    accept_input = false;
   PlayerDisplay.List.OnDrawItem = DrawBinding;
   bTeamGame = PlayerOwner().GameReplicationInfo.bTeamGame;

    if (PlayerOwner().myHUD.class == class'DOTZDeathMatchHUD'){
       if (bTeamGame == false){
         gametype = 1;
       } else {
         gametype = 2;
       }
    } else if (PlayerOwner().myHUD.class == class'DOTZCaptureTheFlagHUD'){
       gametype = 2;
    } else if (PlayerOwner().myHUD.class == class'DOTZInvasionHUD'){
       gametype = 4;
    }

   // if DM or TDM, change Kills to Score
   if( gametype == 1 || gametype == 2 )
   {
        KillsLabel.Caption = score_txt;
        KillsLabel.WinLeft = 0.85;
   } else if( gametype == 4 )
   {
        KillsLabel.Caption = kills_txt;
        KillsLabel.WinLeft = 0.85;
   } else if( gametype == 3 ) // CTF -> use Captures
        KillsLabel.Caption = captures_txt;

   Refresh_Players_List ();

    // Add a fake entry, then draw icons on list
   IconPage.List.Add("");
   if ( gametype == 1 )
        IconPage.List.OnDrawItem = DrawDMIcons;
   else if ( gametype == 2 )
        IconPage.List.OnDrawItem = DrawTDMIcons;
   else if ( gametype == 3 )
        IconPage.List.OnDrawItem = DrawCTFIcons;
   else if ( gametype == 4 )
        IconPage.List.OnDrawItem = DrawINVIcons;

   for (i=0;i<255;i++){
      KeyName = PlayerOwner().ConsoleCommand("KEYNAME"@i);
      LocalizedKeyName = PlayerOwner().ConsoleCommand("LOCALIZEDKEYNAME"@i);
      if (KeyName!=""){
         Alias = PlayerOwner().ConsoleCommand("KEYBINDING"@KeyName);
         if (Alias == "ToggleObjectivesDisplay"){
            TabKey = i;
            break;
         }
      }
   }

    Log("Match ID " $ PlayerOwner().GameReplicationInfo.MatchID);
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied here.
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {

}

function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

    // A short pause
    if (!accept_input) return false;

    // Key down only
    if (State != 1) return false;

    if (Key == 27) {  //Esc
        // Unpause if this is the last menu
        if (BBGUIController(Controller).GetMenuStackSize() == 1) {
            Controller.ViewportOwner.Actor.SetPause(false);
        }
        Controller.CloseMenu(true);
    }

     if (Key == TabKey){
        Controller.CloseMenu(true);
     }

   return true;
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
   //CheckGameType();
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
   local int           f;
   local color         colors[5];
   local GUIFont       Fonts[5];


  //if (pris[Item] == none){
    //  return;
   //}

   // Retrieve the item
   gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).pris[Item].Gamertag);
   if (Len(gamer_tag) > MAX_TAG_LEN){
      gamer_tag = Left(gamer_tag, MAX_TAG_LEN) $ "...";
   }

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

   //if (bSelected) {
     // Canvas.SetPos(X,Y);
      //Canvas.DrawTileStretched( PlayerDisplay.List.SelectedImage, W,H );

      // Update the status and gamertag items
      //GamertagField.Caption = gamer_tag;
      //StatusField.Caption = Get_Status_String();
   //}

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
   local GUIFont       Fonts[5];


   gamer_tag = DecodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).oldpris[Item].Gamertag);
   if (Len(gamer_tag) > MAX_TAG_LEN){
      gamer_tag = Left(gamer_tag, MAX_TAG_LEN) $ "...";
   }
   //Deaths = oldpris[Item].Deaths;
   //Score = oldpris[Item].Score;
   //Kills = oldpris[Item].Kills;

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

 // if (bSelected) {
   //   Canvas.SetPos(X,Y);
    //  Canvas.DrawTileStretched( PlayerDisplay.List.SelectedImage, W+W*0.02,H );

      // Update the status and gamertag items
      //GamertagField.Caption = gamer_tag;
      //StatusField.Caption = Get_Status_String();
  // }

}



/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    local BBListBox Selected;

    if (!accept_input)
        return true;

    if (BBListBox(Sender) != None) Selected = BBListBox(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case PlayerDisplay:
             break;
    };

   return true;
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

    //Log("DrawDMIcons");

    scaleX = canvas.clipX / REFX;
    scaleY = canvas.clipY / REFY;

    StatLocation = 130 * scaleY;
    StatSpace = 55 * scaleY;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + (50 * scaleX);
    TeamLeftMargin = 170 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(RankMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation + (10 * ScaleY));
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(KillsMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation+ (10 * ScaleY));
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

    //Log("DrawTDMIcons");

    scaleX = canvas.clipX / REFX;
    scaleY = canvas.clipY / REFY;

    // Get team number
    //if (PlayerOwner().PlayerReplicationInfo.Team != none){
      //TeamNum = PlayerOwner().PlayerReplicationInfo.Team.TeamIndex;
    TeamNum = DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].TeamIndex;

      if (TeamNum == 0) {
         EnemyTeamNum = 1;
      } else if (TeamNum == 1) {
         EnemyTeamNum = 0;
      }

    StatLocation = 130 * scaleY;
    StatSpace = 55 * scaleY;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + (50 * scaleX);
    TeamLeftMargin = 320 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(TeamRankMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation + (10 * ScaleY));
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(TeamKillsMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation + (10 * ScaleY));
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Score));


     StatLocation = 130 * scaleY;

    //your team
    Canvas.SetPos(TeamLeftMargin,StatLocation);
    Canvas.DrawTile(TeamScoreMat[TeamNum],64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin + (10 * scaleX),190*scaleY);
    Canvas.DrawText(string(TeamScores[TeamNum]));

    //enemy team
    Canvas.SetPos(TeamLeftMargin + (70 * scaleX),StatLocation);
    Canvas.DrawTile(TeamScoreMat[EnemyTeamNum],64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin+(80 * scaleX), 190 * scaleY);
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

    //Log("DrawCTFIcons");

    // Get team number
    //if (PlayerOwner().PlayerReplicationInfo.Team != none){
     // TeamNum = PlayerOwner().PlayerReplicationInfo.Team.TeamIndex;
    TeamNum = DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].TeamIndex;

      if (TeamNum == 0) {
         EnemyTeamNum = 1;
      } else if (TeamNum == 1) {
         EnemyTeamNum = 0;
      }
    scaleX = canvas.clipX / REFX;
    scaleY = canvas.clipY / REFY;

    StatLocation = 130 * scaleY;
    StatSpace = 55 * scaleY;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + (50 * scaleX);
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
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(TeamCTFScoreMat[TeamNum],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation + (10 * ScaleY));
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
    Canvas.SetPos(TeamLeftMargin,StatLocation);
    Canvas.DrawTile(RedFlagMat,64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin + (10 * scaleX),190*scaleY);
    Canvas.DrawText(string(TeamScores[0]));

    //blue team
    Canvas.SetPos(TeamLeftMargin + (70 * scaleX),StatLocation* scaleY);
    Canvas.DrawTile(BlueFlagMat,64*scaleX,128*scaleY,0,0,64,128);
    Canvas.SetPos(TeamLeftMargin + (80 * scaleX), 190 * scaleY);
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

    //Log("DrawINVIcons");

    scaleX = canvas.clipX / REFX;
    scaleY = canvas.clipY / REFY;

    StatLocation = 130 * scaleY;
    StatSpace = 55 * scaleY;
    LeftMargin = 170 * scaleX;
    LeftMarginPlus = LeftMargin + (50 * scaleX);
    TeamLeftMargin = 320 * scaleX;

    // Rank
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(TeamRankMat[0],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus,StatLocation+ (10 * ScaleY) );
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Ranking));
    StatLocation += StatSpace;

    // Score
    Canvas.SetPos(LeftMargin,StatLocation);
    Canvas.DrawTile(TeamKillsMat[0],128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(LeftMarginPlus, StatLocation+ (10 * ScaleY));
    Canvas.DrawText(string(DOTZPlayerControllerBase(PlayerOwner()).pris[DOTZPlayerControllerBase(PlayerOwner()).myPRIIndex].Kills));


    StatLocation = 130 * scaleY;

    // wave number
    Canvas.SetPos(TeamLeftMargin,StatLocation);
    Canvas.DrawTile(WaveMat,128*scaleX,64*scaleY,0,0,128,64);
    Canvas.SetPos(TeamLeftMargin+ (60 * scaleX),StatLocation+ (10 * ScaleY));
    Canvas.DrawText(string(TeamScores[0]));
}

/*****************************************************************
 * ButtonClicked
 *****************************************************************
 */

function bool ButtonClickedBack( GUIComponent Sender ) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    if (Sender == BackButtonLabel) {
        Controller.CloseMenu(true);
    }

    return true;
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBListBox Name=PlayerDisplay_btn
         bVisibleWhenEmpty=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.220000
         WinLeft=0.040000
         WinWidth=0.920000
         WinHeight=0.600000
         __OnClick__Delegate=DOTZPlayersListIG.ButtonClicked
         Name="PlayerDisplay_btn"
     End Object
     PlayerDisplay=BBListBox'DOTZMenu.DOTZPlayersListIG.PlayerDisplay_btn'
     Begin Object Class=GUILabel Name=DeathsLabel_lbl
         Caption="Deaths"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.150000
         WinLeft=0.700000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="DeathsLabel_lbl"
     End Object
     DeathsLabel=GUILabel'DOTZMenu.DOTZPlayersListIG.DeathsLabel_lbl'
     Begin Object Class=GUILabel Name=KillsLabel_lbl
         Caption="Kills"
         StyleName="BBTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.150000
         WinLeft=0.810000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="KillsLabel_lbl"
     End Object
     KillsLabel=GUILabel'DOTZMenu.DOTZPlayersListIG.KillsLabel_lbl'
     Begin Object Class=GUIButton Name=BackButtonLabel_lbl
         Caption="Back"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.910000
         WinLeft=0.100000
         WinWidth=0.200000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZPlayersListIG.ButtonClickedBack
         Name="BackButtonLabel_lbl"
     End Object
     BackButtonLabel=GUIButton'DOTZMenu.DOTZPlayersListIG.BackButtonLabel_lbl'
     PageCaption="Players"
     score_txt="Score"
     kills_txt="Kills"
     captures_txt="Captures"
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
         WinLeft=0.040000
         WinWidth=0.920000
         WinHeight=0.170000
         Name="IconPage_img"
     End Object
     IconPage=BBXListBox'DOTZMenu.DOTZPlayersListIG.IconPage_img'
     __OnKeyEvent__Delegate=DOTZPlayersListIG.HandleKeyEvent
}
