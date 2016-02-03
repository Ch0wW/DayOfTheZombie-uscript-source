// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZSLCreateMatch extends XDOTZBaseCreateMatch;



//configurable stuff
var localized string PageCaption;
var localized string DefaultMatchName;
var localized string DefaultPlayerName;

var string ErrorMenu;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);

   SetPageCaption (PageCaption);
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
 * A Button pressed
 *****************************************************************
 */

/*function DoButtonA ()
{

}*/

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
 * StartHosting
 *****************************************************************
 */

function StartHosting () {
    local int error;

    local string matchname;
    local string playername;
    local string mapname;
    local int gametype;
    local int scorelimit;
    local int timelimit;
    local int maxplayers;
    local bool FriendlyFire;
    local int enemystrength;

    // Check errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    if (error > 0) {
        Controller.OpenMenu(ErrorMenu);
    } else {

        // Get the match name
        if (class'UtilsXbox'.static.Is_Signed_In()) {
             matchname = class'UtilsXbox'.static.Get_Current_Name() $ " - " $ IntToGameType (GametypeSelect.List.Index);
             playername = class'UtilsXbox'.static.Get_Current_Name();
        } else {
             matchname = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName() $ " - " $ IntToGameType (GametypeSelect.List.Index);
             playername = DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName();
             if (matchname == "") {
                matchname = DefaultMatchName $ " - " $ IntToGameType (GametypeSelect.List.Index);
                playername = DefaultPlayerName;
             }
        }

        gametype = GametypeSelect.List.Index;               // index is value
        mapname = GetActualMapName (gametype, MapsSelect.List.Index);
        scorelimit = int(ScoreLimitValue.GetExtra());
        timelimit = int(TimeLimitSelect.GetExtra()); //TimeLimitIndexToMinutes (TimeLimitSelect.List.Index);
        maxplayers = MaxPlayersValue.List.Index + 1;           // index is value
        FriendlyFire = (FriendlyFireValue.List.Index == 1);   // index is value (0 or 1)
        enemystrength = EnemyStrengthValue.List.Index;

        class'UtilsXbox'.static.SysLink_Host_Set_Match_Name (matchname);
        class'UtilsXbox'.static.Set_Reboot_Type(1);   // Is syslink host

        if (class'UtilsXbox'.static.Is_Signed_In()) {
            Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect",mapname
                        $ "?FriendlyFire=" $ friendlyfire
                        $ "?TimeLimit=" $ timelimit
                        $ "?GoalScore=" $ scorelimit
                        $ "?IsTeam=" $ bIsTeamMatch
                        $ "?EnemyStrength=" $ enemystrength
                        $ "?MaxPlayers=" $ maxplayers
                        $ "?XGAMERTAG=" $ EncodeStringURL(playername)
                        //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                        //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
                        $ "?Listen");

        } else {
            Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect",mapname
                        $ "?FriendlyFire=" $ friendlyfire
                        $ "?TimeLimit=" $ timelimit
                        $ "?GoalScore=" $ scorelimit
                        $ "?IsTeam=" $ bIsTeamMatch
                        $ "?EnemyStrength=" $ enemystrength
                        $ "?MaxPlayers=" $ maxplayers
                        $ "?XGAMERTAG=" $ EncodeStringURL(playername)
                        $ "?XUID=0"
                        //$ "?XNADDR=0"
                        $ "?Listen");

        }
    }
}



/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     PageCaption="Create System Link Match"
     DefaultMatchName="System Link"
     DefaultPlayerName="Host Player"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     ClickSound=Sound'DOTZXInterface.Select'
     __OnKeyEvent__Delegate=XDOTZSLCreateMatch.HandleKeyEvent
}
