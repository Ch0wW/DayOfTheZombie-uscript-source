// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveCreateMatch extends XDOTZBaseCreateMatch;



var Automated GuiLabel       PrivateSlotsLabel;
var Automated BBXSelectBox   PrivateSlotsValue;

//configurable stuff
var localized string PageCaption;

var string ErrorMenu;

var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   Super.Initcomponent(MyController, MyOwner);

   // Max players
   FillInPrivateSlots(PrivateSlotsValue);
   PrivateSlotsValue.SetIndex(0);

   SetPageCaption (PageCaption);
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    // CARROT HACK!!!!
    SetFocus(GameTypeSelect);
    GameTypeSelect.SetFocus(none);
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

} */

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
    local string mapname;
    local int gametype;
    local int mapindex;
    local int scorelimit;
    local int timelimit;
    local int maxplayers;
    local bool privateslots;
    local bool friendlyfire;
    local int enemystrength;

    // Check errors
    error = class'UtilsXbox'.static.Get_Last_Error();
    if (error > 0) {
        Controller.OpenMenu(ErrorMenu);
    } else {
        matchname = class'UtilsXbox'.static.Get_Current_Name();              // Use live name as match name
        gametype = GametypeSelect.List.Index;                                 // index is value
        mapindex = MapToInt (gametype, MapsSelect.List.Index);
        mapname = GetActualMapName (gametype, MapsSelect.List.Index);
        scorelimit = int(ScoreLimitValue.GetExtra()); //ScoreLimitIndexToScore (ScoreLimitValue.List.Index);
        timelimit = int(TimeLimitSelect.GetExtra()); //TimeLimitIndexToMinutes (TimeLimitSelect.List.Index);
        maxplayers = MaxPlayersValue.List.Index + 1;
        privateslots = (PrivateSlotsValue.List.Index == 1);
        friendlyfire = (FriendlyFireValue.List.Index == 1);              // index is value (0 or 1)
        enemystrength = EnemyStrengthValue.List.Index;

        class'UtilsXbox'.static.Live_Host_Set_Match_Name        (matchname);
        class'UtilsXbox'.static.Live_Host_Set_Map_Name          (mapname);
        class'UtilsXbox'.static.Live_Host_Set_Game_Type         (gametype);
        class'UtilsXbox'.static.Live_Host_Set_Map_Index         (mapindex);
        class'UtilsXbox'.static.Live_Host_Set_Score_Limit       (scorelimit);
        class'UtilsXbox'.static.Live_Host_Set_Time_Limit        (timelimit);
        class'UtilsXbox'.static.Live_Host_Set_Max_Players       (maxplayers);
        class'UtilsXbox'.static.Live_Host_Set_Private_Slots     (int(privateslots));   // Actually a bool
        class'UtilsXbox'.static.Live_Host_Set_Regenerate_Ammo   (int(friendlyfire));

        class'UtilsXbox'.static.Set_Reboot_Type(3);   // Is live host


        // Reboot!
        //Console(Controller.Master.Console).ConsoleCommand("reboot");  // URL not part of command on xbox

        //PlayerOwner().Level.ServerTravel(mapname $ "?Listen",false);

      Controller.OpenMenu("DOTZMenu.XDOTZCharacterSelect",mapname
                    $ "?FriendlyFire=" $ friendlyfire
                    $ "?TimeLimit=" $ timelimit
                    $ "?GoalScore=" $ scorelimit
                    $ "?IsTeam=" $ bIsTeamMatch
                    $ "?EnemyStrength=" $ enemystrength
                    $ "?MaxPlayers=" $ maxplayers
                    $ "?Private=" $ privateslots
                    //$ "?XGAMERTAG=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Current_Name())
                    //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                    $ "?Listen");

        //NOTE: The XNADDR is a bit of a hack. It is only known after the reboot and the session is
        //created. Leaving it out will cause it to be set later. Live host only.

/*
         PlayerOwner().Level.ServerTravel(mapname
                    $ "?FriendlyFire=" $ friendlyfire
                    $ "?TimeLimit=" $ timelimit
                    $ "?GoalScore=" $ scorelimit
                    $ "?IsTeam=" $ bIsTeamMatch
                    //$ "?XGAMERTAG=" $ EncodeStringURL(class'UtilsXbox'.static.Get_Current_Name())
                    //$ "?XUID=" $ class'UtilsXbox'.static.Get_Current_ID()
                    //$ "?XNADDR=" $ class'UtilsXbox'.static.Get_Current_Address()
                    $ "?Listen", false);
  */
    }
}



/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=PrivateSlotsLabel_lbl
         Caption="Private Game:"
         StyleName="BBXTextStatic"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.690000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="PrivateSlotsLabel_lbl"
     End Object
     PrivateSlotsLabel=GUILabel'DOTZMenu.XDOTZLiveCreateMatch.PrivateSlotsLabel_lbl'
     Begin Object Class=BBXSelectBox Name=PrivateSlotsValue_lbl
         StyleName="BBXSquareButton"
         WinTop=0.710000
         WinLeft=0.450000
         WinWidth=0.400000
         WinHeight=0.060000
         Name="PrivateSlotsValue_lbl"
     End Object
     PrivateSlotsValue=BBXSelectBox'DOTZMenu.XDOTZLiveCreateMatch.PrivateSlotsValue_lbl'
     PageCaption="Create Live Match"
     ErrorMenu="DOTZMenu.XDOTZLiveError"
     ClickSound=Sound'DOTZXInterface.Select'
     __OnKeyEvent__Delegate=XDOTZLiveCreateMatch.HandleKeyEvent
}
