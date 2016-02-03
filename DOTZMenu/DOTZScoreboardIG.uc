// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZScoreboardIG extends DOTZPlayersListIG;

var Automated GUILabel EndGameLabel;
var localized string endGameMsg;

var bool bInit;


/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner ) {
    local int i, c;
   Super.Initcomponent(MyController, MyOwner);

    EndGameLabel.Caption = endGameMsg;
    DOTZPlayerControllerBase(PlayerOwner()).RefreshPRI( gametype );
    TeamScores[0] = int(PlayerOwner().GameReplicationInfo.Teams[0].Score);
    TeamScores[1] = int(PlayerOwner().GameReplicationInfo.Teams[1].Score);
    //SortListByWhatever();

    PlayerDisplay.List.Clear();
    c = DOTZPlayerControllerBase(PlayerOwner()).pris.Length + DOTZPlayerControllerBase(PlayerOwner()).oldpris.Length;
    for (i = 0; i < c; ++i) {
        PlayerDisplay.List.Add("");
    }

    bInit = false;
}

/*****************************************************************
 * This gets called every 1/2 second
 *****************************************************************
 */

function Periodic ()
{
    local int i, c;
    if( !bInit )
    {
        DOTZPlayerControllerBase(PlayerOwner()).RefreshPRI( gametype );
        TeamScores[0] = int(PlayerOwner().GameReplicationInfo.Teams[0].Score);
        TeamScores[1] = int(PlayerOwner().GameReplicationInfo.Teams[1].Score);
        //SortListByWhatever();

        PlayerDisplay.List.Clear();
        c = DOTZPlayerControllerBase(PlayerOwner()).pris.Length + DOTZPlayerControllerBase(PlayerOwner()).oldpris.Length;
        for (i = 0; i < c; ++i) {
            PlayerDisplay.List.Add("");
        }
        bInit = true;
    }
}

/*****************************************************************
 * Refresh the accounts list
 *****************************************************************
 */
function Refresh_Players_List () {
    local int num_players;
    local int friend_id;

    //local int current_item_index;

    // Retrieve the current selection
    //current_item_index = PlayerDisplay.List.Index;

    // Clear the friends list
    PlayerDisplay.List.Clear();

    // Get the Pri array
    //PlayerOwner().GameReplicationInfo.GetPRIArray(pris);
    //PlayerOwner().GameReplicationInfo.GetOldPRIArray(oldpris);
    //FilterDuplicates();


    //SortListByWhatever();

    num_players = DOTZPlayerControllerBase(PlayerOwner()).pris.Length + DOTZPlayerControllerBase(PlayerOwner()).oldpris.length;
    for (friend_id = 0; friend_id < num_players; ++friend_id) {
        PlayerDisplay.List.Add("");
    }

    // If the item went missing, try to keep the selection at the same index
    /*if (current_item_index >= PlayerDisplay.List.ItemCount) {
        PlayerDisplay.List.Index = PlayerDisplay.List.ItemCount - 1;
    } else {
        PlayerDisplay.List.Index = current_item_index;
    }*/

}

/*****************************************************************
 * DrawActivePlayer
 * Draws all the details of a player that is still in the game to
 * the Display List.
 *****************************************************************
 */

function DrawActivePlayer(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
    super.DrawActivePlayer(Canvas, Item, X, Y, W, H, false);
}

/*****************************************************************
 * DrawInactivePlayer
 * Draws the inactive player to an element in the Display list
 *****************************************************************
 */
function DrawInactivePlayer(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){
    super.DrawInactivePlayer(Canvas, Item, X, Y, W, H, false);
}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */
function bool ButtonClicked(GUIComponent Sender) {
    return false;
}

defaultproperties
{
     Begin Object Class=GUILabel Name=EndGameLabel_lbl
         TextFont="XPlainSmallFont"
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.050000
         WinLeft=0.400000
         WinWidth=0.800000
         WinHeight=0.100000
         Name="EndGameLabel_lbl"
     End Object
     EndGameLabel=GUILabel'DOTZMenu.DOTZScoreboardIG.EndGameLabel_lbl'
     endGameMsg="Match over. Loading next map."
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
     __OnKeyEvent__Delegate=DOTZScoreboardIG.HandleKeyEvent
}
