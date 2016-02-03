// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZLiveMultiplayer
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class XDOTZLiveQuickMatch extends XDOTZLiveMatchPage;



//Page components
var Automated GuiLabel   SessionNameTitleLabel;
var Automated GuiLabel   GametypeTitleLabel;
var Automated GuiLabel   MapNameTitleLabel;
var Automated GuiLabel   TimeLimitTitleLabel;
var Automated GuiLabel   ScoreLimitTitleLabel;
var Automated GuiLabel   MaxPlayersTitleLabel;
var Automated GuiLabel   FriendlyFireTitleLabel;

var Automated GuiLabel   SessionNameValueLabel;
var Automated GuiLabel   GametypeValueLabel;
var Automated GuiLabel   MapNameValueLabel;
var Automated GuiLabel   TimeLimitValueLabel;
var Automated GuiLabel   ScoreLimitValueLabel;
var Automated GuiLabel   MaxPlayersValueLabel;
var Automated GuiLabel   FriendlyFireValueLabel;

var int match_num;

//configurable stuff
var localized string PageCaption;

// Menu locations
var string    ErrorMenu;
var string    NoSessionsMenu;

//
var string    EmptyEntry;

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
   AddNextButton ();
}


/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */

event Opened( GUIComponent Sender ) {
    super.Opened(Sender);

    UpdateSessionText ();
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

/*function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;


    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case QuickMatchButton:
             return Controller.OpenMenu(QuickMatchMenu); break;

        case OptimatchButton:
             return Controller.OpenMenu(OptimatchMenu); break;

        case CreateMatchButton:
             return Controller.OpenMenu(CreateMatchMenu); break;

        case FriendsListButton:
             return Controller.OpenMenu(FriendsListMenu); break;

        case DashboardButton:
             class'UtilsXbox'.static.Do_Dashboard();
             return false;
             break;

        case SignOutButton:
             return BBGuiController(Controller).CloseTo ('XDOTZLiveSignIn');
             //return Controller.OpenMenu(SignOutMenu); break;
    };

   return false;
}*/

/*****************************************************************
 * A Button pressed
 *****************************************************************
 */

function DoButtonA ()
{
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
 * X Button pressed
 *****************************************************************
 */

function DoButtonX ()
{
    local int numsessions;
    numsessions = class'UtilsXbox'.static.Match_Get_Num_Sessions ();

    match_num++;

    if (match_num >= numsessions) {
        match_num = 0;
    }

    UpdateSessionText ();
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
 * UpdateSessionText
 *****************************************************************
 */

function UpdateSessionText ()
{
    local int numsessions;

    local string sessionname;
    local int gametype;
    local int mapindex;
    local int timelimit;
    local int scorelimit;
    local int FriendlyFire;
    local int maxplayers;

    numsessions = class'UtilsXbox'.static.Match_Get_Num_Sessions ();

    if (match_num < numsessions) {
        class'UtilsXbox'.static.Match_Select (match_num);

        sessionname = class'UtilsXbox'.static.Match_Get_SessionName ();
        gametype = class'UtilsXbox'.static.Match_Get_Gametype ();
        mapindex = class'UtilsXbox'.static.Match_Get_Map_Index ();
        timelimit = class'UtilsXbox'.static.Match_Get_TimeLimit ();
        scorelimit = class'UtilsXbox'.static.Match_Get_ScoreLimit ();
        maxplayers = class'UtilsXbox'.static.Match_Get_MaxPlayers ();
        FriendlyFire = class'UtilsXbox'.static.Match_Get_RegenerateAmmo ();

        SessionNameValueLabel.Caption = sessionname;
        GametypeValueLabel.Caption = IntToGameType (gametype);
        MapNameValueLabel.Caption = IntToMap (mapindex);
        TimeLimitValueLabel.Caption = string(timelimit);
        ScoreLimitValueLabel.Caption = string(scorelimit);
        MaxPlayersValueLabel.Caption = string(maxplayers);
        FriendlyFireValueLabel.Caption = IntToYesNo(FriendlyFire);
    } else {
        SessionNameValueLabel.Caption = EmptyEntry;
        GametypeValueLabel.Caption = EmptyEntry;
        TimeLimitValueLabel.Caption = EmptyEntry;
        ScoreLimitValueLabel.Caption = EmptyEntry;
        MaxPlayersValueLabel.Caption = EmptyEntry;
        FriendlyFireValueLabel.Caption = EmptyEntry;
    }

}

/*****************************************************************
 * Default properties
 *****************************************************************
 */

defaultproperties
{
     Begin Object Class=GUILabel Name=SessionNameTitleLabel_lbl
         Caption="Session Name:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="SessionNameTitleLabel_lbl"
     End Object
     SessionNameTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.SessionNameTitleLabel_lbl'
     Begin Object Class=GUILabel Name=GametypeTitleLabel_lbl
         Caption="Game Type:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.280000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="GametypeTitleLabel_lbl"
     End Object
     GametypeTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.GametypeTitleLabel_lbl'
     Begin Object Class=GUILabel Name=MapNameTitleLabel_lbl
         Caption="Map Name:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.360000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MapNameTitleLabel_lbl"
     End Object
     MapNameTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.MapNameTitleLabel_lbl'
     Begin Object Class=GUILabel Name=TimeLimitTitleLabel_lbl
         Caption="Time Limit:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.440000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="TimeLimitTitleLabel_lbl"
     End Object
     TimeLimitTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.TimeLimitTitleLabel_lbl'
     Begin Object Class=GUILabel Name=ScoreLimitTitleLabel_lbl
         Caption="Score Limit:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.520000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ScoreLimitTitleLabel_lbl"
     End Object
     ScoreLimitTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.ScoreLimitTitleLabel_lbl'
     Begin Object Class=GUILabel Name=MaxPlayersTitleLabel_lbl
         Caption="Max Players:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MaxPlayersTitleLabel_lbl"
     End Object
     MaxPlayersTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.MaxPlayersTitleLabel_lbl'
     Begin Object Class=GUILabel Name=FriendlyFireTitleLabel_lbl
         Caption="Regenerate Ammo:"
         StyleName="BBXTextButton"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.680000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="FriendlyFireTitleLabel_lbl"
     End Object
     FriendlyFireTitleLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.FriendlyFireTitleLabel_lbl'
     Begin Object Class=GUILabel Name=SessionNameValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.200000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="SessionNameValueLabel_lbl"
     End Object
     SessionNameValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.SessionNameValueLabel_lbl'
     Begin Object Class=GUILabel Name=GametypeValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.280000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="GametypeValueLabel_lbl"
     End Object
     GametypeValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.GametypeValueLabel_lbl'
     Begin Object Class=GUILabel Name=MapNameValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.360000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MapNameValueLabel_lbl"
     End Object
     MapNameValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.MapNameValueLabel_lbl'
     Begin Object Class=GUILabel Name=TimeLimitValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.440000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="TimeLimitValueLabel_lbl"
     End Object
     TimeLimitValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.TimeLimitValueLabel_lbl'
     Begin Object Class=GUILabel Name=ScoreLimitValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.520000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="ScoreLimitValueLabel_lbl"
     End Object
     ScoreLimitValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.ScoreLimitValueLabel_lbl'
     Begin Object Class=GUILabel Name=MaxPlayersValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.600000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="MaxPlayersValueLabel_lbl"
     End Object
     MaxPlayersValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.MaxPlayersValueLabel_lbl'
     Begin Object Class=GUILabel Name=FriendlyFireValueLabel_lbl
         Caption="..."
         TextFont="XPlainMedFont"
         bBoundToParent=True
         bScaleToParent=True
         bVisible=False
         WinTop=0.680000
         WinLeft=0.500000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="FriendlyFireValueLabel_lbl"
     End Object
     FriendlyFireValueLabel=GUILabel'DOTZMenu.XDOTZLiveQuickMatch.FriendlyFireValueLabel_lbl'
     PageCaption="Quick Match"
     NoSessionsMenu="DOTZMenu.XDOTZLiveNoSessionsError"
     EmptyEntry="..."
     ClickSound=Sound'DOTZXInterface.Select'
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnKeyEvent__Delegate=XDOTZLiveQuickMatch.HandleKeyEvent
}
